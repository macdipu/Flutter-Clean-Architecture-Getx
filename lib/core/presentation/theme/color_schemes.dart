import 'package:flutter/material.dart';

/// App Color Constants for Light and Dark Themes
abstract class AppColorConstants {
  // ===== LIGHT THEME COLORS =====

  // Primary Colors
  static const Color lightPrimary = Color(0xFFE6BD4E);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFFBF4E2);
  static const Color lightOnPrimaryContainer = Color(0xFF0A0B1C);

  // Secondary Colors
  static const Color lightSecondary = Color(0xFF0A0B1C);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFEAECF0);
  static const Color lightOnSecondaryContainer = Color(0xFF121212);

  // Tertiary Colors
  static const Color lightTertiary = Color(0xFF3771C8);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFFEEF6FB);
  static const Color lightOnTertiaryContainer = Color(0xFF080D21);

  // Error Colors
  static const Color lightError = Color(0xFFDC3044);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFF9EDEC);
  static const Color lightOnErrorContainer = Color(0xFFBF392B);

  // Surface Colors
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF121212);
  static const Color lightSurfaceContainerHighest = Color(0xFFF4F5F7);
  static const Color lightOnSurfaceVariant = Color(0xFF4A4A4A);

  // Background Colors
  static const Color lightBackground = Color(0xFFFBFBFB);
  static const Color lightOnBackground = Color(0xFF121212);

  // Outline Colors
  static const Color lightOutline = Color(0xFFC9CCD2);
  static const Color lightOutlineVariant = Color(0xFFEAECF0);

  // Shadow & Overlay
  static const Color lightShadow = Color(0xFF000000);
  static const Color lightScrim = Color(0xFF000000);
  static const Color lightInverseSurface = Color(0xFF2F3137);
  static const Color lightOnInverseSurface = Color(0xFFF4F4F4);
  static const Color lightInversePrimary = Color(0xFFFAC242);

  // Divider & Border
  static const Color lightDivider = Color(0xFFEAECF0);
  static const Color lightBorder = Color(0xFFF4F4F4);

  // ===== DARK THEME COLORS =====

  // Primary Colors
  static const Color darkPrimary = Color(0xFFFAC242);
  static const Color darkOnPrimary = Color(0xFF3D2E00);
  static const Color darkPrimaryContainer = Color(0xFF171204);
  static const Color darkOnPrimaryContainer = Color(0xFFFBF4E2);

  // Secondary Colors
  static const Color darkSecondary = Color(0xFFE6BD4E);
  static const Color darkOnSecondary = Color(0xFF000000);
  static const Color darkSecondaryContainer = Color(0xFF2F3137);
  static const Color darkOnSecondaryContainer = Color(0xFFEAECF0);

  // Tertiary Colors
  static const Color darkTertiary = Color(0xFF95BEF9);
  static const Color darkOnTertiary = Color(0xFF080D21);
  static const Color darkTertiaryContainer = Color(0xFF17254D);
  static const Color darkOnTertiaryContainer = Color(0xFFEEF6FB);

  // Error Colors
  static const Color darkError = Color(0xFFEF655A);
  static const Color darkOnError = Color(0xFF000000);
  static const Color darkErrorContainer = Color(0xFFBF392B);
  static const Color darkOnErrorContainer = Color(0xFFF9EDEC);

  // Surface Colors
  static const Color darkSurface = Color(0xFF0F1117);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkSurfaceContainerHighest = Color(0xFF2F3137);
  static const Color darkOnSurfaceVariant = Color(0xFFCAD6E3);

  // Background Colors
  static const Color darkBackground = Color(0xFF06091B);
  static const Color darkOnBackground = Color(0xFFFFFFFF);

  // Outline Colors
  static const Color darkOutline = Color(0xFF535A73);
  static const Color darkOutlineVariant = Color(0xFF404040);

  // Shadow & Overlay
  static const Color darkShadow = Color(0xFF000000);
  static const Color darkScrim = Color(0xFF000000);
  static const Color darkInverseSurface = Color(0xFFEAECF0);
  static const Color darkOnInverseSurface = Color(0xFF121212);
  static const Color darkInversePrimary = Color(0xFFE6BD4E);

  // Divider & Border
  static const Color darkDivider = Color(0xFF404040);
  static const Color darkBorder = Color(0xFF2F3137);

  // ===== CUSTOM SEMANTIC COLORS =====

  // Success - Light
  static const Color lightSuccess = Color(0xFF39B54A);
  static const Color lightOnSuccess = Color(0xFFFFFFFF);
  static const Color lightSuccessContainer = Color(0xFFECF9ED);
  static const Color lightOnSuccessContainer = Color(0xFF126836);

  // Success - Dark
  static const Color darkSuccess = Color(0xFF8FE59B);
  static const Color darkOnSuccess = Color(0xFF000000);
  static const Color darkSuccessContainer = Color(0xFF126836);
  static const Color darkOnSuccessContainer = Color(0xFFECF9ED);

  // Warning - Light
  static const Color lightWarning = Color(0xFFEEB50B);
  static const Color lightOnWarning = Color(0xFF000000);
  static const Color lightWarningContainer = Color(0xFFFFF9E5);
  static const Color lightOnWarningContainer = Color(0xFF3D2E00);

  // Warning - Dark
  static const Color darkWarning = Color(0xFFEDA109);
  static const Color darkOnWarning = Color(0xFF000000);
  static const Color darkWarningContainer = Color(0xFF5C4600);
  static const Color darkOnWarningContainer = Color(0xFFFFF9E5);
}

