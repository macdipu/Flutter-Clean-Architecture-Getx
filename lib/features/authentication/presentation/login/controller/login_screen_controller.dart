import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/presentation/widgets/snackbar/custom_snackbar.dart';
import '../../../domain/use_case/do_login_use_case.dart';

class LoginScreenController extends GetxController {
  final DoLoginUseCase useCase = Get.find<DoLoginUseCase>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  List<Function> get devAutoFill {
    return [
      () {
        usernameController.text = 'admin';
        passwordController.text = 'admin';
      }
    ];
  }

  Future<bool> login() async {
    var validity = await _checkingValidations();
    if (!validity) return false;

    // TODO: Uncomment and Comment this
    await Future.delayed(const Duration(seconds: 3));
    // final result = await useCase.doLogin(AuthLoginReq(userName: usernameController.text, password: passwordController.text));

    // result.fold(
    //   (failure) {
    //     SnackBarUtils.showError(message: failure.message);
    //     return false;
    //   },
    //   (user) {
    //     if (!user) {
    //       SnackBarUtils.showError(message: 'Login failed');
    //       return false;
    //     }
    //   },
    // );
    //! ------------------------------------------------------------------------

    return true;
  }

  Future<bool> _checkingValidations() async {
    if (usernameController.text.isEmpty) {
      CustomSnackbar.error('Username cannot be empty');
      return false;
    }

    if (passwordController.text.isEmpty) {
      CustomSnackbar.error('Password cannot be empty');
      return false;
    }

    return true;
  }
}
