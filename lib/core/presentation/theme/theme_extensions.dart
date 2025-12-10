import 'package:flutter/material.dart';

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

  // Display Text Styles (Largest - 57sp, 45sp, 36sp)
  TextStyle? get displayLarge => textTheme.displayLarge;     // 57sp - Hero text
  TextStyle? get displayMedium => textTheme.displayMedium;   // 45sp - Very large
  TextStyle? get displaySmall => textTheme.displaySmall;     // 36sp - Large

  // Headline Text Styles (32sp, 28sp, 24sp)
  TextStyle? get headlineLarge => textTheme.headlineLarge;   // 32sp - Main headlines
  TextStyle? get headlineMedium => textTheme.headlineMedium; // 28sp - Sub headlines
  TextStyle? get headlineSmall => textTheme.headlineSmall;   // 24sp - Small headlines

  // Title Text Styles (22sp, 16sp, 14sp)
  TextStyle? get titleLarge => textTheme.titleLarge;         // 22sp - Large titles
  TextStyle? get titleMedium => textTheme.titleMedium;       // 16sp - Default ⭐
  TextStyle? get titleSmall => textTheme.titleSmall;         // 14sp - Small titles

  // Body Text Styles (16sp, 14sp, 12sp)
  TextStyle? get bodyLarge => textTheme.bodyLarge;           // 16sp - Large body
  TextStyle? get bodyMedium => textTheme.bodyMedium;         // 14sp - Default ⭐
  TextStyle? get bodySmall => textTheme.bodySmall;           // 12sp - Small body

  // Label Text Styles (14sp, 12sp, 11sp)
  TextStyle? get labelLarge => textTheme.labelLarge;         // 14sp - Buttons
  TextStyle? get labelMedium => textTheme.labelMedium;       // 12sp - Labels
  TextStyle? get labelSmall => textTheme.labelSmall;         // 11sp - Tiny
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

