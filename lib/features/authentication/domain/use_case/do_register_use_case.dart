import 'package:flutter_clean_architecture_getx/core/domain/error/failure.dart';
import 'package:flutter_clean_architecture_getx/core/domain/usecase/usecase.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../model/auth_reg_req.dart';

class DoRegisterUseCase extends UseCaseWithParams<bool, AuthRegistrationReq> {
  final AuthRepository authRepository;

  DoRegisterUseCase(this.authRepository);

  @override
  ResultFuture<bool> call(AuthRegistrationReq params) async {
    var result = await authRepository.registration(params);

    return result.fold(
      (l) => Left(l),
      (r) => Right(true),
    );
  }
}

