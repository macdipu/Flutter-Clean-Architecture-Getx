import 'dart:async';
import 'dart:developer';

import 'package:clean_architecture_getx/app/flavours/app_config.dart';
import 'package:clean_architecture_getx/core/data/http/client/api_client.dart';
import 'package:clean_architecture_getx/core/data/http/urls/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../../core/data/cache/client/preference_cache.dart';
import '../../services/version/version.dart';
import '../../features/initialization/data/repo_impl/initialization_repository_impl.dart';
import '../../features/initialization/domain/use_case/initialization_use_case.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await dotenv.load();
  _initialize(dotenv.env);

  await VersionService.getVersion();

  runApp(await builder());
}

//Add GetxControllers which are needed to be initialized before starting the app
void _initialize(Map<String, dynamic> map) {
  Get.lazyPut<AppConfig>(() => AppConfig(map), fenix: true);
  Get.lazyPut<PreferenceCache>(() => PreferenceCache(), fenix: true);
  Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);
  Get.lazyPut<ApiUrl>(() => ApiUrl(), fenix: true);
  Get.lazyPut<InitializationRepositoryImpl>(() => InitializationRepositoryImpl(Get.find<ApiClient>(), Get.find<PreferenceCache>()), fenix: true);
  Get.lazyPut<InitializationUseCase>(() => InitializationUseCase(Get.find<InitializationRepositoryImpl>()), fenix: true);
}
