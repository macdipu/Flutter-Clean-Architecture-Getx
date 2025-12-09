import 'package:dartz/dartz.dart';

import '../../../../core/data/cache/client/base_cache_repository.dart';
import '../../../../core/data/cache/preference/shared_preference_constants.dart';
import '../../../../core/domain/error/failure.dart';
import '../../domain/model/auth_facebook_req.dart';
import '../../domain/model/auth_gmail_req.dart';
import '../../domain/model/auth_login_req.dart';
import '../../domain/model/auth_reg_req.dart';
import '../../domain/model/user_info.dart';
import '../../domain/repository/auth_repository.dart';
import 'auth_http_impl.dart';

class AuthCacheImpl extends BaseCacheRepository implements AuthRepository {
  final AuthHttpImpl _repo = AuthHttpImpl();
  @override
  Future<Either<Failure, UserInfo>> emailLogin(AuthLoginReq req) async {
    Either<Failure, UserInfo> user = await _repo.emailLogin(req);

    if (user.isRight()) {
      UserInfo? tradeList = user.fold((l) => null, (r) => r);
      await preferenceCache.forever(SharedPreferenceConstant.customerInfo, tradeList!.toJsonString());

      await _repo.jwtUpdated();
    }

    return user;
  }

  @override
  Future<Either> facebookLogin(AuthFacebookReq req) {
    throw UnimplementedError();
  }

  @override
  Future<Either> gmailLogin(AuthGmailReq req) {
    throw UnimplementedError();
  }

  @override
  Future<Either> registration(AuthRegistrationReq req) {
    throw UnimplementedError();
  }

  @override
  Future<void> jwtUpdated() async {
    await _repo.jwtUpdated();
  }
}
