import 'package:dartz/dartz.dart';

import '../../../../core/data/http/client/base_http_repository.dart';
import '../../../../core/domain/error/failure.dart';
import '../../domain/model/auth_facebook_req.dart';
import '../../domain/model/auth_gmail_req.dart';
import '../../domain/model/auth_login_req.dart';
import '../../domain/model/auth_reg_req.dart';
import '../../domain/model/user_info.dart';
import '../../domain/repository/auth_repository.dart';
import '../model/auth_login_response.dart';

class AuthHttpImpl extends BaseHttpRepository implements AuthRepository {
  @override
  Future<Either<Failure, UserInfo>> emailLogin(AuthLoginReq req) async {
    try {
      final response = await client.post(urls.emailLoginUrl, req.toJson());
      if (response.messageCode == 200) {
        AuthLoginResponse authResponse = AuthLoginResponse.fromJson(response.response);

        return Right(UserInfo(userName: authResponse.userName ?? "", fullName: authResponse.fullName ?? "", ogrName: authResponse.organizationName ?? "", role: authResponse.isSuperAdmin ?? "admin", accessToken: authResponse.accessToken ?? "", refreshToken: authResponse.refreshToken ?? ""));
      } else {
        return const Left(ConnectionFailure("response.data['message']"));
      }
    } catch (e) {
      throw Future.error(e);
    }
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
    await client.setToken();
  }
}
