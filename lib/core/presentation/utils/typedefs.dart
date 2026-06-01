import 'package:dartz/dartz.dart';

import 'failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef StreamEither<T> = Stream<Either<Failure, T>>;
