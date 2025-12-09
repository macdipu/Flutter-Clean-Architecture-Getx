import 'package:get/get.dart';

import '../../../welcome/presentation/splash/screen/splash_screen.dart';
import '../../../welcome/presentation/bindings/welcome_binding.dart';
import '../../../../res/routes/app_routes.dart';

class WelcomePages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: WelcomeBinding(),
    ),
  ];
}
