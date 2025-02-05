import 'package:application/utils/text_strings.dart';
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
        throw UnsupportedError(
            macOSErrorMessage
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
            windowsErrorMessage
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
            linuxErrorMessage
        );
      default:
        throw UnsupportedError(
          notSupportedErrorMessage,
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAHU3BOg5li4CaZxgBSufT26DOgBlIKhcU",
    appId: "1:388344003496:web:cade0481e0c046facd3b9d",
    messagingSenderId: "388344003496",
    projectId: "szakdolgozat-a9498",
    authDomain: "szakdolgozat-a9498.firebaseapp.com",
    storageBucket: "szakdolgozat-a9498.appspot.com",
    measurementId: "G-S49F583NNX",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqlWEn6O-btgN0k-oczgQeuKDZmvi_lj4',
    appId: '1:388344003496:android:1dafdf29e26ef03ccd3b9d',
    messagingSenderId: '388344003496',
    projectId: 'szakdolgozat-a9498',
    storageBucket: 'szakdolgozat-a9498.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1r8IfKYCQsfXoCXvKpZaMqNbQ8yFWoIk',
    appId: '1:388344003496:ios:6e86fed11c561d4bcd3b9d',
    messagingSenderId: '388344003496',
    projectId: 'szakdolgozat-a9498',
    storageBucket: 'szakdolgozat-a9498.appspot.com',
    iosClientId: '388344003496-e2314hr61apd56irjk7lghfbcnmqkb58.apps.googleusercontent.com',
    iosBundleId: 'com.example.szakdolgozat',
  );

  static const FirebaseOptions macOS = FirebaseOptions(
    apiKey: 'AIzaSyA1r8IfKYCQsfXoCXvKpZaMqNbQ8yFWoIk',
    appId: '1:388344003496:ios:6e86fed11c561d4bcd3b9d',
    messagingSenderId: '388344003496',
    projectId: 'szakdolgozat-a9498',
    storageBucket: 'szakdolgozat-a9498.appspot.com',
    iosClientId: '388344003496-e2314hr61apd56irjk7lghfbcnmqkb58.apps.googleusercontent.com',
    iosBundleId: 'com.example.szakdolgozat',
  );
}
