class Config {
  // Azure web app
  static const String apiUrl = String.fromEnvironment('API_URL',
      defaultValue:
          'https://mathassessmentapiserver-gndqa6fgg0eta0fe.uksouth-01.azurewebsites.net');

  // iOS simulator
  // static const String apiUrl =
  //     String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8000');

  // Android simulator
  // static const String apiUrl =
  //     String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:8000');

  static const String imagePathPrefix = 'assets/images/';
}
