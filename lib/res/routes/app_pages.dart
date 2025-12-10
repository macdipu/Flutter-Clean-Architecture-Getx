import 'package:get/get.dart';
import 'package:flutter_clean_architecture_getx/res/routes/app_routes.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/presentation/pages.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final List<GetPage> routes = [
    ...AuthPages.routes,
  ];
}
