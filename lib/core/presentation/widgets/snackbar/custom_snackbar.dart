import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = const Color(0xFF4CAF50);
        icon = Icons.check_circle_outline;
        break;
      case SnackbarType.error:
        backgroundColor = const Color(0xFFE53935);
        icon = Icons.error_outline;
        break;
      case SnackbarType.warning:
        backgroundColor = const Color(0xFFFF9800);
        icon = Icons.warning_amber_outlined;
        break;
      case SnackbarType.info:
        backgroundColor = const Color(0xFF2196F3);
        icon = Icons.info_outline;
        break;
    }

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
      overlayColor: Colors.black.withValues(alpha: 0.1),
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
}

