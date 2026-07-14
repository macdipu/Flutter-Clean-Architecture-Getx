import 'dart:ui';

import 'package:flutter/material.dart';
import '../../theme/color_schemes.dart';
import '../../theme/theme_extensions.dart';

class CommonBackground extends StatelessWidget {
  final Widget? widget;

  const CommonBackground({this.widget, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.secondary,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              // blendMode: BlendMode.srcOver,
              child: Container(
                height: 375,
                width: 375,
                // alignment: Alignment.topRight,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      context.primary.withValues(alpha: 0.14),
                      AppColors.heroGradientStart.resolve(context),
                    ],
                    center: const Alignment(0, 0),
                  ),
                ),
              ),
            ),
            // ),
            Positioned(
              bottom: -75,
              left: -75,
              child: Center(
                child: Container(
                  height: 375,
                  width: 375,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      context.secondary.withValues(alpha: 0.35),
                      AppColors.heroGradientEnd.resolve(context),
                    ]),
                  ),
                ),
              ),
            ),
            // widget!,
          ],
        ),
      ),
    );
  }
}
