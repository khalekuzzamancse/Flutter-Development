part of core_language;
class CustomException implements Exception {
  final String message;
  final String debugMessage;
  final String code;

  CustomException({required this.message, required this.debugMessage, this.code = ""});

  @override
  String toString() {
    return "Code: $code\nMessage: $message\nDebug Message: $debugMessage";
  }
}

class TokenNotFoundException extends CustomException {
  TokenNotFoundException({
    String message = 'Unable to retrieve Login session',
    String debugMessage = 'Failed to retrieve the token',
  }) : super(message: message, debugMessage: debugMessage, code: "DE-TRE");

}
class UnauthorizedException extends CustomException {
  UnauthorizedException({
    String message = 'Login session expire',
    String debugMessage = 'May be the token is invalid or expired',
  }) : super(message: message, debugMessage: debugMessage, code: "DE-Unt");

}
class JsonParsingException extends CustomException {
  JsonParsingException({
    String message = 'Something is went wrong with Error code: JPE',
    String debugMessage = 'Json Parsing error',
  }) : super(message: message, debugMessage: debugMessage, code: "JPE");

}

class ServerConnectingException extends CustomException {
  final Exception exception;

  ServerConnectingException(this.exception)
      : super(
      message: exception.toString(),
      debugMessage: "Server connection problem:\nMessage: ${exception.toString()}\nCause: ${exception.runtimeType}");

  @override
  String get code => "SCE";

  @override
  String toString() {
    return "ServerConnectingException -> ${super.toString()}";
  }
}

class UnKnownException extends CustomException {
  final Object exception; //in dart exception is Object

  UnKnownException(this.exception)
      : super(
      message: "Something went wrong",
      debugMessage: exception.toString());

  @override
  String get code => "UNE";

  @override
  String toString() {
    return "UnKnownException -> ${super.toString()}";
  }
}

class MessageFromServerException extends CustomException {
  final String serverMessage;

  MessageFromServerException(this.serverMessage)
      : super(
      message: serverMessage,
      debugMessage: "Server returned a messages_server_data_source.dart instead of expected response: $serverMessage");

  @override
  String get code => "MFSIOR";

  @override
  String toString() {
    return "MessageFromServerException -> ${super.toString()}";
  }
}

class NetworkIOException extends CustomException {
  NetworkIOException({required String message, required String debugMessage})
      : super(message: message, debugMessage: debugMessage);

  @override
  String toString() {
    return "NetworkIOException -> ${super.toString()}";
  }

  @override
  String get code => "NIOE";
}

class DuplicateRecordException extends CustomException {
  DuplicateRecordException({
    String message = "Exists already, Consider updating or deleting old one",
    String debugMessage = "Attempt to insert an existing record for parser",
  }) : super(message: message, debugMessage: debugMessage, code: "DE-DRE");

}

class RecordNotFoundException extends CustomException {
  RecordNotFoundException({
    String message = "No record found for the given criteria.",
    String debugMessage = "Query returned no results for the provided primary key, document ID, or customer query.",
  }) : super(message: message, debugMessage: debugMessage, code: "DE-RNFE");

}

class CreateFailException extends CustomException {
  CreateFailException({
    String? message,
    String debugMessage = "Failed to create or configure the database instance",
  }) : super(message: message??'Unable to create', debugMessage: debugMessage, code: "DE-DICNCE");

}
class NotImplementedException extends CustomException {
  NotImplementedException({
    String message = 'Operation is not implemented yet',
    String debugMessage = "No debug message",
  }) : super(message: message, debugMessage: debugMessage, code: "NIY");

}

class UpdateFailException extends CustomException {
  UpdateFailException({
    String? message,
    String debugMessage = "Failed to create or configure the database instance",
  }) : super(message: message??'Unable to write', debugMessage: debugMessage, code: "DE-DICNCE");

}

class ReadFailException extends CustomException {
  ReadFailException({
    String? message,
    String debugMessage = "Failed to create or configure the database instance",
  }) : super(message: message??'Unable to read', debugMessage: debugMessage, code: "DE-DICNCE");

}

CustomException toCustomException({required Object exception, required String fallBackDebugMsg}) {//dart throws exception as Object
  switch (exception.runtimeType) {
    case CustomException:
      return exception as CustomException; //If already a customer exception such as by other method then return it


    case ServerConnectingException:
      return ServerConnectingException(exception as ServerConnectingException);

    case NetworkIOException:
      return NetworkIOException(
        message: "Network error occurred. Please check your connection.",
        debugMessage: (exception as NetworkIOException).debugMessage,
      );

    case MessageFromServerException:
      return MessageFromServerException(
          (exception as MessageFromServerException).serverMessage);

    case UnKnownException:
      return UnKnownException((exception as UnKnownException).exception);

    default:
      return CustomException(message: 'Something is went wrong',debugMessage: fallBackDebugMsg);
  }
}
