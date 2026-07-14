import 'package:flutter/material.dart';
import 'color_schemes.dart';

/// ============================================================
/// APP DIMENS
/// ============================================================
///
/// Usage:
///
/// ```dart
/// AppDimens.spacing.s16
/// context.dimens.spacing.s16
///
/// AppDimens.spacing.p16
/// context.dimens.spacing.p16
///
/// AppDimens.spacing.w16
/// AppDimens.spacing.h16
///
/// AppDimens.radius.br12
/// context.dimens.radius.br12
///
/// AppDimens.icon.s24
///
/// AppDimens.duration.ms300
/// ```
/// ============================================================

class AppDimens {
  AppDimens._();

  static const spacing = _Spacing();
  static const radius = _Radius();
  static const elevation = _Elevation();
  static const icon = _IconSize();
  static const border = _BorderWidth();
  static const avatar = _AvatarSize();
  static const constraints = _Constraints();
  static const shadow = _Shadows();
  static final duration = _Duration();
}

/// ============================================================
/// CONTEXT EXTENSION
/// ============================================================

extension AppDimensContextExtension on BuildContext {
  AppDimensGetter get dimens => const AppDimensGetter();

  bool get isTablet => MediaQuery.sizeOf(this).width >= 768;

  bool get isMobile => MediaQuery.sizeOf(this).width < 768;

  double responsive({
    required double mobile,
    required double tablet,
  }) {
    return isTablet ? tablet : mobile;
  }
}

@immutable
class AppDimensGetter {
  const AppDimensGetter();

  _Spacing get spacing => AppDimens.spacing;

  _Radius get radius => AppDimens.radius;

  _Elevation get elevation => AppDimens.elevation;

  _IconSize get icon => AppDimens.icon;

  _BorderWidth get border => AppDimens.border;

  _AvatarSize get avatar => AppDimens.avatar;

  _Constraints get constraints => AppDimens.constraints;

  _Shadows get shadow => AppDimens.shadow;

  _Duration get duration => AppDimens.duration;
}

/// ============================================================
/// SPACING
/// ============================================================

@immutable
class _Spacing {
  const _Spacing();

  // raw sizes
  final double s0 = 0;
  final double s2 = 2;
  final double s4 = 4;
  final double s6 = 6;
  final double s8 = 8;
  final double s10 = 10;
  final double s12 = 12;
  final double s14 = 14;
  final double s16 = 16;
  final double s18 = 18;
  final double s20 = 20;
  final double s24 = 24;
  final double s28 = 28;
  final double s32 = 32;
  final double s40 = 40;
  final double s48 = 48;
  final double s56 = 56;
  final double s64 = 64;

  // all padding
  EdgeInsets get p0 => const EdgeInsets.all(0);

  EdgeInsets get p4 => const EdgeInsets.all(4);

  EdgeInsets get p8 => const EdgeInsets.all(8);

  EdgeInsets get p12 => const EdgeInsets.all(12);

  EdgeInsets get p16 => const EdgeInsets.all(16);

  EdgeInsets get p20 => const EdgeInsets.all(20);

  EdgeInsets get p24 => const EdgeInsets.all(24);

  EdgeInsets get p32 => const EdgeInsets.all(32);

  // horizontal padding
  EdgeInsets get ph4 => const EdgeInsets.symmetric(horizontal: 4);

  EdgeInsets get ph8 => const EdgeInsets.symmetric(horizontal: 8);

  EdgeInsets get ph12 => const EdgeInsets.symmetric(horizontal: 12);

  EdgeInsets get ph16 => const EdgeInsets.symmetric(horizontal: 16);

  EdgeInsets get ph20 => const EdgeInsets.symmetric(horizontal: 20);

  EdgeInsets get ph24 => const EdgeInsets.symmetric(horizontal: 24);

  // vertical padding
  EdgeInsets get pv4 => const EdgeInsets.symmetric(vertical: 4);

  EdgeInsets get pv8 => const EdgeInsets.symmetric(vertical: 8);

  EdgeInsets get pv12 => const EdgeInsets.symmetric(vertical: 12);

  EdgeInsets get pv16 => const EdgeInsets.symmetric(vertical: 16);

  EdgeInsets get pv20 => const EdgeInsets.symmetric(vertical: 20);

  EdgeInsets get pv24 => const EdgeInsets.symmetric(vertical: 24);

  // width gaps
  SizedBox get w4 => const SizedBox(width: 4);

  SizedBox get w8 => const SizedBox(width: 8);

  SizedBox get w12 => const SizedBox(width: 12);

  SizedBox get w16 => const SizedBox(width: 16);

  SizedBox get w20 => const SizedBox(width: 20);

  SizedBox get w24 => const SizedBox(width: 24);

  SizedBox get w32 => const SizedBox(width: 32);

