import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../../domain/use_case/initialization_use_case.dart';
import '../../../trades/presentation/screens/trades_screen.dart';
import '../../../authentication/presentation/login/screens/login_screen.dart';

class AppInitController extends GetxController {
  final InitializationUseCase useCase = Get.find<InitializationUseCase>();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Perform any global initialization here
    bool login = await useCase.isUserLoggedIn();
    if (login) {
      Get.offAll(() => TradesScreen());
    } else {
      Get.offAll(() => LoginScreen());
    }
    FlutterNativeSplash.remove();
  }
}
