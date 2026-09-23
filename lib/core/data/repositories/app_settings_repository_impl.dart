import 'package:customer/core/domain/models/theme_mode_enum.dart';
import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import '../cache/preference/base_preference.dart';
import '../cache/preference/plain_preference.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  AppSettingsRepositoryImpl({BasePreference store = const PlainPreference()}) : _store = store;

  final BasePreference _store;

  static const String _themeKey = 'app_settings:theme_mode';
  static const String _localeKey = 'app_settings:locale';

  @override
  Future<AppThemeMode> getThemeMode() async {
    try {
      final value = await _store.getValue(_themeKey);
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
    await _store.setValue(_themeKey, mode.toStringValue());
  }

  @override
  Future<String?> getLocale() async {
    return await _store.getValue(_localeKey);
  }

  @override
  Future<void> setLocale(String locale) async {
    await _store.setValue(_localeKey, locale);
  }

  @override
  Future<void> clearSettings() async {
    await _store.remove(_themeKey);
    await _store.remove(_localeKey);
  }
}
