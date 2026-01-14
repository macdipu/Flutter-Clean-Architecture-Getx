import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_getx/core/domain/usecase/usecase.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/domain/model/auth_login_req.dart';
import 'dart:ui';
import '../../../../core/domain/domain_export.dart';
import '../model/user_info.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserInfo>> login(AuthLoginReq req);

  Future<void> jwtUpdated();

  ResultFuture<Locale> toggle();

  Future<Locale?> getSavedLocale();
}
