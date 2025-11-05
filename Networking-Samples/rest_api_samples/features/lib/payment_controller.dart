import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '_payment_models.dart';
import '_payment_repository.dart';
abstract interface class CardPayController{
  Rx<SocketState> get state;
  bool isConnected();
  void connect();
  Future<void> cancelTransaction();
  void startTransaction({
    required double amount,
    required double discount,
    required double cashback,
    required double gratuity,
  });
  Future<void> disconnect();
  void observerEvent(PayEventObserver observer);
  void dispose();
}