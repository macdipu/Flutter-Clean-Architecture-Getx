class RepositoryUnavailableException implements Exception {
  RepositoryUnavailableException([var message]);
}

class ApiException implements Exception {
  final int code;
  final String message;

  ApiException(this.code, this.message);

  @override
  String toString() {
    return 'ApiException{code: $code, message: $message}';
  }
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(400, message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(401, message);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(403, message);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(404, message);
}

class MethodNotAllowedException extends ApiException {
  MethodNotAllowedException(String message) : super(405, message);
}

class ConflictException extends ApiException {
  ConflictException(String message) : super(409, message);
}

class UserDeactivatedException extends ApiException {
  UserDeactivatedException(String message) : super(417, message);
}

class TooManyRequestsException extends ApiException {
  TooManyRequestsException(String message) : super(429, message);
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException(String message) : super(500, message);
}

class BadGatewayException extends ApiException {
  BadGatewayException(String message) : super(502, message);
}

class ServiceUnavailableException extends ApiException {
  ServiceUnavailableException(String message) : super(503, message);
}

class GatewayTimeoutException extends ApiException {
  GatewayTimeoutException(String message) : super(504, message);
}