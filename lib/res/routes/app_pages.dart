import 'package:clean_architecture_getx/res/routes/app_routes.dart';
import 'package:clean_architecture_getx/features/welcome/presentation/pages.dart';
import 'package:clean_architecture_getx/features/authentication/presentation/pages.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    ...WelcomePages.routes,
    ...AuthPages.routes,
  ];
}
