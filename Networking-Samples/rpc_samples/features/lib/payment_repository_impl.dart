
import '_payment_models.dart';
import '_payment_repository.dart';
import 'core/datasource/api/apis.dart';
import 'core/datasource/api_factory.dart';
import 'core/datasource/source/remote/_payment_remote_api.dart';
import 'core/datasource/source/remote/remote_data_source.dart';
import 'core/language/core_language.dart';

class PaymentRepositoryImpl implements PaymentRepository, PaymentEventObserver {
  late final PaymentApi _api;
  late final tag = runtimeType.toString();
  static const int typeWebSocket = 1;
  static const int typeRPC = 2;
  final PayEventObserver _observer;

  PaymentRepositoryImpl._(int type, this._observer) {
      _api = ApiFactory.getRPCPayApiInstance(this);
  }

  ///type=1 for webSocket, type=2 for RPC
  static PaymentRepository create(int type, PayEventObserver observer) {
    Logger.off('PaymentRepositoryImpl', 'type:$type');
    if (type != 1 && type != 2) {
      throw CustomException(
        message: 'Unknown pay API type',
        debugMessage: 'PaymentRepositoryImpl',
      );
    }
    return PaymentRepositoryImpl._(type, observer);
  }

  @override
  void register(PayEventObserver observer) {
    NotImplementedException(debugMessage: tag);
  }

  @override
  void unRegister() {
    NotImplementedException(debugMessage: tag);
  }

  @override
  Future<void> cancelTransaction() => _api.cancelTransaction();

  @override
  void connectWebSocket(
      {required String softwareHouseId,
      required String deviceUid,
      required String apiVersion,
      required String apiKey,
      required String tid}) {
    Logger.on(tag, 'connectWebSocket');
    if (_api is PaymentWebSocketApiImpl) {
      (_api as PaymentWebSocketApiImpl).connectWebSocket(
          softwareHouseId: softwareHouseId,
          deviceUid: deviceUid,
          apiVersion: apiVersion,
          apiKey: apiKey,
          tid: tid);
    } else {
      onError('No Connector found at Repository');
    }
  }
  @override
  void connectRPC(
      {required String ip,
        required String port,
        required String tid,
        required String pairCode}) {
    Logger.on(tag, 'connectRPC');
    if (_api is RPCPaymentApiWrapper) {(_api as RPCPaymentApiWrapper)
          .connectOrThrow(ip: ip, port: port, tid: tid, pairCode: pairCode);
    } else {
      onError('No RPC Connector found at Repository');
    }
  }
  @override
  Future<void> disconnectTry() => _api.disconnectOrThrow();

  @override
  bool isConnected() => _api.isConnected();

  @override
  void startTransaction(
      {required double amount,
      required double discount,
      required double cashback,
      required double gratuity}) {
    Logger.on(tag, 'startTransaction');
    _api.startTransaction(
        amount: amount,
        discount: discount,
        cashback: cashback,
        gratuity: gratuity);
  }

// TODO: Events
  @override
  void onConnected() {
    _observer.onEvent(SocketState.connected);
    Logger.off(tag, 'onConnected');
  }

  @override
  void onConnecting() {
    _observer.onEvent(SocketState.connecting);
    Logger.off(tag, 'onConnecting');
  }

  @override
  void onDisconnected() {
    _observer.onEvent(SocketState.disconnected);
    Logger.off(tag, 'onDisconnected');
  }

  @override
  void onError(String error) {
    _observer.onEvent(SocketState.error(error));
  }

  @override
  void onTransactionCancelled() {
    _observer.onEvent(SocketState.transactionCancelled);
  }

  @override
  void onTransactionInProgress(String message, {required bool cancellable}) {
    _observer.onEvent(SocketState.transactionInProgress(message, cancellable));
  }

  @override
  void onTransactionRequesting() {
    _observer.onEvent(SocketState.requesting);
  }

  @override
  void onTransactionSuccess() {
    _observer.onEvent(SocketState.transactionSuccess);
  }


}
