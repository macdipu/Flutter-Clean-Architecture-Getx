import 'package:flutter_clean_architecture_getx/res/strings/string_enum.dart';
import 'package:flutter_clean_architecture_getx/services/navigation/navigation_history_observer.dart';
import 'package:flutter_clean_architecture_getx/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/routes/app_pages.dart';
import '../../res/strings/app_translations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Locale _locale = Locale("en");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: _locale,
      fallbackLocale: _locale,
      supportedLocales: AppTranslations.supportedLocales,
      translations: AppTranslations(),
      title: TextEnum.appName.tr,
      theme: ThemeData(appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF))),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      navigatorKey: NavigationService.navigatorKey,
      navigatorObservers: [NavigationHistoryObserver()],
    );
  }
}
