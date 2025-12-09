import 'package:dartz/dartz.dart';

import '../../../../core/domain/domain_export.dart';
import '../entity/instruction.dart';


abstract class WelcomeRepository {
  Future<bool> isUserLoggedIn();

  Future<Either<Failure, List<Instruction>>> getInstructionData();
}
