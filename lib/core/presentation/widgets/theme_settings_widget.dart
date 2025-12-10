import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../theme/theme_extensions.dart';

/// Example widget demonstrating proper theme usage
/// This widget shows how to use theme colors and text styles
/// WITHOUT hard-coding any values
class ThemeSettingsWidget extends StatelessWidget {
  const ThemeSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      // ✅ CORRECT: Using theme's backgroundColor
      backgroundColor: context.backgroundColor,

      appBar: AppBar(
        // ✅ AppBar automatically uses theme configuration
        title: Text(
          'Theme Settings',
          // ✅ CORRECT: Using theme's text style
          style: context.titleLarge,
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Mode Selection Card
          Card(
            // ✅ Card automatically uses theme configuration
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme Mode',
                    // ✅ CORRECT: Using theme's headline style
                    style: context.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  Obx(() => Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        // ✅ Radio automatically uses theme colors
                        title: Text(
                          'Light Mode',
                          // ✅ CORRECT: Using theme's body text style
                          style: context.bodyLarge,
                        ),
                        value: ThemeMode.light,
                        groupValue: themeController.themeMode,
                        onChanged: (value) => themeController.changeThemeMode(value!),
                      ),

                      RadioListTile<ThemeMode>(
                        title: Text(
                          'Dark Mode',
                          style: context.bodyLarge,
                        ),
                        value: ThemeMode.dark,
                        groupValue: themeController.themeMode,
                        onChanged: (value) => themeController.changeThemeMode(value!),
                      ),

                      RadioListTile<ThemeMode>(
                        title: Text(
                          'System Default',
                          style: context.bodyLarge,
                        ),
                        subtitle: Text(
                          'Follow system theme',
                          // ✅ CORRECT: Using theme's body small text style
                          style: context.bodySmall?.copyWith(
                            color: context.onSurfaceVariant,
                          ),
                        ),
                        value: ThemeMode.system,
                        groupValue: themeController.themeMode,
                        onChanged: (value) => themeController.changeThemeMode(value!),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Color Preview Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme Colors Preview',
                    style: context.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  // Primary Color
                  _ColorTile(
                    title: 'Primary',
                    // ✅ CORRECT: Using theme's primary color
                    color: context.primaryColor,
                    onColor: context.onPrimary,
                  ),

                  // Secondary Color
                  _ColorTile(
                    title: 'Secondary',
                    // ✅ CORRECT: Using theme's secondary color
                    color: context.secondaryColor,
                    onColor: context.onSecondary,
                  ),

                  // Success Color
                  _ColorTile(
                    title: 'Success',
                    // ✅ CORRECT: Using theme's success color (custom extension)
                    color: context.successColor,
                    onColor: context.onSuccess,
                  ),

                  // Error Color
                  _ColorTile(
                    title: 'Error',
                    // ✅ CORRECT: Using theme's error color
                    color: context.errorColor,
                    onColor: context.onError,
                  ),

                  // Warning Color
                  _ColorTile(
                    title: 'Warning',
                    // ✅ CORRECT: Using theme's warning color (custom extension)
                    color: context.warningColor,
                    onColor: context.onWarning,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Typography Preview Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Typography Preview',
                    style: context.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  // ✅ All text styles come from theme
                  Text('Display Large', style: context.displayLarge),
                  Text('Headline Large', style: context.headlineLarge),
                  Text('Title Large', style: context.titleLarge),
                  Text('Body Large', style: context.bodyLarge),
                  Text('Label Large', style: context.labelLarge),
                  Text('Body Medium', style: context.bodyMedium),
                  Text('Body Small', style: context.bodySmall),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Button Examples Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Button Examples',
                    style: context.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  // ✅ Elevated Button uses theme configuration
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated Button'),
                  ),
                  const SizedBox(height: 8),

                  // ✅ Outlined Button uses theme configuration
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined Button'),
                  ),
                  const SizedBox(height: 8),

                  // ✅ Text Button uses theme configuration
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text Button'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ✅ FAB uses theme configuration
      floatingActionButton: FloatingActionButton(
        onPressed: () => themeController.toggleTheme(),
        child: Obx(() => Icon(
          themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        )),
      ),
    );
  }
}

/// Helper widget to display color tiles
class _ColorTile extends StatelessWidget {
  final String title;
  final Color color;
  final Color onColor;

  const _ColorTile({
    required this.title,
    required this.color,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: context.titleMedium?.copyWith(color: onColor),
        ),
      ),
    );
  }
}

