import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/data/cache/client/preference_cache.dart';
import '../../core/data/cache/preference/shared_preference_constants.dart';

class VersionService {
  static Future<String?> getVersion() async {
    final PreferenceCache cache = Get.find();
    if (await cache.has(SharedPreferenceConstant.version)) {
      var version = await cache.get(SharedPreferenceConstant.version);
      debugPrint("$version");
      return version;
    } else {
      final info = await PackageInfo.fromPlatform();
      cache.put(SharedPreferenceConstant.version, info.version, const Duration(hours: 24));
      return info.version;
    }
  }

  static Future<String?> getBuildNumber() async {
    final info = await PackageInfo.fromPlatform();
    return info.buildNumber;
  }

  static Future<String?> getAppName() async {
    final info = await PackageInfo.fromPlatform();
    return info.appName;
  }

  static Future<String?> getPackageName() async {
    final info = await PackageInfo.fromPlatform();
    return info.packageName;
  }

  static Future<String?> getBuildSignature() async {
    final info = await PackageInfo.fromPlatform();
    return info.buildSignature;
  }

  static Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  static Future<void> clearVersionCache() async {
    final PreferenceCache cache = Get.find();
    await cache.remove(SharedPreferenceConstant.version);
  }
}
