
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:socials/data/constants.dart';

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
    apiKey: Constants.webFirebaseApiKey,
    appId: Constants.webFirebaseAppId,
    messagingSenderId: Constants.firebaseMessagingSenderId,
    projectId: Constants.firebaseProjectId,
    authDomain: Constants.firebaseAuthDomain,
    databaseURL: Constants.firebaseDatabaseUrl,
    storageBucket: Constants.firebaseStorageBucket,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: Constants.androidFirebaseApiKey,
    appId: Constants.androidFirebaseAppId,
    messagingSenderId: Constants.firebaseMessagingSenderId,
    projectId: Constants.firebaseProjectId,
    authDomain: Constants.firebaseAuthDomain,
    databaseURL: Constants.firebaseDatabaseUrl,
    storageBucket: Constants.firebaseStorageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: Constants.iosFirebaseApiKey,
    appId: Constants.iosFirebaseAppId,
    messagingSenderId: Constants.firebaseMessagingSenderId,
    projectId: Constants.firebaseProjectId,
    databaseURL: Constants.firebaseDatabaseUrl,
    storageBucket: Constants.firebaseStorageBucket,
    iosBundleId: Constants.iosBundleId,
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: Constants.macosFirebaseApiKey,
    appId: Constants.macosFirebaseAppId,
    messagingSenderId: Constants.firebaseMessagingSenderId,
    projectId: Constants.firebaseProjectId,
    databaseURL: Constants.firebaseDatabaseUrl,
    storageBucket: Constants.firebaseStorageBucket,
    iosBundleId: Constants.iosBundleId,
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: Constants.windowsFirebaseApiKey,
    appId: Constants.webFirebaseAppId,
    messagingSenderId: Constants.firebaseMessagingSenderId,
    projectId: Constants.firebaseProjectId,
    authDomain: Constants.firebaseAuthDomain,
    databaseURL: Constants.firebaseDatabaseUrl,
    storageBucket: Constants.firebaseStorageBucket,
  );
}
