import '../../../language/core_language.dart';
import '../remote/remote_data_source.dart';

class RPCPaymentImplFake extends RPCPaymentApiImpl {
  int _flag=0;
  bool _cancelled=false;
  RPCPaymentImplFake(super.tokenManger);
  @override

  String get className => runtimeType.toString();

  @override
  Future<String> startTransactionOrThrow({
    required double amount, required double discount, required double cashback,
    required double gratuity})async {
    return 'fake uit';
  }
@override
  Future cancelRequestOrThrow() async{
    _cancelled=true;
  }
  @override
  Future<List<String>> readTransactionStatusOrThrow({
    required String uti,
    bool reversal = false,
  }) async {
    Logger.off(className, 'readTransactionStatusOrThrow::called times=$_flag');
    _flag++;
    if(_cancelled){
      return   ['Transaction Cancelled'];
    }

    if (_flag == 1) {
      return ['Transaction started'];
    } else if (_flag == 2) {
      return ['Transaction started', 'Card Inserted'];
    } else if (_flag == 3) {
      return ['Transaction started', 'Card Inserted'];
    }
    else if (_flag == 4) {
      return ['Transaction started', 'Card Inserted','GetCard Screen Displayed'];
    }
    else if (_flag == 5) {
      return ['Transaction started', 'Card Inserted','GetCard Screen Displayed', 'Transaction Processing'];
    }
    else if (_flag == 6) {
      return [ 'Transaction Finished'];
    }
    // else if(_flag==6){
    //   return ['disconnected'];
    // }
    else {
      _flag = 0;
      return [];
    }
  }


  @override
  Future<String> pairRequestOrThrow({required String ip, required String port, required String tid, required String pairCode}) async{
    return 'fake token';
  }
}