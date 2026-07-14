import 'package:flutter/material.dart';
import 'color_schemes.dart';

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
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;

  // Layered surface tiers (card/dialog/sheet hierarchy)
  Color get surfaceContainerLowest => colorScheme.surfaceContainerLowest;
  Color get surfaceContainerLow => colorScheme.surfaceContainerLow;
  Color get surfaceContainer => colorScheme.surfaceContainer;
  Color get surfaceContainerHigh => colorScheme.surfaceContainerHigh;
  Color get surfaceContainerHighest => colorScheme.surfaceContainerHighest;

  /// Background - alias for [surface], the Material 3 role it replaced.
  Color get background => colorScheme.surface;
  Color get onBackground => colorScheme.onSurface;

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

/// Extension for custom semantic colors (success, warning, info, divider,
/// border) that aren't part of Material's [ColorScheme]. Backed by
/// [AppColors] - the single source of truth for every adaptive color in the
/// app - so there is exactly one place to edit a token.
extension CustomColorsExtension on ColorScheme {
  bool get _isDark => brightness == Brightness.dark;

  Color _pick(AdaptiveColor c) => _isDark ? c.dark : c.light;

  Color get successColor => _pick(AppColors.success);
  Color get onSuccess => _pick(AppColors.onSuccess);
  Color get successContainer => _pick(AppColors.successContainer);
  Color get onSuccessContainer => _pick(AppColors.onSuccessContainer);

  Color get warningColor => _pick(AppColors.warning);
  Color get onWarning => _pick(AppColors.onWarning);
  Color get warningContainer => _pick(AppColors.warningContainer);
  Color get onWarningContainer => _pick(AppColors.onWarningContainer);

  Color get infoColor => _pick(AppColors.info);
  Color get onInfo => _pick(AppColors.onInfo);
  Color get infoContainer => _pick(AppColors.infoContainer);
  Color get onInfoContainer => _pick(AppColors.onInfoContainer);

  Color get dividerColor => _pick(AppColors.divider);
  Color get borderColor => _pick(AppColors.border);
}
