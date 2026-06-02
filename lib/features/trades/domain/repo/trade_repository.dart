import 'package:customer/core/domain/usecase/usecase.dart';

import '../entity/trade_item.dart';

abstract class TradeRepository {
  ResultFuture<TradeItemList> getTradeList();
}
