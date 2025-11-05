
part of "core_language.dart";
class CustomException implements Exception {
  final String message;
  final String debugMessage;
  final String code;

  const CustomException({
    required this.message,
    required this.debugMessage,
    this.code = '',
  });

  @override
  String toString() {
    return 'Code: $code\nMessage: $message\nDebug Message: $debugMessage';
  }
}

class TokenNotFoundException extends CustomException {
  TokenNotFoundException()
      : super(
    message: 'Unable to retrieve Login session',
    debugMessage: 'Failed to retrieve the token',
    code: 'DE-TRE',
  );
}

class UnauthorizedException extends CustomException {
  UnauthorizedException()
      : super(
    message: 'Login session expire',
    debugMessage: 'May be the token is invalid or expired',
    code: 'DE-Unt',
  );
}

class JsonParsingException extends CustomException {
  JsonParsingException()
      : super(
    message: 'Unexpected data format with code JPE',
    debugMessage: 'Json Parsing error',
    code: 'JPE',
  );
}

class ServerConnectingException extends CustomException {
  final dynamic exception;

  ServerConnectingException(this.exception)
      : super(
    message: exception.toString(),
    debugMessage:
    'Server connection problem:\nMessage: $exception\nCause: ${exception.runtimeType}',
    code: 'SCE',
  );

  @override
  String toString() => 'ServerConnectingException -> ${super.toString()}';
}

class UnKnownException extends CustomException {
  final dynamic exception;

  UnKnownException(this.exception)
      : super(
    message: 'Something went wrong',
    debugMessage: exception.toString(),
    code: 'UNE',
  );

  @override
  String toString() => 'UnKnownException -> ${super.toString()}';
}

class MessageFromServerException extends CustomException {
  final String serverMessage;

  MessageFromServerException(this.serverMessage)
      : super(
    message: serverMessage,
    debugMessage:
    'Server returned a message instead of expected response: $serverMessage',
    code: 'MFSIOR',
  );

  @override
  String toString() => 'MessageFromServerException -> ${super.toString()}';
}

class NetworkIOException extends CustomException {
  NetworkIOException({
    required super.message,
    required super.debugMessage,
  }) : super(
    code: 'NIOE',
  );

  @override
  String toString() => 'NetworkIOException -> ${super.toString()}';
}

class DuplicateRecordException extends CustomException {
  DuplicateRecordException()
      : super(
    message: 'Exists already, Consider updating or deleting old one',
    debugMessage: 'Attempt to insert an existing record for parser',
    code: 'DE-DRE',
  );
}

class RecordNotFoundException extends CustomException {
  RecordNotFoundException()
      : super(
    message: 'No record found for the given criteria.',
    debugMessage:
    'Query returned no results for the provided primary key, document ID, or customer query.',
    code: 'DE-RNFE',
  );
}

class CreateFailException extends CustomException {
  CreateFailException({
    String? message,
    super.debugMessage =
    'Failed to create or configure the database instance',
  }) : super(
    message: message ?? 'Unable to create',
    code: 'DE-DICNCE',
  );
}

class NotImplementedException extends CustomException {
  NotImplementedException()
      : super(
    message: 'Operation is not implemented yet',
    debugMessage: 'No debug message',
    code: 'NIY',
  );
}

class UpdateFailException extends CustomException {
  UpdateFailException({
    String? message,
    super.debugMessage =
    'Failed to create or configure the database instance',
  }) : super(
    message: message ?? 'Unable to write',
    code: 'DE-DICNCE',
  );
}

class ReadFailException extends CustomException {
  ReadFailException({
    String? message,
    super.debugMessage =
    'Failed to create or configure the database instance',
  }) : super(
    message: message ?? 'Unable to read',
    code: 'DE-DICNCE',
  );
}

CustomException toCustomException(dynamic exception, String fallbackDebugMsg) {
  if (exception is CustomException) {
    return exception;
  } else {
    return CustomException(
      message: 'Something went wrong',
      debugMessage: fallbackDebugMsg,
    );
  }
}
