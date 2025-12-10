import 'package:flutter_clean_architecture_getx/core/domain/usecase/usecase.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../model/auth_facebook_req.dart';

class DoFacebookLoginUseCase extends UseCaseWithParams<bool, AuthFacebookReq> {
  final AuthRepository authRepository;

  DoFacebookLoginUseCase(this.authRepository);

  @override
  ResultFuture<bool> call(AuthFacebookReq params) async {
    var result = await authRepository.facebookLogin(params);

    return result.fold(
      (l) => Left(l),
      (r) => Right(true),
    );
  }
}

