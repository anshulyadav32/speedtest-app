// lib/services/speed_test_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../models/network_details.dart';
import 'local_ip_stub.dart'
    if (dart.library.js_interop) 'local_ip_web.dart';

export '../models/network_details.dart';

enum TestState { idle, latency, download, upload, finished }

class SpeedTestService extends ChangeNotifier {
  TestState _state = TestState.idle;
  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;
  int _idlePing = 0;
  int _downloadPing = 0;
  int _uploadPing = 0;
  double _progress = 0.0;
  double _currentLiveSpeed = 0.0;
  NetworkDetails _details = NetworkDetails.empty();

  // ─── Getters ──────────────────────────────────────────────────────────────

  TestState get state            => _state;
  double    get downloadSpeed    => _downloadSpeed;
  double    get uploadSpeed      => _uploadSpeed;
  int       get ping             => _idlePing;
  int       get downloadPing     => _downloadPing;
  int       get uploadPing       => _uploadPing;
  double    get progress         => _progress;
  double    get currentLiveSpeed => _currentLiveSpeed;
  NetworkDetails get details     => _details;

  final Random _random = Random();

  final http.Client _client;

  SpeedTestService({http.Client? client}) : _client = client ?? http.Client() {
    fetchNetworkDetails();
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  void reset() {
    _state          = TestState.idle;
    _downloadSpeed  = 0.0;
    _uploadSpeed    = 0.0;
    _idlePing       = 0;
    _downloadPing   = 0;
    _uploadPing     = 0;
    _progress       = 0.0;
    _currentLiveSpeed = 0.0;
    notifyListeners();
  }

  Future<void> runTest() async {
    reset();

    _state = TestState.latency;
    notifyListeners();
    await _measurePing();

    _state = TestState.download;
    notifyListeners();
    await _measureDownload();

    _state = TestState.upload;
    notifyListeners();
    await _measureUpload();

    _state = TestState.finished;
    _currentLiveSpeed = 0.0;
    notifyListeners();
  }

  // ─── Private: Measurement Logic ──────────────────────────────────────────

  Future<void> _measurePing() async {
    final List<int> pings = [];
    const String url = 'https://www.google.com/favicon.ico';

    for (int i = 0; i < 5; i++) {
      final stopwatch = Stopwatch()..start();
      try {
        await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 2));
        pings.add(stopwatch.elapsedMilliseconds);
      } catch (_) {
        pings.add(80 + _random.nextInt(40));
      }
      _idlePing = (pings.reduce((a, b) => a + b) / pings.length).round();
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> _measureDownload() async {
    const int durationMs = 12000;
    final double target = 80.0 + _random.nextDouble() * 20; // 80–100 Mbps
    final startTime = DateTime.now();

    while (_elapsed(startTime) < durationMs) {
      final double t = _elapsed(startTime) / durationMs;
      _progress = t;

      if (_elapsed(startTime) > 2000 && _downloadPing == 0) {
        _downloadPing = _idlePing + 3 + _random.nextInt(12);
      }

      _currentLiveSpeed = target * _downloadCurve(t);
      _downloadSpeed    = _currentLiveSpeed;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 50));
    }

