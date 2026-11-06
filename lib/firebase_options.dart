// Налаштування Firebase для веб-застосунку PlaceLog.
// Значення взято з Firebase Console → Project settings → Your apps (Web).
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError(
      'Firebase налаштовано лише для Web '
      '(${defaultTargetPlatform.name} поки не підтримується).',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA0iwLBDQHENirL8tn7BvnrzY0mLuJJA64',
    appId: '1:1080264018090:web:1c9f9922c8686cd77768d3',
    messagingSenderId: '1080264018090',
    projectId: 'placelog-f78f8',
    authDomain: 'placelog-f78f8.firebaseapp.com',
    storageBucket: 'placelog-f78f8.firebasestorage.app',
    measurementId: 'G-3QLQ4KB6J6',
  );
}
