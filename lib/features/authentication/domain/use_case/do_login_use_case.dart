
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_getx/core/domain/usecase/usecase.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/domain/repository/auth_repository.dart';

import '../model/auth_login_req.dart';
import '../model/user_info.dart';

class DoLoginUseCase extends UseCaseWithParams<bool, AuthLoginReq> {
  final AuthRepository authRepository;

  DoLoginUseCase(this.authRepository);

  @override
  ResultFuture<bool> call(AuthLoginReq params) async {
  final userInfo = await authRepository.login(params);
  return userInfo.fold((l) => left(l), (r) => Right(true));
  

  }
}