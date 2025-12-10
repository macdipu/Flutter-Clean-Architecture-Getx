import 'package:flutter/material.dart';

import '../../../../res/resources.dart';
import '../../theme/theme_extensions.dart';

class CommonSuccessScreen extends StatelessWidget {
  final String? asset;
  final String? title;
  final String? subTitle;
  final Widget? button;
  final EdgeInsets? padding;
  final Size? size;
  final VoidCallback onDismiss;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const CommonSuccessScreen({
    super.key,
    this.asset,
    this.title,
    this.subTitle,
    this.button,
    this.padding,
    this.size,
    required this.onDismiss,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onDismiss,
            child: Container(
              margin: const EdgeInsets.only(top: 16, right: 16),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.clear,
                size: 24,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Image.asset(
              asset ?? Resources.drawable.seen,
              height: size?.height ?? 84,
              width: size?.width ?? 84,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24, bottom: 16),
            child: Text(
              title ?? 'successful',
              style: titleStyle ?? context.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16, left: 16),
            child: Text(
              subTitle ?? "",
              style: subtitleStyle ?? context.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          button != null
              ? Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: button,
                )
              : const SizedBox(height: 16),
        ],
      ),
    );
  }
}

