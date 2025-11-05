

import 'core/datasource/source/remote/remote_data_source.dart';
import 'core/language/core_language.dart';
import 'core/network/core_network.dart';

/// Must initialize it in the app, Global mediator for whole app
class AppMediator implements AuthExpireObserver, TokenManager,RPCTokenManager {
  static const int typeWebSocketProtocol=1;
  static const int typeRPCProtocol=2;
  static final AppMediator instance = AppMediator._();
  ///await to make sure dependency...
  Future<void> init()async{
    NetworkClientDecorator.registerAsListener(this);
    NetworkClientDecorator.setTokenManager(this);

  }

  AppMediator._();
  late final tag = runtimeType.toString();
  @override
  void onSessionExpire() {
    Logger.on(tag, 'onSessionExpire');

  }

  @override
  Future<String> getTokenOrThrow()async{
    return " AuthPreserverController.retrieveTokenOrThrow()";
  }

  @override
  Future<void> updateAccessToken()async{

  }

  @override
  Future<String> getRPCTokenOrThrow()async{
    return "RPCInfoPreserver.getTokenOrThrow()";
  }

  @override
  Future<void> saveRPCToken(String token)async{}
}