  // height gaps
  SizedBox get h4 => const SizedBox(height: 4);

  SizedBox get h8 => const SizedBox(height: 8);

  SizedBox get h12 => const SizedBox(height: 12);

  SizedBox get h16 => const SizedBox(height: 16);

  SizedBox get h20 => const SizedBox(height: 20);

  SizedBox get h24 => const SizedBox(height: 24);

  SizedBox get h32 => const SizedBox(height: 32);

  // common screen paddings
  EdgeInsets get screenPadding =>
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  EdgeInsets get pagePadding => const EdgeInsets.all(16);
}

/// ============================================================
/// RADIUS
/// ============================================================

@immutable
class _Radius {
  const _Radius();

  final double r0 = 0;
  final double r4 = 4;
  final double r8 = 8;
  final double r12 = 12;
  final double r16 = 16;
  final double r20 = 20;
  final double r24 = 24;
  final double r32 = 32;
  final double full = 9999;

  BorderRadius get br0 => BorderRadius.circular(0);

  BorderRadius get br4 => BorderRadius.circular(4);

  BorderRadius get br8 => BorderRadius.circular(8);

  BorderRadius get br12 => BorderRadius.circular(12);

  BorderRadius get br16 => BorderRadius.circular(16);

  BorderRadius get br20 => BorderRadius.circular(20);

  BorderRadius get br24 => BorderRadius.circular(24);

  BorderRadius get br32 => BorderRadius.circular(32);

  BorderRadius get brFull => BorderRadius.circular(9999);
}

/// ============================================================
/// ELEVATION
/// ============================================================

@immutable
class _Elevation {
  const _Elevation();

  final double e0 = 0;
  final double e1 = 1;
  final double e2 = 2;
  final double e4 = 4;
  final double e8 = 8;
  final double e12 = 12;
  final double e16 = 16;
  final double e24 = 24;
}

/// ============================================================
/// ICON SIZE
/// ============================================================

@immutable
class _IconSize {
  const _IconSize();

  final double s12 = 12;
  final double s16 = 16;
  final double s20 = 20;
  final double s24 = 24;
  final double s28 = 28;
  final double s32 = 32;
  final double s40 = 40;
  final double s48 = 48;
  final double s56 = 56;
  final double s64 = 64;
}

/// ============================================================
/// BORDER WIDTH
/// ============================================================

@immutable
class _BorderWidth {
  const _BorderWidth();

  final double s05 = 0.5;
  final double s1 = 1;
  final double s15 = 1.5;
  final double s2 = 2;
  final double s4 = 4;
}

/// ============================================================
/// AVATAR SIZE
/// ============================================================

@immutable
class _AvatarSize {
  const _AvatarSize();

  final double s24 = 24;
  final double s32 = 32;
  final double s40 = 40;
  final double s48 = 48;
  final double s56 = 56;
  final double s64 = 64;
  final double s72 = 72;
  final double s96 = 96;
}

/// ============================================================
/// CONSTRAINTS
/// ============================================================

@immutable
class _Constraints {
  const _Constraints();

  BoxConstraints get buttonMinHeight48 =>
      const BoxConstraints(minHeight: 48);

  BoxConstraints get buttonMinHeight56 =>
      const BoxConstraints(minHeight: 56);

  BoxConstraints get dialogMaxWidth500 =>
      const BoxConstraints(maxWidth: 500);

  BoxConstraints get bottomSheetMaxWidth700 =>
      const BoxConstraints(maxWidth: 700);
}

/// ============================================================
/// SHADOWS
/// ============================================================

@immutable
class _Shadows {
  const _Shadows();

  static final Color _shadowColor = AppColors.shadow.light.withValues(alpha: 0.08);

  List<BoxShadow> get s4 => [
    BoxShadow(
      blurRadius: 4,
      offset: const Offset(0, 2),
      color: _shadowColor,
    ),
  ];

  List<BoxShadow> get s8 => [
    BoxShadow(
      blurRadius: 8,
      offset: const Offset(0, 4),
      color: _shadowColor,
    ),
  ];

  List<BoxShadow> get s16 => [
    BoxShadow(
      blurRadius: 16,
      offset: const Offset(0, 8),
      color: _shadowColor,
    ),
  ];
}

/// ============================================================
/// DURATION
/// ============================================================

@immutable
class _Duration {
   _Duration();

  final Duration ms100 = Duration(milliseconds: 100);

  final Duration ms150 = Duration(milliseconds: 150);

  final Duration ms200 = Duration(milliseconds: 200);

  final Duration ms300 = Duration(milliseconds: 300);

  final Duration ms500 = Duration(milliseconds: 500);

  final Duration ms800 = Duration(milliseconds: 800);

  final Duration s1 = Duration(seconds: 1);
}