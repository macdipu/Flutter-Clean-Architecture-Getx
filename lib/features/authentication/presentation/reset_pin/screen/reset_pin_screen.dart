
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:customer/core/presentation/utils/state_status.dart';
import 'package:get/get.dart';
import 'package:customer/core/presentation/widgets/appbar/common_appbar.dart';
import 'package:customer/core/presentation/widgets/buttons/common_button.dart';
import 'package:customer/core/presentation/widgets/text_field/custom_text_field.dart';
import 'package:customer/features/authentication/presentation/reset_pin/controller/reset_pin_controller.dart';
import 'package:customer/features/authentication/presentation/widgets/intro_header.dart';
import 'package:customer/res/routes/app_routes.dart';

class ResetPinScreen extends GetView<ForgotPinController> {
  ResetPinScreen({super.key});
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
            IntroHeader(
              title: 'Reset PIN',
            ),
            _newPin(),
            _confirmPin(),
            _next_btn(),
          ],
        ),
      ),
    );
  }



  Widget _newPin() {
    return CustomTextField(
      controller: controller.mobileController,
      label: 'New PIN',
      prefixStyle: const TextStyle(fontSize: 16),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        return null;
      },
    );
  }


  Widget _confirmPin() {
    return CustomTextField(
      controller: controller.mobileController,
      label: 'confirm PIN',
      prefixStyle: const TextStyle(fontSize: 16),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        return null;
      },
    );
  }



  _next_btn() {
    return Obx(() {
      return CommonButton.elevated(
        key: const ValueKey("reset_password_button"),
        title: 'Reset PIN',
        isLoading: controller.status.value.isLoading,
        onTap: () async {
          Get.toNamed(AppRoutes.resetPinSuccess);
          if (_formKey.currentState!.validate()) {
            await controller.sootOtp();
          }
        },
      );
    });
  }
}