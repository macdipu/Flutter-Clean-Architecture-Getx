import 'package:flutter/material.dart';
import '../../theme/theme_extensions.dart';

class CommonEmptyView extends StatelessWidget {
  final String? message;

  const CommonEmptyView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /*Container(
          height: 120,
          width: 140,
          margin: const EdgeInsets.only(bottom: 24, top: 100),
          child: Image.asset(Resources.drawable.noCampaigns),
        ),*/
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Text(
            message ?? 'Nothing Here',
            style: context.titleMedium?.copyWith(
              color: context.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollableEmptyView extends StatelessWidget {
  const ScrollableEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return const CommonEmptyView();
      },
    );
  }
}
