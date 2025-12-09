import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../core/data/http/client/base_http_repository.dart';
import '../../../../core/data/http/urls/api_urls.dart';
import '../../../../core/domain/error/failure.dart';
import '../../domain/entity/trade_item.dart';
import '../../domain/repo/trade_repository.dart';
import '../model/item_list_response.dart';

class TradeHttpImp extends BaseHttpRepository implements TradeRepository {
  late final ApiUrl urls;

  TradeHttpImp(super.client, this.urls);

  @override
  Future<Either<Failure, TradeItemList>> getTradeList() async {
    try {
      final response = await client.authorizedGet(urls.getAllTrade);
      if (response.messageCode == 200) {
        ItemListResponse itemList = ItemListResponse.fromJson(response.response);

        List<TradeItem> list = [];
        for (var item in itemList.data!) {
          list.add(TradeItem(
            item.name,
            item.estimateBuyingPrice,
            item.estimateSellingingPrice,
          ));

          Logger().i(item.name);
        }

        return Right(TradeItemList(tradeItems: list));
      } else {
        return const Left(ConnectionFailure("response.data['message']"));
      }
    } catch (e) {
      return Left(ConnectionFailure(e.toString()));
    }
  }
}
