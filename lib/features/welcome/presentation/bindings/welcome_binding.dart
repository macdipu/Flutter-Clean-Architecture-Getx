import 'package:get/get.dart';
import 'package:clean_architecture_getx/features/welcome/data/repo_impl/welcome_repository_impl.dart';
import 'package:clean_architecture_getx/features/welcome/domain/repository/welcome_repository.dart';
import 'package:clean_architecture_getx/features/welcome/domain/use_case/welcome_use_case.dart';
import 'package:clean_architecture_getx/features/welcome/presentation/splash/splash_screen_screen_controller.dart';
import 'package:clean_architecture_getx/core/data/http/client/api_client.dart';
import 'package:clean_architecture_getx/core/data/cache/client/preference_cache.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    // Put WelcomeRepository
    Get.lazyPut<WelcomeRepository>(() => WelcomeRepositoryImpl(Get.find<ApiClient>(), Get.find<PreferenceCache>()), fenix: true);

    // Put WelcomeUseCase
    Get.lazyPut<WelcomeUseCase>(() => WelcomeUseCase(Get.find<WelcomeRepository>()), fenix: true);

    // Put SplashScreenScreenController
    Get.lazyPut<SplashScreenScreenController>(() => SplashScreenScreenController(), fenix: true);
  }
}
