import 'dart:async';

import 'package:flutter/material.dart';
import 'package:customer/core/presentation/theme/theme_extensions.dart';
import 'package:customer/core/presentation/widgets/buttons/common_button.dart';
import 'package:get/get.dart';

class OtpResendButton extends StatelessWidget {
  final Future<void> Function() onResend;
  final int duration;
  final String resendText;
  final String loadingText;
  final OtpResendUiType uiType;
  final String controllerTag;

  const OtpResendButton({
    super.key,
    required this.onResend,
    required this.controllerTag,
    this.duration = 40,
    this.resendText = 'Resend Code',
    this.loadingText = 'Sending...',
    this.uiType = OtpResendUiType.inline,
  });

  static void syncTimer(String? tag, int seconds) {
    if (tag == null) return;

    Get.find<OtpTimerController>(
      tag: tag,
    ).syncWithServer(seconds);
  }

  OtpTimerController _controller() {
    final controller = Get.put(
      OtpTimerController(),
      tag: controllerTag,
    );

    if (controller.remainingSeconds.value == 0) {
      controller.syncWithServer(duration);
    }

    return controller;
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller();

    return Obx(() {
      final onPressed = controller.canResend
          ? () async {
        controller.setLoading(true);

        try {
          await onResend();
          controller.syncWithServer(duration);
        } finally {
          controller.setLoading(false);
        }
      }
          : null;

      final label = controller.isLoading.value
          ? loadingText
          : controller.canResend
          ? resendText
          : '$resendText (${controller.remainingSeconds.value}s)';

      switch (uiType) {
      /// Minimal inline resend view
        case OtpResendUiType.inline:
          return _InlineOtpResendView(
            controller: controller,
            duration: duration,
            resendText: resendText,
            onPressed: onPressed,
          );

      /// Elevated button style
        case OtpResendUiType.primaryButton:
          return CommonButton.elevated(
            title: label,
            onTap: onPressed == null ? null : () => onPressed(),
            isLoading: controller.isLoading.value,
          );

      /// Outlined button style
        case OtpResendUiType.outlinedButton:
          return CommonButton.outlined(
            title: label,
            onTap: onPressed == null ? null : () => onPressed(),
            isLoading: controller.isLoading.value,
          );

      /// Compact chip UI
        case OtpResendUiType.chip:
          return _ChipOtpResendView(
            controller: controller,
            duration: duration,
            resendText: resendText,
            loadingText: loadingText,
            onPressed: onPressed,
          );

      /// Rich card UI
        case OtpResendUiType.card:
          return _CardOtpResendView(
            controller: controller,
            duration: duration,
            resendText: resendText,
            loadingText: loadingText,
            onPressed: onPressed,
          );
      }
    });
  }
}

class _InlineOtpResendView extends StatelessWidget {
  final OtpTimerController controller;
  final int duration;
  final String resendText;
  final VoidCallback? onPressed;

  const _InlineOtpResendView({
    required this.controller,
    required this.duration,
    required this.resendText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.canResend) {
      return TextButton(
        onPressed: onPressed,
        child: Text(
          resendText,
          style: TextStyle(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _OtpProgressIndicator(
          progress: controller.remainingSeconds.value / duration,
          color: context.primary,
        ),
        const SizedBox(width: 12),
        Text(
          'Resend in ${_formatSeconds(controller.remainingSeconds.value)}',
          style: TextStyle(
            color: context.onSuccessContainer,
          ),
        ),
      ],
    );
  }

  String _formatSeconds(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final rem = (seconds % 60).toString().padLeft(2, '0');

    return '$minutes:$rem';
  }
}

class _ChipOtpResendView extends StatelessWidget {
  final OtpTimerController controller;
  final int duration;
  final String resendText;
  final String loadingText;
  final VoidCallback? onPressed;

  const _ChipOtpResendView({
    required this.controller,
    required this.duration,
    required this.resendText,
    required this.loadingText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final text = controller.isLoading.value
        ? loadingText
        : controller.canResend
        ? resendText
        : 'Resend in ${controller.remainingSeconds.value}s';

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: controller.canResend
              ? context.primary.withOpacity(0.12)
              : context.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            controller.isLoading.value
                ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.primary,
              ),
            )
                : _OtpProgressIndicator(
              size: 18,
              strokeWidth: 2,
              progress: controller.canResend
                  ? 1
                  : controller.remainingSeconds.value / duration,
              color: context.primary,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: controller.canResend
                    ? context.primary
                    : context.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardOtpResendView extends StatelessWidget {
  final OtpTimerController controller;
  final int duration;
  final String resendText;
  final String loadingText;
  final VoidCallback? onPressed;

  const _CardOtpResendView({
    required this.controller,
    required this.duration,
    required this.resendText,
    required this.loadingText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 320,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.outline.withOpacity(0.15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: controller.canResend
                      ? 1
                      : controller.remainingSeconds.value / duration,
                  strokeWidth: 3,
                  color: context.primary,
                  backgroundColor:
                  context.primary.withOpacity(0.12),
                ),
                Icon(
                  Icons.sms_outlined,
                  size: 24,
                  color: context.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            controller.canResend
                ? 'Didn’t receive the code?'
                : 'You can request a new code in ${controller.remainingSeconds.value}s',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          TextButton(
            onPressed: onPressed,
            child: controller.isLoading.value
                ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.primary,
              ),
            )
                : Text(
              resendText,
              style: TextStyle(
                color: controller.canResend
                    ? context.primary
                    : context.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpProgressIndicator extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color color;

  const _OtpProgressIndicator({
    required this.progress,
    required this.color,
    this.size = 28,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        strokeWidth: strokeWidth,
        color: color,
        backgroundColor: color.withOpacity(0.12),
      ),
    );
  }
}

class OtpTimerController extends GetxController {
  Timer? _timer;

  final remainingSeconds = 0.obs;
  final isLoading = false.obs;

  bool get canResend =>
      remainingSeconds.value <= 0 && !isLoading.value;

  void syncWithServer(int seconds) {
    if (seconds <= 0) {
      stop();
      return;
    }

    /// Prevent overriding active larger timer
    if (_timer != null &&
        remainingSeconds.value > seconds) {
      return;
    }

    _timer?.cancel();

    remainingSeconds.value = seconds;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (remainingSeconds.value <= 0) {
          stop();
        } else {
          remainingSeconds.value--;
        }
      },
    );
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

enum OtpResendUiType {
  /// Inline text with timer
  inline,

  /// Elevated CTA button
  primaryButton,

  /// Outlined button
  outlinedButton,

  /// Rounded compact chip
  chip,

  /// Rich informational card
  card,
}

// When OTP screen opens → automatically start timer using retryAfter
// When resend succeeds → restart/sync timer using the new retryAfter from server
// When resend fails → stop loading and keep button enabled
//use useTimer hook from use_timer.dart
