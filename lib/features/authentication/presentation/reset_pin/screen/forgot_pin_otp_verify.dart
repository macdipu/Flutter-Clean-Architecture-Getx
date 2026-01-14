import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/gap/custom_space.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/appbar/common_appbar.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/buttons/common_button.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/buttons/otp_resend_timer.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/pin/common_pin_input.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/presentation/reset_pin/controller/reset_pin_controller.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/presentation/widgets/intro_header.dart';
import 'package:flutter_clean_architecture_getx/core/utils/state_status.dart';
import 'package:flutter_clean_architecture_getx/res/routes/app_routes.dart';

class ForgotPinOtpVerify extends GetView<ForgotPinController> {
  ForgotPinOtpVerify({super.key});
  final _formKey = GlobalKey<FormState>();
  final theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppbar(),
        body: _pageBody(),
      ),
    );
  }

  _pageBody() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            customSpace(height: 18),
            SizedBox(height: 18),
            IntroHeader(
              title: 'OTP Verification',
              introText:
                  'Please check, a verification code has been sent to this number +88 ${controller.mobileController.text}',
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: Get.back,
                    child: Text(
                      'Change Number',
                      style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    )),
              ],
            ),
            customSpace(height: 24),
            _otpInput(),
            customSpace(height: 16),
            _next_btn(),
          ],
        ),
      ),
    );
  }

  _otpInput() {
    return Column(
      children: [
        Obx(
          () => Skeletonizer(
            enabled: controller.status.value == StateStatus.loading,
            child: CommonPinInputField(
              controller: controller.otpController,
              onChanged: (value) {
                // controller.onOtpChange(value);
              },
            ),
          ),
        ),
        customSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _resendButton(),
          ],
        ),
      ],
    );
  }

  _resendButton() {
    return OtpResendButton(
      controllerTag: 'otp_veryfy',
      duration: 60,
      onResend: () async {
        //controller api call
      },
    );
  }

  _next_btn() {
    return CommonButton(
      key: const ValueKey("reset_pin_next_button"),
      title: 'Next',
      bgColor: Get.theme.primaryColor,
      titleColor: Colors.white,
      loaderColor: Colors.white,
      height: 48,
      onTap: () {
        Get.toNamed(AppRoutes.resetPin);

        if (_formKey.currentState!.validate()) {
          // Handle next button tap
        }
      },
    );
  }
}
