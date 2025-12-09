import 'package:flutter/material.dart';

import '../../../../res/resources.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.transparent,
        child: const CircularProgressIndicator(
            // valueColor: AlwaysStoppedAnimation<Color>(
            //   ColorConstants.primaryColor,
            // ),
            ),
      ),
    );
  }
}

class LoadingViewTransparent extends StatelessWidget {
  final double? height;
  final double? width;
  const LoadingViewTransparent({super.key, this.height, this.width});
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1,
      child: Container(
        color: const Color(0x80000000),
        height: height ?? MediaQuery.of(context).size.height,
        width: width ?? MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(backgroundColor: const Color(0xfff8f8f8), valueColor: AlwaysStoppedAnimation<Color>(Resources.color.primaryColor)),
        ),
      ),
    );
  }
}
