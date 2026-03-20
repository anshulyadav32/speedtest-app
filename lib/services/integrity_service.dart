import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class IntegrityService {
  static const _channel =
      MethodChannel('com.aydigitalcentre.speedest/integrity');

  /// Requests a Play Integrity token from the Play Store.
  /// Returns the raw token string on success, or `null` if the device is not
  /// eligible (e.g. web, iOS, emulator without Play Services, sideloaded).
  static Future<String?> requestToken() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return null;
    try {
      return await _channel.invokeMethod<String>('requestIntegrityToken');
    } on PlatformException {
      return null;
    }
  }
}
