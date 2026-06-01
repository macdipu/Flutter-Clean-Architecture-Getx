
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/theme/theme_extensions.dart';
import 'package:flutter_clean_architecture_getx/res/routes/global_navigator.dart';

void showToast(
  BuildContext context, {
  required String message,
  String? status = 'success',
  dynamic icon,
  Duration? duration,
  bool? autoDismiss,
}) {
  final toastStatus = status ?? 'info';
  final colorScheme = context.primary;
  final appColors = context.appColors;

  final (backgroundColor, foregroundColor, iconColor) = switch (toastStatus) {
    'error' => (
      colorScheme.errorContainer,
      colorScheme.onErrorContainer,
      colorScheme.error,
    ),
    'success' => (
      appColors.successContainer ?? appColors.success,
      appColors.onSuccessContainer ?? appColors.onSuccess,
      appColors.success,
    ),
    'warning' => (
      appColors.warningContainer ?? appColors.warning,
      appColors.onWarningContainer ?? appColors.onWarning,
      appColors.warning,
    ),
    'info' => (
      appColors.infoContainer ?? appColors.info,
      appColors.onInfoContainer ?? appColors.onInfo,
      appColors.info,
    ),
    _ => (
      context.theme.scaffoldBackgroundColor,
      colorScheme.onSurface,
      colorScheme.onSurfaceVariant,
    ),
  };

  return ToastBar(
    position: ToastPosition.top,
    autoDismiss: autoDismiss ?? true,
    toastDuration: duration ?? const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 150),
    animationCurve: Curves.easeIn,
    builder: (context) => ToastCard(
      color: backgroundColor,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.05),
      leading: AppIcon(
        icon: icon ??
            (toastStatus == 'success'
                ? IconsaxPlusBold.tick_circle
                : toastStatus == 'error'
                    ? IconsaxPlusBold.danger
                    : IconsaxPlusBold.info_circle),
        color: iconColor,
        size: 22.sp,
      ),
      title: Text(
        message,
        style: context.theme.textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          color: foregroundColor,
        ),
      ),
    ),
  ).show(context);
}

void showGlobalToast({
  required String message,
  String? status = 'success',
  dynamic icon,
  Duration? duration,
  bool? autoDismiss,
}) {
  final ctx = rootContext;
  if (ctx == null) return;

  showToast(
    ctx,
    message: message,
    status: status,
    icon: icon,
    duration: duration,
    autoDismiss: autoDismiss,
  );
}
