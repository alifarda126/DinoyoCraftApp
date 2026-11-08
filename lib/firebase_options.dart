// File generated for DinoyoCraft Firebase configuration.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBR6LloJcRbGFbaMVJo63LvrRhgHo4Gxv4',
    appId: '1:978012424956:web:fbcc69161e1c817b5ca579',
    messagingSenderId: '978012424956',
    projectId: 'dinoyocraft-338fd',
    authDomain: 'dinoyocraft-338fd.firebaseapp.com',
    storageBucket: 'dinoyocraft-338fd.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBR6LloJcRbGFbaMVJo63LvrRhgHo4Gxv4',
    appId: '1:978012424956:android:fbcc69161e1c817b5ca579',
    messagingSenderId: '978012424956',
    projectId: 'dinoyocraft-338fd',
    storageBucket: 'dinoyocraft-338fd.firebasestorage.app',
  );
}

