import 'package:clean_architecture_getx/features/authentication/presentation/login/controller/login_screen_controller.dart';
import 'package:get/get.dart';
import 'package:clean_architecture_getx/features/authentication/domain/repository/auth_repository.dart';
import 'package:clean_architecture_getx/features/authentication/data/repo_impl/auth_cache_impl.dart';
import 'package:clean_architecture_getx/features/authentication/data/repo_impl/auth_http_impl.dart';
import 'package:clean_architecture_getx/core/data/http/urls/api_urls.dart';
import 'package:clean_architecture_getx/core/data/http/client/api_client.dart';
import 'package:clean_architecture_getx/core/data/cache/client/preference_cache.dart';

import '../../domain/use_case/do_login_use_case.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {

    // Put AuthHttpImpl
    Get.lazyPut<AuthHttpImpl>(() => AuthHttpImpl(Get.find<ApiClient>(), Get.find<ApiUrl>()), fenix: true);

    // Put AuthRepository as AuthCacheImpl
    Get.lazyPut<AuthRepository>(() => AuthCacheImpl(Get.find<PreferenceCache>(), Get.find<AuthHttpImpl>()), fenix: true);

    // Put DoLoginUseCase if need cache then use AuthCacheImpl else direct use AuthHttpImpl
    Get.lazyPut<DoLoginUseCase>(() => DoLoginUseCase(Get.find<AuthRepository>()), fenix: true);

    // Put LoginScreenController
    Get.lazyPut<LoginScreenController>(() => LoginScreenController(), fenix: true);
  }
}
