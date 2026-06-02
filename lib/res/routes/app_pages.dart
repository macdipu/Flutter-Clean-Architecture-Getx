import 'package:get/get.dart';
import 'package:com.onkur.customer/res/routes/app_routes.dart';
import 'package:com.onkur.customer/features/authentication/presentation/pages.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final List<GetPage> routes = [
    ...AuthPages.routes,
  ];
}
