import 'package:get/get.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:customer/features/authentication/presentation/pages.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final List<GetPage> routes = [
    ...AuthPages.routes,
  ];
}
