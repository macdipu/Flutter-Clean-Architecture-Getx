import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';
import 'loading_view.dart';

class OverLayLoadingView extends StatelessWidget {

  final Widget? mainChild;
  final bool? isLoading;

  const OverLayLoadingView({
    super.key,
    required this.mainChild,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mainChild!,
        isLoading! ?
        Opacity(
          opacity: 0.5,
          child: ModalBarrier(dismissible: false, color: context.scrim),
        ) : Container(),
         Center(
          child: isLoading! ? const LoadingView(): Container(),
        ),
      ],
    );
  }
}
