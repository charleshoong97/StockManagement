class EnvironmentConfig {
  static const firebaseAPIKeyAndroid = String.fromEnvironment(
      'FIREBASE_API_KEY_ANDROID',
      defaultValue: 'failed');

  static const firebaseAPIKeyIOS =
      String.fromEnvironment('FIREBASE_API_KEY_IOS', defaultValue: 'failed');
}
