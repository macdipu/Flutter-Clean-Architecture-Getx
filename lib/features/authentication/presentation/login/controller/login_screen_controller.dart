import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_clean_architecture_getx/core/domain/models/password.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/controllers/base_controller.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/domain/model/auth_login_req.dart';

import '../../../../../core/presentation/widgets/snackbar/custom_snackbar.dart';
import '../../../domain/use_case/do_login_use_case.dart';
import '../../../domain/use_case/app_local.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/domain/repository/auth_repository.dart';
import '../../../../../core/domain/models/phone_number.dart';

class LoginScreenController extends BaseController {
  final DoLoginUseCase loginUseCase = Get.find<DoLoginUseCase>();
  final ToggleLocale toggleLocaleUseCase = Get.find<ToggleLocale>();
  final phoneNumberController = TextEditingController();
  final pinController = TextEditingController();

  final RxString currentLangCode = ''.obs;
  final RxBool obscureText = true.obs;
  final Rxn<PhoneNumber> phoneNumber = Rxn<PhoneNumber>();

  List<Function> get devAutoFill {
    return [
      () {
        phoneNumberController.text = '01521583534';
        pinController.text = '123458';
      }
    ];
  }

  @override
  void onInit() {
    super.onInit();
    _initLocale();
  }

  Future<void> _initLocale() async {
    try {
      final repo = Get.find<AuthRepository>();
      final saved = await repo.getSavedLocale();
      final code = saved?.languageCode ?? Get.locale?.languageCode ?? Get.deviceLocale?.languageCode ?? 'en';
      currentLangCode.value = code;
    } catch (_) {
      currentLangCode.value = Get.locale?.languageCode ?? Get.deviceLocale?.languageCode ?? 'en';
    }
  }

  Future<void> toggleLocale() async {
    final result = await toggleLocaleUseCase();
    result.fold(
      (failure) {
        CustomSnackbar.error(failure.message);
      },
      (_) {
        final code = Get.locale?.languageCode ?? Get.deviceLocale?.languageCode ?? 'en';
        currentLangCode.value = code;
      },
    );
  }

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  Future<bool> login() async {
    var validity = await _checkingValidations();
    if (!validity) return false;

    doAction<bool>(
        action:() async => await loginUseCase(AuthLoginReq(phoneNumber: PhoneNumber(phoneNumberController.text), password: Password(pinController.text))),
        onSuccess: (result){
          if (!result) {
            CustomSnackbar.error('Login failed');
            return false;
          }
          return true;
        }
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
