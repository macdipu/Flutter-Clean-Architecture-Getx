import 'package:clean_architecture_getx/core/domain/error/failure.dart';
import 'package:clean_architecture_getx/core/domain/usecase/usecase.dart';
import 'package:clean_architecture_getx/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../model/auth_gmail_req.dart';

class DoGmailLoginUseCase extends UseCaseWithParams<bool, AuthGmailReq> {
  final AuthRepository authRepository;

  DoGmailLoginUseCase(this.authRepository);

  @override
  ResultFuture<bool> call(AuthGmailReq params) async {
    var result = await authRepository.gmailLogin(params);

    return result.fold(
      (l) => Left(l),
      (r) => Right(true),
    );
  }
}

