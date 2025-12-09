import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/data/cache/client/preference_cache.dart';
import '../../core/data/cache/preference/shared_preference_constants.dart';

getVersion() async {
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
