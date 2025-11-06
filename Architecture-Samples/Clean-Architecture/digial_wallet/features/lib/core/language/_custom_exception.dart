part of '../core_language.dart';
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

class JsonParseException extends CustomException {
  final String json;

  JsonParseException(this.json)
      : super(
            message: "Unrecognized response from the server",
            debugMessage: "The server returned a response in an unexpected format:\n$json");

  @override
  String get code => "JPE";

  @override
  String toString() {
    return "JsonParseException -> ${super.toString()}";
  }
}

class ServerConnectingException extends CustomException {
  final Exception exception;

  ServerConnectingException(this.exception)
      : super(
            message: exception.toString() ?? "Unknown server connection issue",
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
            debugMessage: "Server returned a message instead of expected response: $serverMessage");

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

CustomException toCustomException(Object exception) {//dart throws exception as Object
  //If already a custom exception such as by other method then return it
  if(exception is CustomException)
    return exception;
  switch (exception) {
    case FormatException:
      return JsonParseException(exception.toString());

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

    case JsonParseException:
      return JsonParseException((exception as JsonParseException).json);

    case UnKnownException:
      return UnKnownException((exception as UnKnownException).exception);

    default:
      return UnKnownException(exception);
  }
}
class UnauthorizedException extends CustomException {
  UnauthorizedException({
    String message = 'Login session expire',
    String debugMessage = 'May be the token is invalid or expired',
  }) : super(message: message, debugMessage: debugMessage, code: "DE-Unt");

}
CustomException toCustomException2({required Object exception, required String fallBackDebugMsg}) {//dart throws exception as Object
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