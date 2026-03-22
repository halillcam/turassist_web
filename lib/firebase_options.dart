import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: _FirebaseEnv.requiredValue('FIREBASE_WEB_API_KEY'),
    appId: _FirebaseEnv.requiredValue('FIREBASE_WEB_APP_ID'),
    messagingSenderId: _FirebaseEnv.requiredValue('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _FirebaseEnv.requiredValue('FIREBASE_PROJECT_ID'),
    authDomain: _FirebaseEnv.requiredValue('FIREBASE_AUTH_DOMAIN'),
    storageBucket: _FirebaseEnv.requiredValue('FIREBASE_STORAGE_BUCKET'),
    measurementId: _FirebaseEnv.requiredValue('FIREBASE_WEB_MEASUREMENT_ID'),
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: _FirebaseEnv.requiredValue('FIREBASE_ANDROID_API_KEY'),
    appId: _FirebaseEnv.requiredValue('FIREBASE_ANDROID_APP_ID'),
    messagingSenderId: _FirebaseEnv.requiredValue('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _FirebaseEnv.requiredValue('FIREBASE_PROJECT_ID'),
    storageBucket: _FirebaseEnv.requiredValue('FIREBASE_STORAGE_BUCKET'),
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: _FirebaseEnv.requiredValue('FIREBASE_IOS_API_KEY'),
    appId: _FirebaseEnv.requiredValue('FIREBASE_IOS_APP_ID'),
    messagingSenderId: _FirebaseEnv.requiredValue('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _FirebaseEnv.requiredValue('FIREBASE_PROJECT_ID'),
    storageBucket: _FirebaseEnv.requiredValue('FIREBASE_STORAGE_BUCKET'),
    androidClientId: _FirebaseEnv.requiredValue('FIREBASE_IOS_ANDROID_CLIENT_ID'),
    iosClientId: _FirebaseEnv.requiredValue('FIREBASE_IOS_CLIENT_ID'),
    iosBundleId: _FirebaseEnv.requiredValue('FIREBASE_IOS_BUNDLE_ID'),
  );

  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: _FirebaseEnv.requiredValue('FIREBASE_MACOS_API_KEY'),
    appId: _FirebaseEnv.requiredValue('FIREBASE_MACOS_APP_ID'),
    messagingSenderId: _FirebaseEnv.requiredValue('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _FirebaseEnv.requiredValue('FIREBASE_PROJECT_ID'),
    storageBucket: _FirebaseEnv.requiredValue('FIREBASE_STORAGE_BUCKET'),
    androidClientId: _FirebaseEnv.requiredValue('FIREBASE_MACOS_ANDROID_CLIENT_ID'),
    iosClientId: _FirebaseEnv.requiredValue('FIREBASE_MACOS_CLIENT_ID'),
    iosBundleId: _FirebaseEnv.requiredValue('FIREBASE_MACOS_BUNDLE_ID'),
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: _FirebaseEnv.requiredValue('FIREBASE_WINDOWS_API_KEY'),
    appId: _FirebaseEnv.requiredValue('FIREBASE_WINDOWS_APP_ID'),
    messagingSenderId: _FirebaseEnv.requiredValue('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _FirebaseEnv.requiredValue('FIREBASE_PROJECT_ID'),
    authDomain: _FirebaseEnv.requiredValue('FIREBASE_AUTH_DOMAIN'),
    storageBucket: _FirebaseEnv.requiredValue('FIREBASE_STORAGE_BUCKET'),
    measurementId: _FirebaseEnv.requiredValue('FIREBASE_WINDOWS_MEASUREMENT_ID'),
  );
}

class _FirebaseEnv {
  static String requiredValue(String key) {
    final value = dotenv.env[key]?.trim();
    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing required Firebase env value: $key. Copy .env.example to .env and fill all values.',
      );
    }
    return value;
  }
}
