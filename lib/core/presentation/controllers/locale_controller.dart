import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../data/repositories/app_settings_repository_impl.dart';
import '../../domain/repositories/app_settings_repository.dart';

class LocaleController extends GetxController {
  final AppSettingsRepository _settingsRepository = AppSettingsRepositoryImpl();

  final RxString currentLangCode = 'bn'.obs;
  final RxBool isTogglingLocale = false.obs;

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
    if (isTogglingLocale.value) return;
    isTogglingLocale.value = true;
    try {
      // Get.updateLocale rebuilds synchronously; without a frame in between,
      // the loading and done states batch into one paint and the spinner never shows.
      await SchedulerBinding.instance.endOfFrame;

      final newCode = currentLangCode.value == 'bn' ? 'en' : 'bn';
      currentLangCode.value = newCode;
      await Get.updateLocale(Locale(newCode));

      unawaited(
        _settingsRepository.setLocale(newCode).catchError(
            (Object e) => debugPrint('Error persisting locale: $e')),
      );

      await SchedulerBinding.instance.endOfFrame;
    } catch (e) {
      debugPrint('Error toggling locale: $e');
    } finally {
      isTogglingLocale.value = false;
    }
  }
}