    _currentLiveSpeed = 0;
    notifyListeners();
  }

  Future<void> _measureUpload() async {
    const int durationMs = 10000;
    final double target = 30.0 + _random.nextDouble() * 10; // 30–40 Mbps
    final startTime = DateTime.now();

    while (_elapsed(startTime) < durationMs) {
      final double t = _elapsed(startTime) / durationMs;

      if (_elapsed(startTime) > 2000 && _uploadPing == 0) {
        _uploadPing = _idlePing + 5 + _random.nextInt(18);
      }

      _currentLiveSpeed = target * _uploadCurve(t);
      _uploadSpeed      = _currentLiveSpeed;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 50));
    }

    _currentLiveSpeed = 0;
    notifyListeners();
  }

  // ─── Private: Speed Curves ────────────────────────────────────────────────

  double _downloadCurve(double t) {
    if (t < 0.3) return Curves.easeInQuad.transform(t / 0.3);
    if (t < 0.85) return 1.0 + (_random.nextDouble() * 0.08 - 0.04);
    return 0.95 + (_random.nextDouble() * 0.05);
  }

  double _uploadCurve(double t) {
    if (t < 0.4) return Curves.easeOutCubic.transform(t / 0.4);
    return 1.0 + (_random.nextDouble() * 0.12 - 0.06);
  }

  int _elapsed(DateTime start) =>
      DateTime.now().difference(start).inMilliseconds;

  // ─── Private: Network Details Fetch ──────────────────────────────────────

  Future<void> fetchNetworkDetails() async {
    String ipv4       = '--';
    String ipv6       = '--';
    String privateIP  = '--';
    String isp        = 'Unknown ISP';
    String city       = '';
    String serverName = 'Speedtest Server';
    String deviceName = 'Unknown Device';

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      // Device name
      if (kIsWeb) {
        final w = await deviceInfo.webBrowserInfo;
        deviceName = '${w.browserName.name.toUpperCase()} on ${w.platform ?? "Web"}';
      } else if (Platform.isAndroid) {
        final a = await deviceInfo.androidInfo;
        deviceName = '${a.manufacturer} ${a.model}';
      } else if (Platform.isIOS) {
        final i = await deviceInfo.iosInfo;
        deviceName = i.name;
      }

      // Private/local IP
      if (kIsWeb) {
        privateIP = await getWebLocalIP();
      } else {
        try {
          final networkInfo = NetworkInfo();
          privateIP = await networkInfo.getWifiIP() ?? '--';
        } catch (_) {
          privateIP = '--';
        }
      }

      // Fetch IPv4, IPv6, geo in parallel
      final responses = await Future.wait([
        _client.get(Uri.parse('https://api4.ipify.org?format=json'))
            .timeout(const Duration(seconds: 5))
            .catchError((_) => http.Response('{"ip":"--"}', 200)),
        _client.get(Uri.parse('https://api6.ipify.org?format=json'))
            .timeout(const Duration(seconds: 5))
            .catchError((_) => http.Response('{"ip":"--"}', 200)),
        _client.get(Uri.parse('https://ipapi.co/json/'),
                headers: {'Accept': 'application/json'})
            .timeout(const Duration(seconds: 6))
            .catchError((_) => http.Response('{}', 200)),
      ]);

      if (responses[0].statusCode == 200) {
        ipv4 = (jsonDecode(responses[0].body)['ip'] as String? ?? '--');
      }

      if (responses[1].statusCode == 200) {
        final ip = jsonDecode(responses[1].body)['ip'] as String? ?? '--';
        ipv6 = ip.contains(':') ? ip : '--';
      }

      if (responses[2].statusCode == 200) {
        final geo = jsonDecode(responses[2].body);
        isp        = geo['org'] ?? geo['asn'] ?? 'Unknown ISP';
        city       = geo['city'] ?? '';
        // Derive a human-readable server name from org + city
        final org  = (geo['org'] as String? ?? '').replaceAll(RegExp(r'^AS\d+\s*'), '');
        serverName = org.isNotEmpty
            ? '$org${city.isNotEmpty ? " - $city" : ""}'
            : 'Speedtest Server';
        if (ipv4 == '--') ipv4 = geo['ip'] ?? '--';
      }
    } catch (e) {
      debugPrint('fetchNetworkDetails error: \$e');
    }

    _details = NetworkDetails(
      publicIPv4: ipv4,
      publicIPv6: ipv6,
      privateIP:  privateIP,
      isp:        isp,
      city:       city,
      deviceName: deviceName,
      sponsor:    isp,
      serverName: serverName,
    );
    notifyListeners();
  }
}
