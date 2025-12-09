import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/data/http/client/api_client_config.dart';

class AppConfig extends GetxController {
  static const String _prodEnvName = "production";
  static const String _devEnvName = "development";

  final String environment = _prodEnvName;
  late final String apiBaseUrl;
  late final String apiVersion;
  late final bool debug;
  late final Locale defaultLocale;

  bool get isProduction => environment == _prodEnvName;
  bool get isDevelopment => environment == _devEnvName;
  bool get isDebug => debug;
  bool get isNotDebug => !debug;

  void _loadData(Map<String, dynamic> map) {
    apiBaseUrl = map['API_BASE_URL'];
    apiVersion = map['API_VERSION'];
    debug = map['APP_DEBUG'] == 'true';
    defaultLocale = Locale(map['DEFAULT_LOCALE'] ?? 'en');
  }

  ApiClientConfig getApiClientConfig() {
    return ApiClientConfig(
      baseUrl: apiBaseUrl,
      apiVersion: apiVersion,
      isDebug: debug,
    );
  }

  AppConfig(Map<String, dynamic> env) {
    _loadData(env);
  }
}
