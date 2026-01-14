
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_getx/core/data/http/client/api_client.dart';
import 'package:flutter_clean_architecture_getx/core/data/http/client/base_http_repository.dart';
import 'package:flutter_clean_architecture_getx/core/data/http/urls/api_urls.dart';
import 'package:flutter_clean_architecture_getx/core/domain/error/failure.dart';
import 'package:flutter_clean_architecture_getx/core/domain/usecase/usecase.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/domain/model/auth_login_req.dart';

import '../../domain/model/user_info.dart';
import '../../domain/repository/auth_repository.dart';
import '../model/auth_login_response.dart';

class AuthHttpImpl extends BaseHttpRepository implements AuthRepository {
  late final ApiClient _client;
  late final AuthenticationApiUrls _urls;

  AuthHttpImpl(this._client, this._urls) : super(_client);

  @override
  Future<Either<Failure, UserInfo>> login(AuthLoginReq req) async {
    try {
      // final response = await _client.post(_urls.emailLoginUrl, req.toJson());
      // if (response.messageCode == 200) {
      //   AuthLoginResponse authResponse = AuthLoginResponse.fromJson(response.response);
      //
      //   return Right(
      //       UserInfo(
      //       accessToken: authResponse.accessToken ?? "",
      //       refreshToken: authResponse.refreshToken ?? "")
      //   );
      // } else {
      //   return const Left(ConnectionFailure("response.data['message']"));
      // }

     return right(
          UserInfo(
              role: 'USER',
              accessToken:  "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6IlVTRVIiLCJ1c2VySWQiOjUzLCJkZXZpY2VJZCI6IjhhZmVhMWIwLWVmODEtNDgwZS1iM2Q2LTMxNGQzNDMxMTIzZi5FbDBaWThuWC1IUFZVbnVZNG03SkduMkwxMzQwNlpvcVBoTkVyQXNOcHpNIiwic3ViIjoiMDEzMTc1NzcyMzciLCJpYXQiOjE3NjgyMjU5MzEsImV4cCI6MTc2ODMxMjMzMX0.rrEHlfZ7Jta4fS4oP23kvsyzEoWmI-anYubaL3KarwA",
              refreshToken:  "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6IlVTRVIiLCJ1c2VySWQiOjUzLCJkZXZpY2VJZCI6IjhhZmVhMWIwLWVmODEtNDgwZS1iM2Q2LTMxNGQzNDMxMTIzZi5FbDBaWThuWC1IUFZVbnVZNG03SkduMkwxMzQwNlpvcVBoTkVyQXNOcHpNIiwic3ViIjoiMDEzMTc1NzcyMzciLCJpYXQiOjE3NjgyMjU5MzEsImV4cCI6MTc2ODIyNjUzMX0.0YTPQ9EHeh4Rr5pCeXO_VziHKFiIIm5RwcHVdRRalqw"
          )
      );

    } catch (e) {
      throw Future.error(e);
    }
  }

  @override
  Future<void> jwtUpdated() async {
    await _client.setToken();
  }

  @override
  ResultFuture<Locale> toggle() {
    throw UnimplementedError();
  }

  @override
  Future<Locale?> getSavedLocale() {
    throw UnimplementedError();
  }
}
