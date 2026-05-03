import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBIPgV5oMjpZQIbsw0WwsQk0QyKcNUm-CI',
    appId: '1:95966258163:web:8e4f4152007cac299ae886',
    messagingSenderId: '95966258163',
    projectId: 'device-streaming-9621025c',
    authDomain: 'device-streaming-9621025c.firebaseapp.com',
    storageBucket: 'device-streaming-9621025c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbf6MQOLv98sTVW2r4qkW2sThiLQXv8kk',
    appId: '1:95966258163:android:03f5f34d1bfa2a719ae886',
    messagingSenderId: '95966258163',
    projectId: 'device-streaming-9621025c',
    storageBucket: 'device-streaming-9621025c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD2PPGPGGKYqYzh31kzrHjMqXar-n4MIjI',
    appId: '1:95966258163:ios:9e7e6e0d92c35a399ae886',
    messagingSenderId: '95966258163',
    projectId: 'device-streaming-9621025c',
    storageBucket: 'device-streaming-9621025c.firebasestorage.app',
    iosBundleId: 'com.aydigitalcentre.netspeedpro',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD2PPGPGGKYqYzh31kzrHjMqXar-n4MIjI',
    appId: '1:95966258163:ios:f352724887dfd07b9ae886',
    messagingSenderId: '95966258163',
    projectId: 'device-streaming-9621025c',
    storageBucket: 'device-streaming-9621025c.firebasestorage.app',
    iosBundleId: 'com.aydigitalcentre.speedest',
  );

}