import 'package:com.onkur.customer/features/authentication/presentation/login/controller/login_screen_controller.dart';
import 'package:get/get.dart';
import 'package:com.onkur.customer/features/authentication/domain/repository/auth_repository.dart';
import 'package:com.onkur.customer/features/authentication/data/repo_impl/auth_cache_impl.dart';
import 'package:com.onkur.customer/features/authentication/data/repo_impl/auth_http_impl.dart';
import 'package:com.onkur.customer/core/data/http/urls/api_urls.dart';
import 'package:com.onkur.customer/core/data/http/client/api_client.dart';
import 'package:com.onkur.customer/core/data/cache/client/preference_cache.dart';
import 'package:com.onkur.customer/features/authentication/presentation/reset_pin/controller/reset_pin_controller.dart';
import '../../domain/use_case/do_login_use_case.dart';
import '../../domain/use_case/app_local.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {

    // Put AuthHttpImpl
    Get.lazyPut<AuthHttpImpl>(() => AuthHttpImpl(Get.find<ApiClient>(), Get.find<ApiUrl>()), fenix: true);

    // Put AuthRepository as AuthCacheImpl
    Get.lazyPut<AuthRepository>(() => AuthCacheImpl(Get.find<PreferenceCache>(), Get.find<AuthHttpImpl>()), fenix: true);

    // Put DoLoginUseCase if need cache then use AuthCacheImpl else direct use AuthHttpImpl
    Get.lazyPut<DoLoginUseCase>(() => DoLoginUseCase(Get.find<AuthRepository>()), fenix: true);

    // Put ToggleLocale use case
    Get.lazyPut<ToggleLocale>(() => ToggleLocale(Get.find<AuthRepository>()), fenix: true);

    // Put LoginScreenController
    Get.lazyPut<LoginScreenController>(() => LoginScreenController(), fenix: true);

    Get.lazyPut<ForgotPinController>(() => ForgotPinController(), fenix: true);
  }
}
