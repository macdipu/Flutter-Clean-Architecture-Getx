import 'package:clean_architecture_getx/core/data/http/urls/api_urls.dart';
import 'package:get/get.dart';

import '../../cache/client/preference_cache.dart';
import 'api_client.dart';

abstract class BaseHttpRepository {
  final ApiClient client = Get.find();
  final PreferenceCache preferenceCache = Get.find();

  ApiUrl get urls => client.url;
}
