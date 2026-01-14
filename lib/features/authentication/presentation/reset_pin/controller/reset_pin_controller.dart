import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter_clean_architecture_getx/core/utils/state_status.dart';


class ForgotPinController extends GetxController {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final status = Rx<StateStatus>(StateStatus.initial);

  Future<void> sootOtp() async {
    status.value = StateStatus.loading;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    status.value = StateStatus.success;
  }
}
