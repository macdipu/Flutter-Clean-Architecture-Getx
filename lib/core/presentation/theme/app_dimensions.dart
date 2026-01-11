import 'package:flutter/material.dart';

/// Single access point for all design dimensions
///
/// Usage:
/// ```dart
/// AppDimens.spacing.s16
/// AppDimens.spacing.p16
/// AppDimens.radius.br12
/// AppDimens.elevation.e4
/// AppDimens.icon.s24
/// AppDimens.duration.ms300
/// ```
class AppDimens {
  AppDimens._();

  static const spacing = _Spacing();
  static const radius = _Radius();
  static const elevation = _Elevation();
  static const icon = _IconSize();
  static final duration = _Duration();
}

/// --------------------
/// Spacing
/// --------------------
class _Spacing {
  const _Spacing();

  // raw spacing values (dp)
  final double s4  = 4;
  final double s8  = 8;
  final double s16 = 16;
  final double s24 = 24;
  final double s32 = 32;
  final double s48 = 48;

  // padding
  EdgeInsets get p4  => const EdgeInsets.all(4);
  EdgeInsets get p8  => const EdgeInsets.all(8);
  EdgeInsets get p16 => const EdgeInsets.all(16);
  EdgeInsets get p24 => const EdgeInsets.all(24);
  EdgeInsets get p32 => const EdgeInsets.all(32);

  // horizontal
  EdgeInsets get h4  => const EdgeInsets.symmetric(horizontal: 4);
  EdgeInsets get h8  => const EdgeInsets.symmetric(horizontal: 8);
  EdgeInsets get h16 => const EdgeInsets.symmetric(horizontal: 16);
  EdgeInsets get h24 => const EdgeInsets.symmetric(horizontal: 24);

  // vertical
  EdgeInsets get v4  => const EdgeInsets.symmetric(vertical: 4);
  EdgeInsets get v8  => const EdgeInsets.symmetric(vertical: 8);
  EdgeInsets get v16 => const EdgeInsets.symmetric(vertical: 16);
  EdgeInsets get v24 => const EdgeInsets.symmetric(vertical: 24);
}

/// --------------------
/// Radius
/// --------------------
class _Radius {
  const _Radius();

  final double r0  = 0;
  final double r4  = 4;
  final double r8  = 8;
  final double r12 = 12;
  final double r16 = 16;
  final double r24 = 24;
  final double full = 9999;

  BorderRadius get none => BorderRadius.circular(0);
  BorderRadius get br4  => BorderRadius.circular(4);
  BorderRadius get br8  => BorderRadius.circular(8);
  BorderRadius get br12 => BorderRadius.circular(12);
  BorderRadius get br16 => BorderRadius.circular(16);
  BorderRadius get br24 => BorderRadius.circular(24);
  BorderRadius get brFull => BorderRadius.circular(9999);
}

/// --------------------
/// Elevation
/// --------------------
class _Elevation {
  const _Elevation();

  final double e0  = 0;
  final double e2  = 2;
  final double e4  = 4;
  final double e8  = 8;
  final double e16 = 16;
}

/// --------------------
/// Icon Size
/// --------------------
class _IconSize {
  const _IconSize();

  final double s16 = 16;
  final double s20 = 20;
  final double s24 = 24;
  final double s32 = 32;
  final double s48 = 48;
  final double s64 = 64;
}

/// --------------------
/// Duration
/// --------------------
class _Duration {
  _Duration();

  final Duration ms100 = Duration(milliseconds: 100);
  final Duration ms200 = Duration(milliseconds: 200);
  final Duration ms300 = Duration(milliseconds: 300);
  final Duration ms500 = Duration(milliseconds: 500);
  final Duration ms800 = Duration(milliseconds: 800);
}
