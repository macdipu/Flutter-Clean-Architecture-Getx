import 'package:dartz/dartz.dart';

import '../../../../core/domain/domain_export.dart';
import '../entity/trade_item.dart';

abstract class TradeRepository {
  Future<Either<Failure, TradeItemList>> getTradeList();
}
