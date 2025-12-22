import 'package:flutter/material.dart';

// =========================================================
// ADAPTIVE COLOR CLASS
// =========================================================

class AdaptiveColor {
  final Color light;
  final Color dark;

  const AdaptiveColor({required this.light, required this.dark});

  Color resolve(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }

  // Convenience method for cleaner syntax
  Color call(BuildContext context) => resolve(context);

  // Add opacity support
  AdaptiveColor withOpacity(double opacity) {
    return AdaptiveColor(
      light: light.withOpacity(opacity),
      dark: dark.withOpacity(opacity),
    );
  }
}

// =========================================================
// APP COLORS - ORGANIZED & MAINTAINABLE
// =========================================================

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // =========================================================
  // BRAND COLORS
  // =========================================================

  static const Color brandPrimary = Color(0xFF0A1A2F);
  static const Color brandSecondary = Color(0xFFF4C430);
  static const Color brandAccent = Color(0xFFF2633B);
  static const Color brandGreen = Color(0xFF1FA45D);
  static const Color brandGray = Color(0xFFE6E8EC);

  // =========================================================
  // MATERIAL 3 SYSTEM COLORS - ADAPTIVE
  // =========================================================

  // Primary
  static const primary = AdaptiveColor(
    light: Color(0xFF0A1A2F),
    dark: Color(0xFF8FA8C8),
  );

  static const onPrimary = AdaptiveColor(
    light: Colors.white,
    dark: Colors.black,
  );

  static const primaryContainer = AdaptiveColor(
    light: Color(0xFF13263F),
    dark: Color(0xFF0A1A2F),
  );

  static const onPrimaryContainer = AdaptiveColor(
    light: Colors.white,
    dark: Colors.white,
  );

  // Secondary
  static const secondary = AdaptiveColor(
    light: Color(0xFFF4C430),
    dark: Color(0xFFFFD76A),
  );

  static const onSecondary = AdaptiveColor(
    light: Color(0xFF332400),
    dark: Colors.black,
  );

  static const secondaryContainer = AdaptiveColor(
    light: Color(0xFFFFF4CC),
    dark: Color(0xFF4A3A00),
  );

  static const onSecondaryContainer = AdaptiveColor(
    light: Color(0xFF2D1F00),
    dark: Color(0xFFFFF4CC),
  );

  // Tertiary (Accent)
  static const tertiary = AdaptiveColor(
    light: Color(0xFFF2633B),
    dark: Color(0xFFFF9D7F),
  );

  static const onTertiary = AdaptiveColor(
    light: Colors.white,
    dark: Colors.black,
  );

  static const tertiaryContainer = AdaptiveColor(
    light: Color(0xFFFFE7DF),
    dark: Color(0xFF661F0F),
  );

  static const onTertiaryContainer = AdaptiveColor(
    light: Color(0xFF3F0C00),
    dark: Color(0xFFFFE7DF),
  );

  // Error
  static const error = AdaptiveColor(
    light: Color(0xFFE63946),
    dark: Color(0xFFF2B8B5),
  );

  static const onError = AdaptiveColor(
    light: Colors.white,
    dark: Color(0xFF601410),
  );

  static const errorContainer = AdaptiveColor(
    light: Color(0xFFFFDAD6),
    dark: Color(0xFF8C1D18),
  );

  static const onErrorContainer = AdaptiveColor(
    light: Color(0xFF410002),
    dark: Color(0xFFFFDAD6),
  );

  // Surface
  static const surface = AdaptiveColor(
    light: Colors.white,
    dark: Color(0xFF0F131A),
  );

  static const onSurface = AdaptiveColor(
    light: Color(0xFF1A1A1A),
    dark: Colors.white,
  );

  static const surfaceVariant = AdaptiveColor(
    light: Color(0xFFE6E8EC),
    dark: Color(0xFF2C2F36),
  );

  static const onSurfaceVariant = AdaptiveColor(
    light: Color(0xFF4A4A4A),
    dark: Color(0xFFCAD6E3),
  );

  static const surfaceContainerHighest = AdaptiveColor(
    light: Color(0xFFF4F5F7),
    dark: Color(0xFF2F3137),
  );

  // Background
  static const background = AdaptiveColor(
    light: Color(0xFFFAFAFA),
    dark: Color(0xFF050A14),
  );

  static const onBackground = AdaptiveColor(
    light: Color(0xFF0A1A2F),
    dark: Colors.white,
  );

  // Outlines
  static const outline = AdaptiveColor(
    light: Color(0xFFC7C9CC),
    dark: Color(0xFF5A5F6A),
  );

  static const outlineVariant = AdaptiveColor(
    light: Color(0xFFEAECF0),
    dark: Color(0xFF404040),
  );

  // Shadow & Scrim
  static const shadow = AdaptiveColor(
    light: Colors.black,
    dark: Colors.black,
  );

  static const scrim = AdaptiveColor(
    light: Colors.black,
    dark: Colors.black,
  );

  // Inverse
  static const inverseSurface = AdaptiveColor(
    light: Color(0xFF2F3137),
    dark: Color(0xFFE6E8EC),
  );

  static const onInverseSurface = AdaptiveColor(
    light: Color(0xFFF4F4F4),
    dark: Color(0xFF121212),
  );

  static const inversePrimary = AdaptiveColor(
    light: Color(0xFFF4C430),
    dark: Color(0xFFF4C430),
  );

  // =========================================================
  // SEMANTIC COLORS - ADAPTIVE
  // =========================================================

  static const success = AdaptiveColor(
    light: Color(0xFF1FA45D),
    dark: Color(0xFF34D399),
  );

  static const onSuccess = AdaptiveColor(
    light: Colors.white,
    dark: Colors.black,
  );

  static const warning = AdaptiveColor(
    light: Color(0xFFF4C430),
    dark: Color(0xFFFBBF24),
  );

  static const onWarning = AdaptiveColor(
    light: Colors.black,
    dark: Colors.black,
  );

  static const info = AdaptiveColor(
    light: Color(0xFF3B82F6),
    dark: Color(0xFF60A5FA),
  );

  static const onInfo = AdaptiveColor(
    light: Colors.white,
    dark: Colors.black,
  );

  // =========================================================
  // COMMON UI COLORS - ADAPTIVE
  // =========================================================

  static const red = AdaptiveColor(
    light: Color(0xFFEF4444),
    dark: Color(0xFFF87171),
  );

  static const orange = AdaptiveColor(
    light: Color(0xFFF97316),
    dark: Color(0xFFFB923C),
  );

  static const yellow = AdaptiveColor(
    light: Color(0xFFEAB308),
    dark: Color(0xFFFACC15),
  );

  static const green = AdaptiveColor(
    light: Color(0xFF22C55E),
    dark: Color(0xFF4ADE80),
  );

  static const blue = AdaptiveColor(
    light: Color(0xFF3B82F6),
    dark: Color(0xFF60A5FA),
  );

  static const purple = AdaptiveColor(
    light: Color(0xFF9333EA),
    dark: Color(0xFFA78BFA),
  );

  static const pink = AdaptiveColor(
    light: Color(0xFFEC4899),
    dark: Color(0xFFF472B6),
  );

  static const cyan = AdaptiveColor(
    light: Color(0xFF06B6D4),
    dark: Color(0xFF22D3EE),
  );

  static const indigo = AdaptiveColor(
    light: Color(0xFF6366F1),
    dark: Color(0xFF818CF8),
  );

  static const emerald = AdaptiveColor(
    light: Color(0xFF10B981),
    dark: Color(0xFF34D399),
  );

  // =========================================================
  // TEXT COLORS - ADAPTIVE
  // =========================================================

  static const text = AdaptiveColor(
    light: Color(0xFF0A1A2F),
    dark: Colors.white,
  );

  static const textSecondary = AdaptiveColor(
    light: Color(0xFF4A4A4A),
    dark: Color(0xFFCAD6E3),
  );

  static const textTertiary = AdaptiveColor(
    light: Color(0xFF9CA3AF),
    dark: Color(0xFF6B7280),
  );

  static const textDisabled = AdaptiveColor(
    light: Color(0xFFD1D5DB),
    dark: Color(0xFF4B5563),
  );

  // =========================================================
  // BORDER & DIVIDER COLORS - ADAPTIVE
  // =========================================================

  static const border = AdaptiveColor(
    light: Color(0xFFEFEFEF),
    dark: Color(0xFF2F3137),
  );

  static const divider = AdaptiveColor(
    light: Color(0xFFE6E8EC),
    dark: Color(0xFF3A3D45),
  );

  // =========================================================
  // SPECIAL PURPOSE COLORS
  // =========================================================

  // Complaint/Report specific colors
  static const complaint = AdaptiveColor(
    light: Color(0xFFEF4444),
    dark: Color(0xFFDC2626),
  );

  static const complaintBackground = AdaptiveColor(
    light: Color(0xFFFFEEF0),
    dark: Color(0xFF2D1517),
  );

  // Hero gradients
  static const heroGradientStart = AdaptiveColor(
    light: Color(0xFF0A1A2F),
    dark: Color(0xFF051029),
  );

  static const heroGradientEnd = AdaptiveColor(
    light: Color(0xFF13263F),
    dark: Color(0xFF0F1B3A),
  );

  // =========================================================
  // STATIC GRADIENT COLORS (for complex gradients)
  // =========================================================

  static const Color cyan50 = Color(0xFFECFEFF);
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color cyan500 = Color(0xFF06B6D4);
  static const Color cyan600 = Color(0xFF0891B2);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF16A34A);
  static const Color purple500 = Color(0xFF9333EA);
  static const Color purple600 = Color(0xFF7C3AED);
  static const Color pink500 = Color(0xFFEC4899);
  static const Color pink600 = Color(0xFFDB2777);

  // With alpha
  static const Color cyan500Alpha30 = Color(0x4D06B6D4);
  static const Color blue600Alpha30 = Color(0x4D2563EB);
  static const Color purple500Alpha30 = Color(0x4D9333EA);
  static const Color pink500Alpha30 = Color(0x4DEC4899);
  static const Color complaint50 = Color(0xFFFFEEF0);
  static const Color complaint500 = Color(0xFFEF4444);
  static const Color complaint600 = Color(0xFFDC2626);
  static const Color complaint500Alpha20 = Color(0x33EF4444);
  static const Color complaint500Alpha30 = Color(0x4DEF4444);
  static const Color darkHeroStart = Color(0xFF051029);
  static const Color darkHeroEnd = Color(0xFF0F1B3A);

  // Additional static colors for themes
  static const Color lightTertiaryContainer = Color(0xFFFFE7DF);
  static const Color darkTertiaryContainer = Color(0xFF661F0F);
  static const Color darkErrorContainer = Color(0xFF8C1D18);
  static const Color darkSurface = Color(0xFF0F131A);
  static const Color darkBackground = Color(0xFF050A14);
  static const Color indigo500 = Color(0xFF6366F1);
}
