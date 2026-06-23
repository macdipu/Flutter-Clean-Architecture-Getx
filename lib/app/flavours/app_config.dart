import 'package:customer/core/data/http/client/api_client_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig();

  String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  String get apiVersion => dotenv.env['API_VERSION'] ?? 'v1';
  bool get debug => dotenv.env['APP_DEBUG'] == 'true';
  String get defaultLocale => dotenv.env['DEFAULT_LOCALE'] ?? 'en';
  bool get isProduction => !debug;

  ApiClientConfig getApiClientConfig() => ApiClientConfig(
        baseUrl: apiBaseUrl,
        apiVersion: apiVersion,
        isDebug: debug,
      );
}
