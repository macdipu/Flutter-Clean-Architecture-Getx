import 'package:flutter/material.dart';
import '../../theme/theme_extensions.dart';

/// A simple centered loading indicator
class LoadingView extends StatelessWidget {
  final Color? color;

  const LoadingView({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? context.primaryColor,
      ),
    );
  }
}

/// A loading view with a transparent dark overlay
class LoadingViewTransparent extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? loaderColor;
  final Color? backgroundColor;

  const LoadingViewTransparent({
    super.key,
    this.height,
    this.width,
    this.loaderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? const Color(0x80000000),
      height: height ?? MediaQuery.of(context).size.height,
      width: width ?? MediaQuery.of(context).size.width,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: context.surfaceColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            loaderColor ?? context.primaryColor,
          ),
        ),
      ),
    );
  }
}
