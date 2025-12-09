import 'package:dartz/dartz.dart';

import '../../../../core/data/cache/client/base_cache_repository.dart';
import '../../../../core/domain/domain_export.dart';
import '../../domain/entity/trade_item.dart';
import '../../domain/repo/trade_repository.dart';
import 'trade_http_impl.dart';

class TradeCacheImpl extends BaseCacheRepository implements TradeRepository {
  static const cacheKey = "project:trades";

  final TradeHttpImp _repo = TradeHttpImp();

  @override
  Future<Either<Failure, TradeItemList>> getTradeList() async {
    String? value = await preferenceCache.get(cacheKey);
    if (value == null) {
      return _getFromSourceAndSave();
    }

    return Right(TradeItemList.fromJson(value));
  }

  Future<Either<Failure, TradeItemList>> _getFromSourceAndSave() async {
    Either<Failure, TradeItemList> trades = await _repo.getTradeList();

    if (trades.isRight()) {
      TradeItemList? tradeList = trades.fold((l) => null, (r) => r);
      preferenceCache.put(cacheKey, tradeList!.toJson(), const Duration(days: 1));
    }

    return trades;
  }
}
