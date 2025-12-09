import 'package:get/get.dart';

import '../../../core/presentation/widget/snackbar/custom_snackbar.dart';
import '../domain/entity/trade_item.dart';
import '../domain/usecase/trades_use_case.dart';

class TradesScreenController extends GetxController {
  final TradeUseCase _controller = Get.find<TradeUseCase>();

  final RxBool isLoading = false.obs;
  final RxList<TradeItem> trades = RxList();

  TradesScreenController() {
    getData();
  }

  Future<void> getData() async {
    if (isLoading.value) return;

    isLoading.value = true;

    final result = await _controller.doGetTradeList();
    result.fold(
      (failure) => CustomSnackbar.error(failure.message),
      (r) => trades.value = r.tradeItems ?? [],
    );

    isLoading.value = false;
  }
}
