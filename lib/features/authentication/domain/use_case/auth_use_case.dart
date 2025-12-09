import 'package:dartz/dartz.dart';

import '../../../../core/domain/error/failure.dart';
import '../../data/repo_impl/auth_http_impl.dart';
import '../model/auth_facebook_req.dart';
import '../model/auth_gmail_req.dart';
import '../model/auth_login_req.dart';
import '../model/auth_reg_req.dart';
import '../model/user_info.dart';

class AuthUseCase {
  final AuthHttpImpl _repo = AuthHttpImpl();


  Future<Either<Failure, bool>> doLogin(AuthLoginReq params) async {
    Either<Failure, UserInfo?> useInfo = await _repo.emailLogin(params);

    return useInfo.fold((l) => Left(l), (r) => Right((r != null) ? true : false));
  }

  Future<Either<Failure, bool>> doRegister(AuthRegistrationReq params) {
    throw UnimplementedError();
  }

  Future<Either<Failure, bool>> doGmailLogin(AuthGmailReq params) {
    throw UnimplementedError();
  }

  Future<Either<Failure, bool>> doFacebookLogin(AuthFacebookReq params) {
    throw UnimplementedError();
  }
}
