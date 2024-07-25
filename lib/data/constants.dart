abstract class Constants {
  static const String webFirebaseApiKey = String.fromEnvironment('WEB_FIREBASE_API_KEY', defaultValue: '');
  static const String webFirebaseAppId = String.fromEnvironment('WEB_FIREBASE_APP_ID', defaultValue: '');

  static const String iosFirebaseApiKey = String.fromEnvironment('IOS_FIREBASE_API_KEY', defaultValue: '');
  static const String iosFirebaseAppId = String.fromEnvironment('IOS_FIREBASE_APP_ID', defaultValue: '');
  static const String iosBundleId = String.fromEnvironment('IOS_BUNDLE_ID', defaultValue: '');

  static const String androidFirebaseApiKey = String.fromEnvironment('ANDROID_FIREBASE_API_KEY', defaultValue: '');
  static const String androidFirebaseAppId = String.fromEnvironment('ANDROID_FIREBASE_APP_ID', defaultValue: '');

  static const String macosFirebaseApiKey = String.fromEnvironment('MACOS_FIREBASE_API_KEY', defaultValue: '');
  static const String macosFirebaseAppId = String.fromEnvironment('MACOS_FIREBASE_APP_ID', defaultValue: '');

  static const String windowsFirebaseApiKey = String.fromEnvironment('WINDOWS_FIREBASE_API_KEY', defaultValue: '');
  static const String windowsFirebaseAppId = String.fromEnvironment('WINDOWS_FIREBASE_APP_ID', defaultValue: '');

  static const String firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: '');
  static const String firebaseStorageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: '');
  static const String firebaseMessagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '');
  static const String firebaseAuthDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: '');
  static const String firebaseDatabaseUrl = String.fromEnvironment('FIREBASE_DATABASE_URL', defaultValue: '');

}