import 'package:flutter_clean_architecture_getx/core/domain/error/failure.dart';
import 'package:flutter_clean_architecture_getx/core/domain/usecase/usecase.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../model/auth_login_req.dart';
import '../model/user_info.dart';

class DoLoginUseCase extends UseCaseWithParams<bool, AuthLoginReq> {
  final AuthRepository authRepository;

  DoLoginUseCase(this.authRepository);

  @override
  ResultFuture<bool> call(AuthLoginReq params) async {
    Either<Failure, UserInfo> userInfo = await authRepository.emailLogin(params);

    return userInfo.fold(
      (l) => Left(l),
      (r) => Right(true),
    );
  }
}
