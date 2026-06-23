
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class AppException extends Failure {
  const AppException(super.message);
}

class LocalDatabaseQueryFailure extends Failure {
  const LocalDatabaseQueryFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}