library api_factory;
import 'source/local/_payment_web_socket_api_fake.dart';
import 'source/local/_rpc_fake.dart';
import 'source/remote/_payment_remote_api.dart';
import 'source/remote/remote_data_source.dart';
import '../../global_mediator.dart';
import 'api/apis.dart';
//@formatter:off
class ApiFactory {
  static PaymentApi getWebSocketPayApiInstance(PaymentConnectionObserver listener){
    // final api=PaymentWebSocketApiImpl();
    // api.registerAsListener(listener);
    //  return api;
    final api=PaymentFake();
    api.registerAsListener(listener);
    return api;
  }
  static PaymentApi getRPCPayApiInstance(PaymentConnectionObserver listener){
    return RPCPaymentApiWrapper.getInstance(
        listener: listener,
        factory:(){
          return _createRPCPayApi(AppMediator.instance);
        }
    );
  }
  static RPCPaymentApiWrapper getRPCConnector(PaymentConnectionObserver listener){
    return RPCPaymentApiWrapper.getInstance(
        listener: listener,
        factory:(){
          return _createRPCPayApi(AppMediator.instance);
        }
    );
  }
  static RPCPayCoreApi _createRPCPayApi(RPCTokenManager provider){
   //return RPCPaymentApiImpl(provider);
    return RPCPaymentImplFake(provider);
  }


}


