// Generated file. Do not edit.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default FirebaseOptions for use with your Firebase apps.
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
    apiKey: 'AIzaXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',  // Replace with actual API key
    appId: '1:XXXXXXXXXXXX:web:XXXXXXXXXXXXXXXXXXXXXXXX',  // Replace with actual App ID
    messagingSenderId: 'XXXXXXXXXXXX',  // Replace with actual sender ID
    projectId: 'ewasterecycling-XXXXX',  // Replace with actual project ID
    authDomain: 'ewasterecycling-XXXXX.firebaseapp.com',  // Replace
    storageBucket: 'ewasterecycling-XXXXX.appspot.com',  // Replace
    measurementId: 'G-XXXXXXXXXX',  // Replace with actual measurement ID
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',  // Replace
    appId: '1:XXXXXXXXXXXX:android:XXXXXXXXXXXXXXXXXXXXXXXX',  // Replace
    messagingSenderId: 'XXXXXXXXXXXX',  // Replace
    projectId: 'ewasterecycling-XXXXX',  // Replace
    storageBucket: 'ewasterecycling-XXXXX.appspot.com',  // Replace
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',  // Replace
    appId: '1:XXXXXXXXXXXX:ios:XXXXXXXXXXXXXXXXXXXXXXXX',  // Replace
    messagingSenderId: 'XXXXXXXXXXXX',  // Replace
    projectId: 'ewasterecycling-XXXXX',  // Replace
    storageBucket: 'ewasterecycling-XXXXX.appspot.com',  // Replace
    iosClientId: 'XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com',  // Replace
    iosBundleId: 'com.example.ewasterecycling',  // Replace with your bundle ID
  );
}