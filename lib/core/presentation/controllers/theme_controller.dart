import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/app_settings_repository_impl.dart';
import '../../domain/models/theme_mode_enum.dart';
import '../../domain/repositories/app_settings_repository.dart';

class ThemeController extends GetxController {
  final AppSettingsRepository _settingsRepository = AppSettingsRepositoryImpl();

  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  /// Load theme mode from storage
  Future<void> _loadThemeMode() async {
    try {
      _isLoading.value = true;
      final savedTheme = await _settingsRepository.getThemeMode();
      _themeMode.value = _convertToThemeMode(savedTheme);
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
      _themeMode.value = ThemeMode.system;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Change theme mode
  Future<void> changeThemeMode(ThemeMode mode) async {
    try {
      _themeMode.value = mode;
      Get.changeThemeMode(mode);

      final appThemeMode = _convertToAppThemeMode(mode);
      await _settingsRepository.setThemeMode(appThemeMode);

      debugPrint('Theme mode changed to: $mode');
    } catch (e) {
      debugPrint('Error changing theme mode: $e');
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (_themeMode.value == ThemeMode.light) {
      await changeThemeMode(ThemeMode.dark);
    } else {
      await changeThemeMode(ThemeMode.light);
    }
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await changeThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await changeThemeMode(ThemeMode.dark);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    await changeThemeMode(ThemeMode.system);
  }

  /// Check if current theme is dark
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  /// Check if current theme is light
  bool get isLightMode {
    if (_themeMode.value == ThemeMode.system) {
      return !Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.light;
  }

  /// Convert AppThemeMode to ThemeMode
  ThemeMode _convertToThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Convert ThemeMode to AppThemeMode
  AppThemeMode _convertToAppThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
      case ThemeMode.system:
        return AppThemeMode.system;
    }
  }
}

