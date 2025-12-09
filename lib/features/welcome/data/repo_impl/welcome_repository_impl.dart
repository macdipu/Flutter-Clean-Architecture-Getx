import 'package:dartz/dartz.dart';

import '../../../../core/data/cache/preference/shared_preference_constants.dart';
import '../../../../core/data/http/client/base_http_repository.dart';
import '../../../../core/domain/domain_export.dart';
import '../../domain/entity/instruction.dart';
import '../../domain/repository/welcome_repository.dart';

class WelcomeRepositoryImpl extends BaseHttpRepository implements WelcomeRepository {
  @override
  Future<bool> isUserLoggedIn() async {
    String? session = await preferenceCache.get(SharedPreferenceConstant.customerInfo);

    if (session == null) {
      return Future.value(false);
    }

    client.setToken();
    return Future.value(true);
  }

  @override
  Future<Either<Failure, List<Instruction>>> getInstructionData() {
    throw UnimplementedError();
  }
}
