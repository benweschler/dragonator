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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAsw4P92IjII4yZJ9JFLs2vovgQ06DmPZ4',
    appId: '1:913823039863:web:fd374ba6eeab37adff2172',
    messagingSenderId: '913823039863',
    projectId: 'dragonator',
    authDomain: 'dragonator.firebaseapp.com',
    storageBucket: 'dragonator.appspot.com',
    measurementId: 'G-S3KW9CLHZE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZWsiJbhQwSVWGlppLBrsz9bM-uFmh77U',
    appId: '1:913823039863:android:83ab1c151098885cff2172',
    messagingSenderId: '913823039863',
    projectId: 'dragonator',
    storageBucket: 'dragonator.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBLR727mbm8mASdQRNemaEF4uAn4lgXM8M',
    appId: '1:913823039863:ios:8ca13726b7a5eb65ff2172',
    messagingSenderId: '913823039863',
    projectId: 'dragonator',
    storageBucket: 'dragonator.appspot.com',
    iosClientId: '913823039863-4ap3n0nf24m5pvolcpkt2uarbuplpuoa.apps.googleusercontent.com',
    iosBundleId: 'com.benweschler.dragonator',
  );
}
