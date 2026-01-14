import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/images/round_image.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/text_field/custom_text_field.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_clean_architecture_getx/res/routes/app_routes.dart';
import 'package:flutter_clean_architecture_getx/res/strings/string_enum.dart';

import '../../../../../res/resources.dart';
import '../controller/login_screen_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginScreenController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            _bottomImage(),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 58),
                  _switchLocaleButton(),
                  const SizedBox(height: 40),
                  _branding(),
                  const SizedBox(height: 40),
                  _phoneNumber(),
                  const SizedBox(height: 16),
                  _passwordInput(),
                  const SizedBox(height: 16),
                  _pinReset(),
                  const SizedBox(height: 16),
                  _submitButton(),
                  const SizedBox(height: 8),
                  // _createAccountLink(),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _switchLocaleButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Obx(() {
        final code = _controller.currentLangCode.value.isEmpty
            ? Get.locale?.languageCode ?? Get.deviceLocale?.languageCode ?? 'en'
            : _controller.currentLangCode.value;

        final label = code == 'bn' ? 'বাংলা' : 'English';

        return TextButton.icon(
          onPressed: _controller.toggleLocale,
          icon: Icon(
            Icons.language,
            size: 14,
            color: context.theme.primaryColor,
          ),
          label: Text(
            label,
            style: TextStyle(fontSize: 14, color: context.theme.primaryColor),
          ),
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 36),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
        );
      }),
    );
  }

  Widget _branding() {
    return CRoundImage(
      height: 72,
      imagePath: Resources.drawable.dashboardImage,
    );
  }

  Widget _phoneNumber() {
    return CustomTextField(
      controller: _controller.phoneNumberController,
      label: TextEnum.phoneNumber.tr,
      prefixText: '+88',
      prefixStyle: const TextStyle(fontSize: 16),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _passwordInput() {
    return Obx(() {
      return CustomTextField(
        controller: _controller.pinController,
        label: TextEnum.pin.tr,
        obscureText: _controller.obscureText.value,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        suffixIcon: IconButton(
          icon: Icon(
            _controller.obscureText.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: _controller.toggleObscureText,
        ),
      );
    });
  }

  Widget _pinReset() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          // Get.toNamed(AppRoutes.forgotPin);
        },
        child: Text(
          TextEnum.forgotPin.tr,
          style: TextStyle(
            color: context.theme.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _bottomImage() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CRoundImage(
        imagePath: Resources.drawable.loginUpperImage,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _submitButton() {
    return CommonButton(
      title: TextEnum.next.tr,
      height: 48,
      width: MediaQuery.of(context).size.width - 32,
      bgColor: context.theme.primaryColor,
      titleColor: Colors.white,
      onTap: () async {
        final success = await _controller.login();
        if (success) {
          // Get.offAllNamed(AppRoutes.appShell);
        }
      },
    );
  }

  Widget _createAccountLink() {
    return CommonButton(
      title: TextEnum.createAccount.tr,
      textStyle: TextStyle(fontSize: 16, color: context.theme.primaryColor) ,
      height: 48,
      width: MediaQuery.of(context).size.width - 32,
      bgColor: Colors.transparent,
      titleColor: Colors.white,
      onTap: () async {
       //todo
      },
    );
  }
}
