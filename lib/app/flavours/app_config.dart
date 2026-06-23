import 'package:customer/core/data/http/client/api_client_config.dart';

class AppConfig {
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const apiVersion = String.fromEnvironment('API_VERSION', defaultValue: 'v1');
  static const debug = bool.fromEnvironment('APP_DEBUG');
  static const defaultLocale = String.fromEnvironment('DEFAULT_LOCALE', defaultValue: 'en');

  const AppConfig();

  bool get isProduction => !debug;

  ApiClientConfig getApiClientConfig() {
    return ApiClientConfig(
      baseUrl: apiBaseUrl,
      apiVersion: apiVersion,
      isDebug: debug,
    );
  }
}
