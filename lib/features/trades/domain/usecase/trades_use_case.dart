import 'package:dartz/dartz.dart';

import '../../../../core/domain/domain_export.dart';
import '../../data/repo_impl/trade_cache_impl.dart';
import '../entity/trade_item.dart';

class TradeUseCase {
  final TradeCacheImpl _repo = TradeCacheImpl();


  Future<Either<Failure, TradeItemList>> doGetTradeList() async {
    return await _repo.getTradeList();
  }

  Future<Either<Failure, bool>> doFilterTradeList() {
    throw UnimplementedError();
  }
}
