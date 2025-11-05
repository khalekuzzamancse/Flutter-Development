import '_payment_models.dart';
abstract interface class PaymentRepository{
  void register(PayEventObserver observer);
  void unRegister();
  bool isConnected();
  void connectWebSocket({required String softwareHouseId,
    required String deviceUid, required String apiVersion, required String apiKey, required String tid});
   void connectRPC({required String ip,
       required String port,
       required String tid,
       required String pairCode});
  Future<void> cancelTransaction();
  void startTransaction({
    required double amount, required double discount, required double cashback, required double gratuity,
  });
  Future<void> disconnectTry();
}
abstract class PayEventObserver{
  onEvent(SocketState state);
}