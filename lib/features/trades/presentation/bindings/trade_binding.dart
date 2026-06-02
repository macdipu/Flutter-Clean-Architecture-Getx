import 'package:get/get.dart';
import 'package:customer/features/trades/data/repo_impl/trade_cache_impl.dart';
import 'package:customer/features/trades/data/repo_impl/trade_http_impl.dart';
import 'package:customer/features/trades/domain/repo/trade_repository.dart';
import 'package:customer/features/trades/domain/usecase/trades_use_case.dart';
import 'package:customer/features/trades/presentation/controller/trades_screen_controller.dart';
import 'package:customer/core/data/http/client/api_client.dart';
import 'package:customer/core/data/http/urls/api_urls.dart';
import 'package:customer/core/data/cache/client/preference_cache.dart';

class TradeBinding extends Bindings {
  @override
  void dependencies() {
    // Put TradeHttpImpl
    Get.lazyPut<TradeHttpImp>(() => TradeHttpImp(Get.find<ApiClient>(), Get.find<ApiUrl>()), fenix: true);

    // Put TradeRepository as TradeCacheImpl
    Get.lazyPut<TradeRepository>(() => TradeCacheImpl(Get.find<PreferenceCache>(), Get.find<TradeHttpImp>()), fenix: true);

    // Put TradeUseCase
    Get.lazyPut<TradeUseCase>(() => TradeUseCase(Get.find<TradeRepository>()), fenix: true);

    // Put TradesScreenController
    Get.lazyPut<TradesScreenController>(() => TradesScreenController(), fenix: true);
  }
}
