import 'package:get/get.dart';
import 'package:customer/core/presentation/widgets/buttons/otp_resend_timer.dart';
import 'package:customer/features/authentication/presentation/reset_pin/screen/forgot_pin_otp_verify.dart';
import 'package:customer/features/authentication/presentation/reset_pin/screen/forgot_pin_screen.dart';
import 'package:customer/features/authentication/presentation/reset_pin/screen/reset_pin_screen.dart';
import 'package:customer/features/authentication/presentation/reset_pin/screen/reset_pin_success.dart';

import 'login/screens/login_screen.dart';
import 'bindings/login_binding.dart';
import '../../../res/routes/app_routes.dart';

class AuthPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPin,
      page: () => ForgotPinScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPinOtpVerify,
      page: () => ForgotPinOtpVerify(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPin,
      page: () => ResetPinScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPinSuccess,
      page: () => ResetPinSuccess(),
      binding: LoginBinding(),
    ),
  ];
}
