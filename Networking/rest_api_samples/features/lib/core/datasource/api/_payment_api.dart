part of 'apis.dart';

abstract interface class PaymentApi{
  void registerAsListener(PaymentEventObserver listener);
  void unregister(PaymentEventObserver listener);
  bool isConnected();
  Future<void> cancelTransaction();
  void startTransaction({
    required double amount, required double discount, required double cashback, required double gratuity,
  });
  Future<void> disconnectOrThrow();
}

abstract interface class PaymentConnectionObserver{
  void onConnecting();
  void onConnected();
  void onDisconnected();
  void onError(String error);
}
abstract interface class PaymentEventObserver implements PaymentConnectionObserver {
  void onTransactionRequesting();
  void onTransactionInProgress(String message,{required bool cancellable});
  void onTransactionSuccess();
  void onTransactionCancelled();
}

