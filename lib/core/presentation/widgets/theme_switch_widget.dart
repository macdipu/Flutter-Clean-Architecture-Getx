import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

/// A widgets that allows users to switch between light, dark, and system themes.
class ThemeSwitchWidget extends StatelessWidget {
  const ThemeSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      final IconData icon;
      final String tooltip;

      switch (themeController.themeMode) {
        case ThemeMode.light:
          icon = Icons.light_mode;
          tooltip = 'Switch to Dark Theme';
          break;
        case ThemeMode.dark:
          icon = Icons.dark_mode;
          tooltip = 'Switch to System Theme';
          break;
        case ThemeMode.system:
          icon = Icons.brightness_auto;
          tooltip = 'Switch to Light Theme';
          break;
      }

      return IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        onPressed: () => _cycleTheme(themeController),
      );
    });
  }

  void _cycleTheme(ThemeController controller) {
    switch (controller.themeMode) {
      case ThemeMode.light:
        controller.setDarkTheme();
        break;
      case ThemeMode.dark:
        controller.setSystemTheme();
        break;
      case ThemeMode.system:
        controller.setLightTheme();
        break;
    }
  }
}
