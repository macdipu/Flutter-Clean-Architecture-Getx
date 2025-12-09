import 'package:clean_architecture_getx/features/authentication/presentation/login/screens/login_screen.dart';
import 'package:get/get.dart';

import '../../../trades/presentation/screens/trades_screen.dart';
import '../../domain/use_case/welcome_use_case.dart';

class SplashScreenScreenController extends GetxController {
  final WelcomeUseCase useCase = Get.find<WelcomeUseCase>();

  SplashScreenScreenController() {
    initApp();
  }

  Future<void> initApp() async {
    await Future.delayed(const Duration(seconds: 2));
    bool login = await useCase.isUserLoggedIn();

    if (login) {
      Get.offAll(() => TradesScreen());
    } else {
      Get.offAll(() => LoginScreen());
    }
  }
}
