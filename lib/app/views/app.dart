import 'package:flutter_clean_architecture_getx/res/strings/string_enum.dart';
import 'package:flutter_clean_architecture_getx/services/navigation/navigation_history_observer.dart';
import 'package:flutter_clean_architecture_getx/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../core/presentation/controllers/theme_controller.dart';
import '../../core/presentation/theme/app_theme.dart';
import '../../res/routes/app_pages.dart';
import '../../res/strings/app_translations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Locale _locale = const Locale("bn");
  final ThemeController _themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        locale: _locale,
        fallbackLocale: _locale,
        supportedLocales: AppTranslations.supportedLocales,
        translations: AppTranslations(),
        title: TextEnum.appName.tr,

        // Theme Configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeController.themeMode,

        // Navigation Configuration
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        navigatorKey: NavigationService.navigatorKey,
        navigatorObservers: [NavigationHistoryObserver()],

        // Disable debug banner
        debugShowCheckedModeBanner: false,

        // Localization delegates
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
