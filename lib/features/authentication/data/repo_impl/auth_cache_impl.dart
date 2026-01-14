
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_getx/core/data/cache/client/base_cache_repository.dart';
import 'package:flutter_clean_architecture_getx/core/data/cache/preference/shared_preference_constants.dart';
import 'package:flutter_clean_architecture_getx/core/domain/error/failure.dart';
import 'package:flutter_clean_architecture_getx/core/domain/usecase/usecase.dart';
import 'dart:ui';
import '../../domain/model/auth_login_req.dart';
import '../../domain/model/user_info.dart';
import '../../domain/repository/auth_repository.dart';
import 'auth_http_impl.dart';

class AuthCacheImpl extends BaseCacheRepository implements AuthRepository {
  final AuthHttpImpl authHttpImpl;

  AuthCacheImpl(super.cache, this.authHttpImpl);

  @override
  Future<Either<Failure, UserInfo>> login(AuthLoginReq req) async {
    Either<Failure, UserInfo> result = await authHttpImpl.login(req);

    if (result.isRight()) {
      UserInfo? userInfo = result.fold((l) => null, (r) => r);
      await cache.forever(
          SharedPreferenceConstant.customerInfo, userInfo!.toJsonString());

      await authHttpImpl.jwtUpdated();
    }

    return result;
  }

  @override
  Future<void> jwtUpdated() async {
    await authHttpImpl.jwtUpdated();
  }

  @override
  ResultFuture<Locale> toggle() async {
    try {
      final saved = await cache.get(SharedPreferenceConstant.locale);
      final currentCode = saved ?? 'en';
      final newCode = currentCode == 'bn' ? 'en' : 'bn';
      // save new locale
      await cache.forever(SharedPreferenceConstant.locale, newCode);
      return Right(Locale(newCode)) ;
    } catch (e) {
      throw Exception('Failed to toggle locale');
    }
  }

  @override
  Future<Locale?> getSavedLocale() async {
    try {
      final saved = await cache.get(SharedPreferenceConstant.locale);
      if (saved == null) return null;
      return Locale(saved);
    } catch (e) {
      return null;
    }
  }
}
