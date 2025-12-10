import 'package:flutter/material.dart';

/// Extension on BuildContext to access theme colors easily
extension ThemeExtensions on BuildContext {
  /// Get the current ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get the current TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Check if current theme is light
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  // Primary Colors
  Color get primaryColor => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;

  // Secondary Colors
  Color get secondaryColor => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;

  // Tertiary Colors
  Color get tertiaryColor => colorScheme.tertiary;
  Color get onTertiary => colorScheme.onTertiary;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;

  // Error Colors
  Color get errorColor => colorScheme.error;
  Color get onError => colorScheme.onError;
  Color get errorContainer => colorScheme.errorContainer;
  Color get onErrorContainer => colorScheme.onErrorContainer;

  // Surface Colors
  Color get surfaceColor => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get surfaceVariant => colorScheme.surfaceVariant;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;

  // Background Colors
  Color get backgroundColor => colorScheme.background;
  Color get onBackground => colorScheme.onBackground;

  // Outline Colors
  Color get outlineColor => colorScheme.outline;
  Color get outlineVariant => colorScheme.outlineVariant;

  // Other Colors
  Color get shadowColor => colorScheme.shadow;
  Color get scrimColor => colorScheme.scrim;
  Color get inverseSurface => colorScheme.inverseSurface;
  Color get onInverseSurface => colorScheme.onInverseSurface;
  Color get inversePrimary => colorScheme.inversePrimary;

  // Display Text Styles
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;

  // Headline Text Styles
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;

  // Title Text Styles
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;

  // Body Text Styles
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;

  // Label Text Styles
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

/// Extension for accessing custom colors via context
extension CustomColorsContextExtension on BuildContext {
  Color get successColor => colorScheme.successColor;
  Color get onSuccess => colorScheme.onSuccess;
  Color get successContainer => colorScheme.successContainer;
  Color get onSuccessContainer => colorScheme.onSuccessContainer;

  Color get warningColor => colorScheme.warningColor;
  Color get onWarning => colorScheme.onWarning;
  Color get warningContainer => colorScheme.warningContainer;
  Color get onWarningContainer => colorScheme.onWarningContainer;

  Color get infoColor => colorScheme.infoColor;
  Color get onInfo => colorScheme.onInfo;
  Color get infoContainer => colorScheme.infoContainer;
  Color get onInfoContainer => colorScheme.onInfoContainer;

  Color get dividerColor => colorScheme.dividerColor;
  Color get borderColor => colorScheme.borderColor;
}

