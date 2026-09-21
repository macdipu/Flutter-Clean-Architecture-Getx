import 'package:customer/core/data/http/client/api_client_config.dart';

class AppConfig {
  const AppConfig();

  static const String _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/',
  );
  static const String _apiVersion = String.fromEnvironment('API_VERSION', defaultValue: 'v1');
  static const bool _debug = bool.fromEnvironment('APP_DEBUG', defaultValue: true);
  static const String _defaultLocale = String.fromEnvironment('DEFAULT_LOCALE', defaultValue: 'en');

  String get apiBaseUrl => _apiBaseUrl;
  String get apiVersion => _apiVersion;
  bool get debug => _debug;
  String get defaultLocale => _defaultLocale;
  bool get isProduction => !debug;

  ApiClientConfig getApiClientConfig() => ApiClientConfig(
        baseUrl: apiBaseUrl,
        apiVersion: apiVersion,
        isDebug: debug,
      );
}
