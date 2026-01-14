import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/gap/custom_space.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/appbar/common_appbar.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/buttons/common_button.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/text_field/custom_text_field.dart';
import 'package:flutter_clean_architecture_getx/core/utils/state_status.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/presentation/reset_pin/controller/reset_pin_controller.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/presentation/widgets/intro_header.dart';
import 'package:flutter_clean_architecture_getx/res/routes/app_routes.dart';

class ForgotPinScreen extends GetView<ForgotPinController> {
  ForgotPinScreen({super.key});
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
          horizontal:16,
        ),
        child:ListView(
          shrinkWrap: true,
          children: [
            customSpace(height: 18),
            SizedBox(height: 18,),
            IntroHeader(
              title: 'Reset PIN',
              introText: 'Please enter your registered Phone Number.',
            ),
            customSpace(height: 24),
            _phoneNumber(),
            customSpace(height: 16),
            _next_btn(),
          ],
        ),
      ),
    );
  }

  Widget _phoneNumber() {
    return CustomTextField(
      controller: controller.mobileController,
      label: 'Phone Number',
      prefixText: '+88',
      prefixStyle: const TextStyle(fontSize: 16),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }
        if (value.length != 11) {
          return 'Phone number must be 11 digits';
        }
        return null;
      },
    );
  }


  _next_btn() {
    return Obx(() {
      return CommonButton(
        key: const ValueKey("reset_password_button"),
        title: 'Next',
        loaderColor: Colors.white,
        bgColor: theme.primaryColor,
        titleColor: Colors.white,
        height: 48 ,
        isLoading: controller.status.value.isLoading,
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            await controller.sootOtp();
            Get.toNamed(AppRoutes.forgotPinOtpVerify);
          }
        },
      );
    });
  }
}
