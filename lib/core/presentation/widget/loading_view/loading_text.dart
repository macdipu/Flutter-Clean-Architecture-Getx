import 'package:flutter/material.dart';
import '../../theme/theme_extensions.dart';

class LoadingText extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color? color;
  final double? size;
  final double? strokeWidth;

  const LoadingText({
    super.key,
    required this.isLoading,
    required this.child,
    this.color,
    this.size,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            height: size ?? 20,
            width: size ?? 20,
            child: CircularProgressIndicator(
              color: color ?? context.primaryColor,
              strokeWidth: strokeWidth ?? 3,
            ),
          )
        : child;
  }
}
