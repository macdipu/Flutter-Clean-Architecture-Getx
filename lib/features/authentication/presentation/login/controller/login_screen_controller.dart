import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/core/domain/models/password.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/core/presentation/controllers/locale_controller.dart';
import 'package:customer/features/authentication/domain/model/auth_login_req.dart';

import '../../../../../core/presentation/widgets/snackbar/custom_snackbar.dart';
import '../../../domain/use_case/do_login_use_case.dart';
import '../../../../../core/domain/models/phone_number.dart';

class LoginScreenController extends BaseController {
  final DoLoginUseCase loginUseCase = Get.find<DoLoginUseCase>();
  final LocaleController _localeController = Get.find<LocaleController>();

  final phoneNumberController = TextEditingController();
  final pinController = TextEditingController();

  final RxBool obscureText = true.obs;
  final Rxn<PhoneNumber> phoneNumber = Rxn<PhoneNumber>();

  String get currentLangCode => _localeController.currentLangCode.value;

  List<Function> get devAutoFill {
    return [
      () {
        phoneNumberController.text = '01521583534';
        pinController.text = '123458';
      }
    ];
  }

  void toggleLocale() => _localeController.toggleLocale();

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  Future<bool> login() async {
    var validity = await _checkingValidations();
    if (!validity) return false;

    doAction<bool>(
      action: () async => await loginUseCase(
        AuthLoginReq(
          phoneNumber: PhoneNumber(phoneNumberController.text),
          password: Password(pinController.text),
        ),
      ),
      onSuccess: (result) {
        if (!result) {
          CustomSnackbar.error('Login failed');
          return false;
        }
        return true;
      },
    );

    return true;
  }

  Future<bool> _checkingValidations() async {
    if (phoneNumberController.text.isEmpty) {
      CustomSnackbar.error('Phone number cannot be empty');
      return false;
    }

    try {
      phoneNumber.value = PhoneNumber(phoneNumberController.text);
    } catch (e) {
      CustomSnackbar.error(e.toString());
      return false;
    }

    if (pinController.text.isEmpty) {
      CustomSnackbar.error('Password cannot be empty');
      return false;
    }

    return true;
  }
}
