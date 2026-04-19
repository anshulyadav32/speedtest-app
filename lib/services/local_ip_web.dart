// lib/services/local_ip_web.dart
// Web implementation — uses WebRTC via JS interop to get local IP.

import 'dart:js_interop';

@JS('getLocalIP')
external JSPromise<JSString> _getLocalIPJs();

Future<String> getWebLocalIP() async {
  try {
    final jsString = await _getLocalIPJs().toDart;
    return jsString.toDart;
  } catch (_) {
    return '--';
  }
}
