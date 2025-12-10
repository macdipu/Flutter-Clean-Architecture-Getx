import 'package:flutter/material.dart';

/// App Spacing Constants
///
/// Use these instead of Resources.dimension for consistent spacing across the app
///
/// Usage:
/// ```dart
/// EdgeInsets.all(AppSpacing.md)
/// SizedBox(height: AppSpacing.lg)
/// Padding(padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm))
/// ```
class AppSpacing {
  AppSpacing._(); // Private constructor to prevent instantiation

  // Base spacing values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Common padding presets
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  // Horizontal padding presets
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding presets
  static const EdgeInsets verticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(vertical: xl);
}

/// App Border Radius Constants
///
/// Usage:
/// ```dart
/// BorderRadius.circular(AppRadius.sm)
/// decoration: BoxDecoration(borderRadius: AppRadius.roundedSM)
/// ```
class AppRadius {
  AppRadius._(); // Private constructor

  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0; // For fully rounded corners

  // Common BorderRadius presets
  static final BorderRadius roundedNone = BorderRadius.circular(none);
  static final BorderRadius roundedXS = BorderRadius.circular(xs);
  static final BorderRadius roundedSM = BorderRadius.circular(sm);
  static final BorderRadius roundedMD = BorderRadius.circular(md);
  static final BorderRadius roundedLG = BorderRadius.circular(lg);
  static final BorderRadius roundedXL = BorderRadius.circular(xl);
  static final BorderRadius roundedFull = BorderRadius.circular(full);
}

/// App Elevation Constants
///
/// Usage:
/// ```dart
/// Card(elevation: AppElevation.md)
/// Material(elevation: AppElevation.high)
/// ```
class AppElevation {
  AppElevation._(); // Private constructor

  static const double none = 0.0;
  static const double low = 2.0;
  static const double medium = 4.0;
  static const double high = 8.0;
  static const double veryHigh = 16.0;
}

/// App Icon Size Constants
///
/// Usage:
/// ```dart
/// Icon(Icons.home, size: AppIconSize.md)
/// ```
class AppIconSize {
  AppIconSize._(); // Private constructor

  static const double xs = 16.0;
  static const double sm = 20.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 48.0;
  static const double xxl = 64.0;
}

/// App Duration Constants for Animations
///
/// Usage:
/// ```dart
/// AnimatedContainer(duration: AppDuration.short)
/// ```
class AppDuration {
  AppDuration._(); // Private constructor

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
  static const Duration veryLong = Duration(milliseconds: 800);
}

