import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/authentication/presentation/login/screens/login_screen.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? getContext() {
    return navigatorKey.currentContext;
  }

  static Future<dynamic> navigateTo(String routeName, {dynamic arguments}) async {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateReplaced(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateToHome() async {
    Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  static dynamic goBack([dynamic popValue]) {
    return navigatorKey.currentState!.pop(popValue);
  }

  static dynamic popUntil(String routeName) {
    return navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  static Future<dynamic> navigateRemoveUntil(String routeName, {dynamic arguments}) async {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false, arguments: arguments);
  }

  static void navigateToLoginAndClearStack(Widget widget) {
    navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => widget), (Route<dynamic> route) => false);
  }

  static Future<void> logoutAndNavigateToLoginScreen() async {
    Get.offAll(() => LoginScreen());
  }
}
