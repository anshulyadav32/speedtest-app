import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:speedtest/dummy_data/history_list_item.dart';
import 'package:speedtest/services/integrity_service.dart';

enum TestPhase { idle, ping, download, upload, done }

class SpeedTestProvider extends ChangeNotifier {
  SpeedTestProvider({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _networkChannel =
      MethodChannel('com.aydigitalcentre.speedest/network_info');

  final List<Items> _history = [];
  List<Items> get history => List.unmodifiable(_history);

  TestPhase _phase = TestPhase.idle;
  TestPhase get phase => _phase;

  bool get isTesting =>
      _phase == TestPhase.ping ||
      _phase == TestPhase.download ||
      _phase == TestPhase.upload;

  double _gaugeValue = 0;
  double get gaugeValue => _gaugeValue;

  double _download = 0;
  double get download => _download;

  double _upload = 0;
  double get upload => _upload;

  int _ping = 0;
  int get ping => _ping;

  String _publicIp = '--';
  String get publicIp => _publicIp;

  // Network / operator info
  String _connectionType = 'unknown'; // "wifi" | "mobile" | "none"
  String get connectionType => _connectionType;

  bool get isWifi => _connectionType == 'wifi';

  String _networkName = '--'; // WiFi SSID or operator name
  String get networkName => _networkName;

  IconData get networkIcon => isWifi ? Icons.wifi : Icons.signal_cellular_alt;

  // Play Integrity status: null = not checked, 'certified' = OK, 'uncertified' = failed
  String? _integrityStatus;
  String? get integrityStatus => _integrityStatus;

  static const _pingUrl = 'https://speed.cloudflare.com/__down?bytes=1024';
  // 25 MB for native, 5 MB for web (XHR buffers the whole body — smaller = faster)
  static String get _downloadUrl => kIsWeb
      ? 'https://speed.cloudflare.com/__down?bytes=5000000'
      : 'https://speed.cloudflare.com/__down?bytes=25000000';
  static const _uploadUrl = 'https://speed.cloudflare.com/__up';
  // format=json ensures CORS headers are sent by ipify on web
  static const _ipUrl = 'https://api.ipify.org?format=json';

  Future<void> startTest() async {
    if (isTesting) return;

    _phase = TestPhase.ping;
    _download = 0;
    _upload = 0;
    _ping = 0;
    _gaugeValue = 0;
    _publicIp = '--';
    _networkName = '--';
    notifyListeners();

    // Request location permission for WiFi SSID (Android 8+) — skip on web
    if (!kIsWeb) {
      await Permission.locationWhenInUse.request();
    }

    // Fetch public IP, network info, and integrity status concurrently with ping
    _fetchPublicIp();
    _fetchNetworkInfo();
    _checkIntegrity();

    // Ping: measure round-trip latency
    try {
      final sw = Stopwatch()..start();
      await _client.get(Uri.parse(_pingUrl));
      sw.stop();
      _ping = sw.elapsedMilliseconds;
    } catch (_) {
      _ping = 0;
    }
    notifyListeners();

    // Download phase
    _phase = TestPhase.download;
    _gaugeValue = 0;
    notifyListeners();

    if (kIsWeb) {
      // On web, BrowserClient (XHR) buffers the whole response — no progressive
      // chunks. Animate the gauge via a timer and measure total time.
      try {
        const webDownloadBytes = 5 * 1024 * 1024; // 5 MB
        final sw = Stopwatch()..start();
        Timer? timer;
        timer = Timer.periodic(const Duration(milliseconds: 150), (_) {
          final elapsed = sw.elapsedMilliseconds;
          if (elapsed > 0) {
            // estimate based on elapsed — will be corrected on completion
            final est = (webDownloadBytes * 8) / (elapsed * 1000.0);
            _gaugeValue = est;
            notifyListeners();
          }
        });
        final response = await _client.get(Uri.parse(_downloadUrl));
        sw.stop();
        timer.cancel();
        final elapsed = sw.elapsedMilliseconds;
        if (elapsed > 0 && response.statusCode == 200) {
          final mbps = (response.bodyBytes.length * 8) / (elapsed * 1000.0);
          _download = double.parse(mbps.toStringAsFixed(1));
          _gaugeValue = _download;
        }
      } catch (_) {
        _download = 0;
      }
    } else {
      // Native: stream chunks progressively for live gauge updates
      try {
        final request = http.Request('GET', Uri.parse(_downloadUrl));
        final response = await _client.send(request);

        int bytesReceived = 0;
        final sw = Stopwatch()..start();

        await for (final chunk in response.stream) {
          bytesReceived += chunk.length;
          final elapsed = sw.elapsedMilliseconds;
          if (elapsed > 0) {
            final mbps = (bytesReceived * 8) / (elapsed * 1000.0);
            _gaugeValue = mbps;
            _download = double.parse(mbps.toStringAsFixed(1));
            notifyListeners();
          }
        }

        sw.stop();
        final elapsed = sw.elapsedMilliseconds;
        if (elapsed > 0) {
          final mbps = (bytesReceived * 8) / (elapsed * 1000.0);
          _download = double.parse(mbps.toStringAsFixed(1));
          _gaugeValue = _download;
        }
      } catch (_) {
        _download = 0;
      }
    }
    notifyListeners();

    // Upload phase – POST 5 MB and animate gauge via a periodic timer
    _phase = TestPhase.upload;
    _gaugeValue = 0;
    notifyListeners();

    try {
      const uploadBytes = 5 * 1024 * 1024; // 5 MB
      final data = Uint8List(uploadBytes);
      final sw = Stopwatch()..start();

      Timer? timer;
      timer = Timer.periodic(const Duration(milliseconds: 150), (_) {
        final elapsed = sw.elapsedMilliseconds;
        if (elapsed > 0) {
          final mbps = (uploadBytes * 8) / (elapsed * 1000.0);
          _gaugeValue = mbps;
          _upload = double.parse(mbps.toStringAsFixed(1));
          notifyListeners();
        }
      });

      await _client.post(
        Uri.parse(_uploadUrl),
        body: data,
        headers: {'Content-Type': 'application/octet-stream'},
      );

      sw.stop();
      timer.cancel();

      final elapsed = sw.elapsedMilliseconds;
      if (elapsed > 0) {
        final mbps = (uploadBytes * 8) / (elapsed * 1000.0);
        _upload = double.parse(mbps.toStringAsFixed(1));
        _gaugeValue = _upload;
      }
    } catch (_) {
      _upload = 0;
    }
    notifyListeners();

    _phase = TestPhase.done;
    _gaugeValue = _download;
    notifyListeners();

    // Save to history
    final now = DateTime.now();
    _history.insert(
      0,
      Items(
        time:
            '${now.month}/${now.day} ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
        networkType: networkIcon,
        ping: _ping,
        download: _download,
        upload: _upload,
        ip: _publicIp,
        location: 'Your Network',
        wifiName: _networkName,
      ),
    );
    notifyListeners();
  }

  Future<void> _checkIntegrity() async {
    final token = await IntegrityService.requestToken();
    _integrityStatus = token != null ? 'certified' : 'uncertified';
    notifyListeners();
  }

  Future<void> _fetchNetworkInfo() async {
    // On web the MethodChannel is unavailable — use a simple web fallback
    if (kIsWeb) {
      _connectionType = 'wifi';
      _networkName = 'Web Browser';
      notifyListeners();
      return;
    }

    try {
      final result = await _networkChannel
          .invokeMapMethod<String, dynamic>('getNetworkInfo');
      if (result == null) return;

      _connectionType = (result['connectionType'] as String?) ?? 'unknown';

      if (_connectionType == 'wifi') {
        _networkName = (result['wifiSsid'] as String?) ?? 'Wi-Fi';
      } else if (_connectionType == 'mobile') {
        _networkName = (result['operatorName'] as String?) ?? 'Mobile Data';
      } else {
        _networkName = 'No Network';
      }
      notifyListeners();
    } catch (_) {
      _networkName = 'Unknown';
      notifyListeners();
    }
  }

  Future<void> _fetchPublicIp() async {
    try {
      final response = await _client.get(Uri.parse(_ipUrl));
      if (response.statusCode == 200) {
        final body = response.body.trim();
        // ipify returns JSON when ?format=json is used: {"ip":"1.2.3.4"}
        if (body.startsWith('{')) {
          final ip = RegExp(r'"ip"\s*:\s*"([^"]+)"').firstMatch(body)?.group(1);
          _publicIp = ip ?? body;
        } else {
          _publicIp = body;
        }
        notifyListeners();
      }
    } catch (_) {
      _publicIp = 'Unknown';
      notifyListeners();
    }
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
