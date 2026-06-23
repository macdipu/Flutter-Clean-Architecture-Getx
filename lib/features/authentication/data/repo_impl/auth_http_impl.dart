
import 'package:dartz/dartz.dart';
import 'package:customer/core/data/http/client/api_client.dart';
import 'package:customer/core/data/http/client/base_http_repository.dart';
import 'package:customer/core/data/http/urls/api_urls.dart';
import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/features/authentication/domain/model/auth_login_req.dart';

import '../../domain/model/user_info.dart';
import '../../domain/repository/auth_repository.dart';

class AuthHttpImpl extends BaseHttpRepository implements AuthRepository {
  final AuthenticationApiUrls _urls;

  AuthHttpImpl(ApiClient client, this._urls) : super(client);

  @override
  Future<Either<Failure, UserInfo>> login(AuthLoginReq req) async {
    try {
      final response = await client.post(_urls.emailLoginUrl, req.toJson());
      if (response.messageCode == 200) {
        return Right(UserInfo.fromJson(response.response as Map<String, dynamic>));
      } else {
        return Left(ServerFailure(response.message ?? 'Login failed'));
      }
    } catch (e) {
      return Left(ConnectionFailure(e.toString()));
    }
  }

  @override
  Future<void> jwtUpdated() async {
    await client.setToken();
  }
}
