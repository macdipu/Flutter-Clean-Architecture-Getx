import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  /// Theme shortcuts
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  /// Brightness
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => theme.brightness == Brightness.light;

  // ---------------------------------------------------------------------------
  // ColorScheme aliases
  // ---------------------------------------------------------------------------

  // Primary
  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;

  // Secondary
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;

  // Tertiary
  Color get tertiary => colorScheme.tertiary;
  Color get onTertiary => colorScheme.onTertiary;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;

  // Error
  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;
  Color get errorContainer => colorScheme.errorContainer;
  Color get onErrorContainer => colorScheme.onErrorContainer;

  // Surface
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get surfaceVariant => colorScheme.surfaceVariant;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;

  // Background
  Color get background => colorScheme.background;
  Color get onBackground => colorScheme.onBackground;

  // Outline
  Color get outline => colorScheme.outline;
  Color get outlineVariant => colorScheme.outlineVariant;

  // Misc
  Color get shadow => colorScheme.shadow;
  Color get scrim => colorScheme.scrim;
  Color get inverseSurface => colorScheme.inverseSurface;
  Color get onInverseSurface => colorScheme.onInverseSurface;
  Color get inversePrimary => colorScheme.inversePrimary;

  // ---------------------------------------------------------------------------
  // Custom semantic colors
  // ---------------------------------------------------------------------------

  Color get success => colorScheme.successColor;
  Color get onSuccess => colorScheme.onSuccess;

  Color get successContainer => colorScheme.successContainer;
  Color get onSuccessContainer => colorScheme.onSuccessContainer;

  Color get warning => colorScheme.warningColor;
  Color get onWarning => colorScheme.onWarning;

  Color get warningContainer => colorScheme.warningContainer;
  Color get onWarningContainer => colorScheme.onWarningContainer;

  Color get info => colorScheme.infoColor;
  Color get onInfo => colorScheme.onInfo;

  Color get infoContainer => colorScheme.infoContainer;
  Color get onInfoContainer => colorScheme.onInfoContainer;

  Color get divider => colorScheme.dividerColor;
  Color get border => colorScheme.borderColor;

  // ---------------------------------------------------------------------------
  // Text styles
  // ---------------------------------------------------------------------------

  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;

  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;

  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;

  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;

  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;
}

/// Extension for custom colors (success, warning, info)
extension CustomColorsExtension on ColorScheme {
  /// Success color based on theme
  Color get successColor {
    return brightness == Brightness.light
        ? const Color(0xFF39B54A)
        : const Color(0xFF8FE59B);
  }

  Color get onSuccess {
    return brightness == Brightness.light
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000);
  }

  Color get successContainer {
    return brightness == Brightness.light
        ? const Color(0xFFECF9ED)
        : const Color(0xFF126836);
  }

  Color get onSuccessContainer {
    return brightness == Brightness.light
        ? const Color(0xFF126836)
        : const Color(0xFFECF9ED);
  }

  /// Warning color based on theme
  Color get warningColor {
    return brightness == Brightness.light
        ? const Color(0xFFEEB50B)
        : const Color(0xFFEDA109);
  }

  Color get onWarning {
    return const Color(0xFF000000);
  }

  Color get warningContainer {
    return brightness == Brightness.light
        ? const Color(0xFFFFF9E5)
        : const Color(0xFF5C4600);
  }

  Color get onWarningContainer {
    return brightness == Brightness.light
        ? const Color(0xFF3D2E00)
        : const Color(0xFFFFF9E5);
  }

  /// Info color (using tertiary)
  Color get infoColor => tertiary;
  Color get onInfo => onTertiary;
  Color get infoContainer => tertiaryContainer;
  Color get onInfoContainer => onTertiaryContainer;

  /// Divider color
  Color get dividerColor {
    return brightness == Brightness.light
        ? const Color(0xFFEAECF0)
        : const Color(0xFF404040);
  }

  /// Border color
  Color get borderColor {
    return brightness == Brightness.light
        ? const Color(0xFFF4F4F4)
        : const Color(0xFF2F3137);
  }
}
