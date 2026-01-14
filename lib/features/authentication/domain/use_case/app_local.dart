import 'package:flutter_clean_architecture_getx/features/authentication/domain/repository/auth_repository.dart';
import 'package:get/get.dart';
import '../../../../../../core/domain/usecase/usecase.dart';
import 'dart:ui';

class ToggleLocale implements UseCaseWithoutParams<Locale> {
  final AuthRepository authRepository;

  ToggleLocale(this.authRepository);

  @override
  ResultFuture<Locale> call() async {
    var newLocale = await authRepository.toggle();
    newLocale.fold((l) => null, (r) => Get.updateLocale(r));
    return newLocale;
  }
}
