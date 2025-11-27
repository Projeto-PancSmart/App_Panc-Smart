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
        return windows;
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
    apiKey: 'AIzaSyBeKZdOmWByh6iCTDiYzLEA_UKZ4fG3qDU',
    appId: '1:493510552940:web:541ee3fcd6047375675749',
    messagingSenderId: '493510552940',
    projectId: 'panc-smart',
    authDomain: 'panc-smart.firebaseapp.com',
    storageBucket: 'panc-smart.firebasestorage.app',
    databaseURL: 'https://panc-smart-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2wYQ_F9rpfIUjTXRin19KKeTyQRE1kyQ',
    appId: '1:493510552940:android:7b9040f84d13cc1f675749',
    messagingSenderId: '493510552940',
    projectId: 'panc-smart',
    storageBucket: 'panc-smart.firebasestorage.app',
    databaseURL: 'https://panc-smart-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4cWZ1YUVdrs5ikMKPAz6sU5cWM37_VKA',
    appId: '1:493510552940:ios:f8f7b6ec6eccf38d675749',
    messagingSenderId: '493510552940',
    projectId: 'panc-smart',
    storageBucket: 'panc-smart.firebasestorage.app',
    iosBundleId: 'com.example.pancSmart',
    databaseURL: 'https://panc-smart-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD4cWZ1YUVdrs5ikMKPAz6sU5cWM37_VKA',
    appId: '1:493510552940:ios:f8f7b6ec6eccf38d675749',
    messagingSenderId: '493510552940',
    projectId: 'panc-smart',
    storageBucket: 'panc-smart.firebasestorage.app',
    iosBundleId: 'com.example.pancSmart',
    databaseURL: 'https://panc-smart-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBeKZdOmWByh6iCTDiYzLEA_UKZ4fG3qDU',
    appId: '1:493510552940:web:d4a845dde0c869bf675749',
    messagingSenderId: '493510552940',
    projectId: 'panc-smart',
    authDomain: 'panc-smart.firebaseapp.com',
    storageBucket: 'panc-smart.firebasestorage.app',
    databaseURL: 'https://panc-smart-default-rtdb.firebaseio.com',
  );
}
