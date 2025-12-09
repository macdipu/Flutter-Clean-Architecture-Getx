import 'package:dartz/dartz.dart';

import '../../../../core/domain/domain_export.dart';
import '../entity/trade_item.dart';
import '../repo/trade_repository.dart';

class TradeUseCase {
  final TradeRepository _repo;

  TradeUseCase(this._repo);

  Future<Either<Failure, TradeItemList>> doGetTradeList() async {
    return await _repo.getTradeList();
  }

  Future<Either<Failure, bool>> doFilterTradeList() {
    throw UnimplementedError();
  }
}
