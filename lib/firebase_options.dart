// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZk8T2aIxxjG_iUjVjZj-XXDCq5HLOWco',
    appId: '1:1041404591655:android:28844b5b76fe76dad19802',
    messagingSenderId: '1041404591655',
    projectId: 'login-app-dd211',
    storageBucket: 'login-app-dd211.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC462_WrYkky6E3x4IMlHGKXzwdR4_dYPQ',
    appId: '1:1041404591655:ios:3cbdff36f837ea62d19802',
    messagingSenderId: '1041404591655',
    projectId: 'login-app-dd211',
    storageBucket: 'login-app-dd211.appspot.com',
    iosBundleId: 'com.example.loginUi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC462_WrYkky6E3x4IMlHGKXzwdR4_dYPQ',
    appId: '1:1041404591655:ios:a9998779fb9062c0d19802',
    messagingSenderId: '1041404591655',
    projectId: 'login-app-dd211',
    storageBucket: 'login-app-dd211.appspot.com',
    iosBundleId: 'com.example.loginUi.RunnerTests',
  );
}
