import 'package:dartz/dartz.dart';
import 'package:customer/features/authentication/domain/model/auth_login_req.dart';
import '../../../../core/domain/domain_export.dart';
import '../model/user_info.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserInfo>> login(AuthLoginReq req);

  Future<void> jwtUpdated();
}
