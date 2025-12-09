import 'package:get/get.dart';

import '../../http/client/api_client.dart';
import 'preference_cache.dart';

abstract class BaseCacheRepository {
  final ApiClient client = Get.find();
  final PreferenceCache preferenceCache = Get.find();

  BaseCacheRepository();
}
