import 'package:get/get.dart';
import 'package:customer/core/data/cache/client/preference_cache.dart';
import 'package:customer/core/data/http/client/api_client.dart';
import 'package:customer/core/data/http/urls/api_urls.dart';
import 'package:customer/features/authentication/data/repo_impl/auth_cache_impl.dart';
import 'package:customer/features/authentication/data/repo_impl/auth_http_impl.dart';
import 'package:customer/features/authentication/domain/repository/auth_repository.dart';
import 'package:customer/features/authentication/presentation/login/controller/login_screen_controller.dart';
import 'package:customer/features/authentication/presentation/reset_pin/controller/reset_pin_controller.dart';
import '../../domain/use_case/do_login_use_case.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthHttpImpl>(
      () => AuthHttpImpl(Get.find<ApiClient>(), Get.find<ApiUrl>()),
      fenix: true,
    );

    Get.lazyPut<AuthRepository>(
      () => AuthCacheImpl(Get.find<PreferenceCache>(), Get.find<AuthHttpImpl>()),
      fenix: true,
    );

    Get.lazyPut<DoLoginUseCase>(
      () => DoLoginUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<LoginScreenController>(() => LoginScreenController(), fenix: true);

    Get.lazyPut<ForgotPinController>(() => ForgotPinController(), fenix: true);
  }
}
