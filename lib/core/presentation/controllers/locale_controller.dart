import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/app_settings_repository_impl.dart';
import '../../domain/repositories/app_settings_repository.dart';

class LocaleController extends GetxController {
  final AppSettingsRepository _settingsRepository = AppSettingsRepositoryImpl();

  final RxString currentLangCode = 'bn'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final saved = await _settingsRepository.getLocale();
      final code = saved ?? 'en';
      currentLangCode.value = code;
      Get.updateLocale(Locale(code));
    } catch (e) {
      debugPrint('Error loading locale: $e');
    }
  }

  Future<void> toggleLocale() async {
    try {
      final newCode = currentLangCode.value == 'bn' ? 'en' : 'bn';
      await _settingsRepository.setLocale(newCode);
      currentLangCode.value = newCode;
      Get.updateLocale(Locale(newCode));
    } catch (e) {
      debugPrint('Error toggling locale: $e');
    }
  }
}