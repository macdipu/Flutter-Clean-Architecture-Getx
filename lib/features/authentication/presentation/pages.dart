import 'package:get/get.dart';

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
  ];
}
