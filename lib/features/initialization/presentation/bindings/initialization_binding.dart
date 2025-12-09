import 'package:get/get.dart';
import 'package:clean_architecture_getx/features/initialization/data/repo_impl/initialization_repository_impl.dart';
import 'package:clean_architecture_getx/features/initialization/domain/repository/initialization_repository.dart';
import 'package:clean_architecture_getx/features/initialization/domain/use_case/initialization_use_case.dart';
import 'package:clean_architecture_getx/core/data/http/client/api_client.dart';
import 'package:clean_architecture_getx/core/data/cache/client/preference_cache.dart';

class InitializationBinding extends Bindings {
  @override
  void dependencies() {
    // Put WelcomeRepository
    Get.lazyPut<InitializationRepository>(() => InitializationRepositoryImpl(Get.find<ApiClient>(), Get.find<PreferenceCache>()), fenix: true);

    // Put InitializationUseCase
    Get.lazyPut<InitializationUseCase>(() => InitializationUseCase(Get.find<InitializationRepository>()), fenix: true);

  }
}
