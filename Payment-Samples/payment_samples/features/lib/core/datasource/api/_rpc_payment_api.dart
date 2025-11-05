part of 'apis.dart';

abstract interface class RPCPayCoreApi {
  ///on success, return token for further usage
  Future<String> pairRequestOrThrow(
      {required String ip,
      required String port,
      required String tid,
      required String pairCode});
  ///on success, return uti for further usage
  Future<String> startTransactionOrThrow(
      {required double amount,
      required double discount,
      required double cashback,
      required double gratuity});
  Future<void> cancelRequestOrThrow();
  Future<String> terminalStatusRequestOrThrow();
  Future<List<String>> readTransactionStatusOrThrow({required String uti,bool reversal=false});
}
