import 'package:dartz/dartz.dart';

import '../../../../core/domain/domain_export.dart';
import '../entity/instruction.dart';


abstract class InitializationRepository {
  Future<bool> isUserLoggedIn();

  Future<Either<Failure, List<Instruction>>> getInstructionData();
}
