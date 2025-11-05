
class PaySocketInfo {
  final String softwareHouseId;
  final String deviceUid;
  final String apiVersion;
  final String apiKey;
  final String tid;

  PaySocketInfo({
    required this.softwareHouseId,
    required this.deviceUid,
    required this.apiVersion,
    required this.apiKey,
    required this.tid,
  });

  @override
  String toString() {
    return 'AuthRequest(softwareHouseId: $softwareHouseId, deviceUid: $deviceUid, apiVersion: $apiVersion, apiKey: $apiKey, tid: $tid)';
  }
}

sealed class SocketState {
  const SocketState();

  static const SocketState none = SocketStateNone();

  static const SocketState transactionCancelled = TransactionCancelled();
  static const SocketState transactionSuccess = SocketConnectStatusTransactionSuccess();
  static const SocketState connected = SocketConnectStatusConnected();
  static const SocketState connecting = SocketConnectStatusConnecting();
  static const SocketState disconnected = SocketConnectStatusDisconnected();
  static bool isRequesting(SocketState state)=>state is SocketStateRequesting;
  static SocketState get requesting=>const SocketStateRequesting();
  static SocketConnectStatusTransactionInProgress transactionInProgress(String message,bool cancelable) =>
      SocketConnectStatusTransactionInProgress(message,cancellable: cancelable);
  static SocketConnectStatusError error(String message) => SocketConnectStatusError(message);
}

final class SocketStateNone extends SocketState {
  const SocketStateNone();
}
final class SocketStateRequesting extends SocketState {
  const SocketStateRequesting();
}

class SocketConnectStatusTransactionInProgress extends SocketState {
  final String message;
  final bool cancellable;

  const SocketConnectStatusTransactionInProgress(this.message,{required this.cancellable});
}

class SocketConnectStatusError extends SocketState {
  final String message;
  const SocketConnectStatusError(this.message);
}

class TransactionCancelled extends SocketState {
  const TransactionCancelled();
}

class SocketConnectStatusTransactionSuccess extends SocketState {
  const SocketConnectStatusTransactionSuccess();
}

class SocketConnectStatusConnected extends SocketState {
  const SocketConnectStatusConnected();
}

class SocketConnectStatusConnecting extends SocketState {
  const SocketConnectStatusConnecting();
}

class SocketConnectStatusDisconnected extends SocketState {
  const SocketConnectStatusDisconnected();
}
