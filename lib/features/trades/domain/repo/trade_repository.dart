import 'package:flutter_clean_architecture_getx/core/domain/usecase/usecase.dart';

import '../entity/trade_item.dart';

abstract class TradeRepository {
  ResultFuture<TradeItemList> getTradeList();
}
