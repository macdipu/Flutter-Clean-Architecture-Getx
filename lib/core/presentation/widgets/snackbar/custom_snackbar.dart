import 'package:flutter/material.dart';
import 'package:customer/core/presentation/theme/color_schemes.dart';
import 'package:customer/res/routes/global_navigator.dart';
import 'package:get/get.dart';

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

class CustomSnackbar {
  /// Resolves the current brightness from the root context, defaulting to
  /// light when the app hasn't mounted yet (e.g. a very early background call).
  static bool get _isDark =>
      rootContext != null && Theme.of(rootContext!).brightness == Brightness.dark;

  static Color _pick(AdaptiveColor c) => _isDark ? c.dark : c.light;

  static void show({
    required String title,
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final (backgroundColor, textColor, icon) = switch (type) {
      SnackbarType.success => (_pick(AppColors.success), _pick(AppColors.onSuccess), Icons.check_circle_outline),
      SnackbarType.error => (_pick(AppColors.error), _pick(AppColors.onError), Icons.error_outline),
      SnackbarType.warning => (_pick(AppColors.warning), _pick(AppColors.onWarning), Icons.warning_amber_outlined),
      SnackbarType.info => (_pick(AppColors.info), _pick(AppColors.onInfo), Icons.info_outline),
    };

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: textColor,
      icon: Icon(icon, color: textColor),
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 300),
      overlayBlur: 0.5,
      overlayColor: _pick(AppColors.scrim).withValues(alpha: 0.1),
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED) {
          // Snackbar closed
        }
      },
    );
  }

  static void success(String message, {String title = 'Success'}) {
    show(
      title: title,
      message: message,
      type: SnackbarType.success,
    );
  }

  static void error(String message, {String title = 'Error'}) {
    show(
      title: title,
      message: message,
      type: SnackbarType.error,
    );
  }

  static void warning(String message, {String title = 'Warning'}) {
    show(
      title: title,
      message: message,
      type: SnackbarType.warning,
    );
  }

  static void info(String message, {String title = 'Info'}) {
    show(
      title: title,
      message: message,
      type: SnackbarType.info,
    );
  }

  static void showGlobalToast({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    String? status,
  }) {
    final context = rootContext;
    if (context == null) {
      return;
    }

    final backgroundColor = _toastBackgroundColor(status);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  static Color? _toastBackgroundColor(String? status) {
    switch (status) {
      case 'success':
        return _pick(AppColors.success);
      case 'error':
        return _pick(AppColors.error);
      case 'warning':
        return _pick(AppColors.warning);
      case 'info':
        return _pick(AppColors.info);
      default:
        return null;
    }
  }
}
