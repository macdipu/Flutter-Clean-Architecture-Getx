import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpResendButton extends StatelessWidget {
  final Future<void> Function() onResend;
  final int duration;
  final String resendText;
  final String loadingText;
  final OtpButtonType buttonType;
  final String? controllerTag;

  const OtpResendButton({
    super.key,
    required this.onResend,
    this.duration = 60,
    this.resendText = 'Resend Code',
    this.loadingText = 'Sending...',
    this.buttonType = OtpButtonType.text,
    this.controllerTag,
  });

  OtpTimerController _controller() {
    return Get.put(
      OtpTimerController(),
      tag: controllerTag,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller();

    return Obx(() {
      final onPressed = controller.canResend
          ? () async {
        controller.setLoading(true);
        await onResend();
        controller.setLoading(false);
        controller.syncWithServer(duration);
      }
          : null;

      final child = controller.isLoading.value
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Sending...'),
          SizedBox(width: 8),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      )
          : Text(
        controller.canResend
            ? resendText
            : '$resendText (${controller.remainingSeconds.value}s)',
      );

      switch (buttonType) {
        case OtpButtonType.elevated:
          return ElevatedButton(onPressed: onPressed, child: child);
        case OtpButtonType.outlined:
          return OutlinedButton(onPressed: onPressed, child: child);
        case OtpButtonType.text:
          return TextButton(onPressed: onPressed, child: child);
      }
    });
  }
}

class OtpTimerController extends GetxController {
  Timer? _timer;

  final remainingSeconds = 0.obs;
  final isLoading = false.obs;

  bool get canResend => remainingSeconds.value <= 0 && !isLoading.value;

  void syncWithServer(int seconds) {
    if (seconds <= 0) {
      stop();
      return;
    }

    if (_timer != null && remainingSeconds.value <= seconds) {
      return;
    }

    _timer?.cancel();
    remainingSeconds.value = seconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds.value <= 0) {
        stop();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    remainingSeconds.value = 0;
  }

  @override
  void onClose() {
    stop();
    super.onClose();
  }
}

enum OtpButtonType { text, elevated, outlined }
