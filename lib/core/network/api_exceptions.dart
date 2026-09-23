abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'No internet connection', super.statusCode]);
}

class ServerException extends ApiException {
  const ServerException([super.message = 'Server error occurred', super.statusCode]);
}

class TimeoutException extends ApiException {
  const TimeoutException([super.message = 'Request connection timed out', super.statusCode]);
}

class UnknownApiException extends ApiException {
  const UnknownApiException([super.message = 'An unexpected error occurred', super.statusCode]);
}
