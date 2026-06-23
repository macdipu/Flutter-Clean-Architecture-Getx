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
    assert(() {
      phoneNumberController.text = '01521583534';
      pinController.text = '123458';
      return true;
    }());
    return [];
  }

  void toggleLocale() => _localeController.toggleLocale();

  void toggleObscureText() => obscureText.value = !obscureText.value;

  Future<bool> login() async {
    if (!await _checkingValidations()) return false;

    bool succeeded = false;
    await doAction<bool>(
      action: () => loginUseCase(
        AuthLoginReq(
          phoneNumber: PhoneNumber(phoneNumberController.text),
          password: Password(pinController.text),
        ),
      ),
      onSuccess: (_) => succeeded = true,
    );
    return succeeded;
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

  @override
  void onClose() {
    phoneNumberController.dispose();
    pinController.dispose();
    super.onClose();
  }
}
