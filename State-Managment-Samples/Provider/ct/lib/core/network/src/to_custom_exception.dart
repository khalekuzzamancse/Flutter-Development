import '../../custom_exception/custom_exception.dart';
CustomException toCustomException({required Object exception, required String fallBackDebugMsg}) {//dart throws exception as Object
  switch (exception.runtimeType) {
    case CustomException:
      return exception as CustomException; //If already a custom exception such as by other method then return it


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
