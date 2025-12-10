import '../models/theme_mode_enum.dart';

abstract class AppSettingsRepository {
  /// Get the current theme mode
  Future<AppThemeMode> getThemeMode();

  /// Save theme mode preference
  Future<void> setThemeMode(AppThemeMode mode);

  /// Get locale preference
  Future<String?> getLocale();

  /// Save locale preference
  Future<void> setLocale(String locale);

  /// Clear all app settings
  Future<void> clearSettings();
}

