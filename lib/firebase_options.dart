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
    apiKey: 'AIzaSyAgI5gBiZpxrqGDRvrLso3EW1aEL1jxRiM',
    appId: '1:200709773011:web:da7b002bf5b3a05db16626',
    messagingSenderId: '200709773011',
    projectId: 'quickmedapp-68e93',
    authDomain: 'quickmedapp-68e93.firebaseapp.com',
    storageBucket: 'quickmedapp-68e93.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0yrDAJcCq3r2j7abgBWDrLMj2hexOUt8',
    appId: '1:200709773011:android:ce2c778af1316ce2b16626',
    messagingSenderId: '200709773011',
    projectId: 'quickmedapp-68e93',
    storageBucket: 'quickmedapp-68e93.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDc_MET93OQi1BWwUNWZTQ0EShGQAElH8',
    appId: '1:200709773011:ios:4402f573a28b2cf8b16626',
    messagingSenderId: '200709773011',
    projectId: 'quickmedapp-68e93',
    storageBucket: 'quickmedapp-68e93.appspot.com',
    iosBundleId: 'com.example.quickmed',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDc_MET93OQi1BWwUNWZTQ0EShGQAElH8',
    appId: '1:200709773011:ios:d68de853ceb4928db16626',
    messagingSenderId: '200709773011',
    projectId: 'quickmedapp-68e93',
    storageBucket: 'quickmedapp-68e93.appspot.com',
    iosBundleId: 'com.example.quickmed.RunnerTests',
  );
}
