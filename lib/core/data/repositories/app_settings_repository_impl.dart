import 'package:flutter_clean_architecture_getx/core/domain/models/theme_mode_enum.dart';
import 'package:flutter_clean_architecture_getx/core/domain/repositories/app_settings_repository.dart';
import '../cache/preference/shared_preference.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  static const String _themeKey = 'app_settings:theme_mode';
  static const String _localeKey = 'app_settings:locale';

  @override
  Future<AppThemeMode> getThemeMode() async {
    try {
      final value = await SharedPreference.getValue(_themeKey);
      if (value == null) {
        return AppThemeMode.system;
      }
      return AppThemeMode.fromString(value);
    } catch (e) {
      return AppThemeMode.system;
    }
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) async {
    await SharedPreference.setValue(_themeKey, mode.toStringValue());
  }

  @override
  Future<String?> getLocale() async {
    return await SharedPreference.getValue(_localeKey);
  }

  @override
  Future<void> setLocale(String locale) async {
    await SharedPreference.setValue(_localeKey, locale);
  }

  @override
  Future<void> clearSettings() async {
    await SharedPreference.remove(_themeKey);
    await SharedPreference.remove(_localeKey);
  }
}

