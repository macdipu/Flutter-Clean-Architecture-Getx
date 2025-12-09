import 'package:get/get.dart';

import 'splash/screen/splash_screen.dart';
import '../../../res/routes/app_routes.dart';

class WelcomePages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
  ];
}
