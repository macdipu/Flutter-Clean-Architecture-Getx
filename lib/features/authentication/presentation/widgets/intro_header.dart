import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroHeader extends StatelessWidget {
  final String title;
  final String? introText;
  final Widget? localeSwitch;

  IntroHeader({
    Key? key,
    required this.title,
    this.introText,
    this.localeSwitch,
  }) : super(key: key);

  final theme = Theme.of(Get.context!);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineMedium,
            ),
            localeSwitch ?? const SizedBox.shrink(),
          ],
        ),
        if (introText != null) ...[
          const SizedBox(height: 8),
          Text(
            introText!,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ],
    );
  }
}
