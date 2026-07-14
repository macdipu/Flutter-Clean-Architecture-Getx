import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:customer/res/routes/global_navigator.dart';

/// Shows a highly customizable bottom sheet with premium features like backdrop blur.
///
/// This helper uses the [rootNavigatorKey] to display the sheet 
/// without needing a local [BuildContext].
Future<T?> showAppSheet<T>({
  required Widget child,
  bool hasBlur = true,
  bool enableDrag = true,
  bool isScrollControlled = true,
  bool useSafeArea = true,
}) {
  final context = rootContext;
  if (context == null) return Future.value(null);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.5),
    elevation: 0,
    useSafeArea: useSafeArea,
    enableDrag: enableDrag,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: hasBlur ? 3 : 0,
          sigmaY: hasBlur ? 3 : 0,
        ),
        child: SizedBox(
          child: child,
        ),
      ),
    ),
  );
}
