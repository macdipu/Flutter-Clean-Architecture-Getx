import 'package:dartz/dartz.dart';
import '../entity/trade_item.dart';
import '../repo/trade_repository.dart';
import 'package:flutter_clean_architecture_getx/core/domain/usecase/usecase.dart';

class TradeUseCase extends UseCaseWithoutParams<TradeItemList> {
  final TradeRepository _repo;

  TradeUseCase(this._repo);

  @override
  ResultFuture<TradeItemList> call() async {
    var userInfo = await _repo.getTradeList();

    return userInfo.fold(
          (l) => Left(l),
          (r) => Right(TradeItemList(tradeItems: r.tradeItems)),
    );
  }
}
