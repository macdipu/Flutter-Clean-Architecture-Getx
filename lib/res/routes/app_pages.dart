
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../app/shell/app_shell.dart';
import '../../app/shell/app_shell_binding.dart';
import '../../features/authentication/presentation/pages.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final List<GetPage> routes = [
    ...AuthPages.routes,
    GetPage(
      name: AppRoutes.appShell,
      page: () => const AppShell(),
      bindings: [
        AppShellBinding(),

      ],
    ),
  ];
}
