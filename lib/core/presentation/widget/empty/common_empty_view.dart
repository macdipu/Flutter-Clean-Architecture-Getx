import 'package:flutter/material.dart';

import '../../../../res/resources.dart';

class CommonEmptyView extends StatelessWidget {
  const CommonEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /*Container(
          height: 120,
          width: 140,
          margin: const EdgeInsets.only(bottom: 24, top: 100),
          child: Image.asset(context.resources.drawable.noCampaigns),
        ),*/
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Text(
            'Nothing Here',
            style: Resources.style
                .w500s14(Resources.color.white.withOpacity(0.7)),
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
