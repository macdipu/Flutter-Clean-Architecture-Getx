import 'package:get/get.dart';
import 'app_shell_controller.dart';

class AppShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppShellController>(() => AppShellController());
  }
}
