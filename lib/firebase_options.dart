import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyDsK_oKE7iDRYdA_fqoG9Sqse4_wseAwJ0',
    appId: '1:123456789012:web:1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'iot2025-3a08b',
    authDomain: 'iot2025-3a08b.firebaseapp.com',
    databaseURL: 'https://iot2025-3a08b-default-rtdb.firebaseio.com',
    storageBucket: 'iot2025-3a08b.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDsK_oKE7iDRYdA_fqoG9Sqse4_wseAwJ0',
    appId: '1:123456789012:android:1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'iot2025-3a08b',
    databaseURL: 'https://iot2025-3a08b-default-rtdb.firebaseio.com',
    storageBucket: 'iot2025-3a08b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsK_oKE7iDRYdA_fqoG9Sqse4_wseAwJ0',
    appId: '1:123456789012:ios:1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'iot2025-3a08b',
    databaseURL: 'https://iot2025-3a08b-default-rtdb.firebaseio.com',
    storageBucket: 'iot2025-3a08b.appspot.com',
    iosClientId:
        '123456789012-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com',
    iosBundleId: 'com.example.iotControlApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDsK_oKE7iDRYdA_fqoG9Sqse4_wseAwJ0',
    appId: '1:123456789012:ios:1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'iot2025-3a08b',
    databaseURL: 'https://iot2025-3a08b-default-rtdb.firebaseio.com',
    storageBucket: 'iot2025-3a08b.appspot.com',
    iosClientId:
        '123456789012-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com',
    iosBundleId: 'com.example.iotControlApp',
  );
}
