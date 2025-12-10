enum AppThemeMode {
  light,
  dark,
  system;

  static AppThemeMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
        return AppThemeMode.system;
      default:
        return AppThemeMode.system;
    }
  }

  String toStringValue() {
    return name;
  }
}

