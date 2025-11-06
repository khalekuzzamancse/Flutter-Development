part of '../../core_network.dart';

abstract interface class AuthExpireObserver{
  void onSessionExpire();
}
abstract interface class TokenManager{
  Future<void> updateAccessToken();
  Future<String> getTokenOrThrow();
}
/// Later  added, when JWT added with access token expire within 2 min
class NetworkClientDecorator implements NetworkClient {
  final NetworkClient client;
  late final tag = runtimeType.toString();
  static   AuthExpireObserver? _observer;
  static TokenManager? _tokenManager;
  static setTokenManager(TokenManager manager){
    _tokenManager=manager;
  }
 static void registerAsListener(AuthExpireObserver observer) {
    _observer = observer;
    Logger.on('NetworkClientDecorator::registerAsListener', "observer: $_observer");
  }

//@formatter:off
  static void unRegister() {
    _observer=null;
    Logger.on('NetworkClientDecorator::unRegister', "observers: $_observer");
  }
  NetworkClientDecorator._(this.client);
  static NetworkClient create(NetworkClient client)=> NetworkClientDecorator._(client);
  @override
  Future<String> getOrThrow({required String url, Headers? headers}) =>
      _withAuthStrategy((header) => client.getOrThrow(url: url, headers: header));

  @override
  Future<String> postOrThrow({required String url, required payload, Headers? headers})=>
      _withAuthStrategy((header) => client.postOrThrow(url: url, payload: payload, headers: header));


  @override
  Future<String> putOrThrow({required String url, payload, Headers? headers})=>
      _withAuthStrategy((header) => client.putOrThrow(url: url, payload: payload, headers: header));


  @override
  Future<String> patchOrThrow({required String url, required payload, Headers? headers})=>
      _withAuthStrategy((header) => client.patchOrThrow(url: url, payload: payload, headers: header));


  @override
  Future<String> deleteOrThrow({required String url, Headers? headers})=>
      _withAuthStrategy((header) => client.deleteOrThrow(url: url, headers: header));

  Future<String> _withAuthStrategy(Future<String> Function(Headers) action) async {
    try{
      return await _withRetry(action);
    }
    catch(e){
      if(e is UnauthorizedException){
        _observer?.onSessionExpire();
      }
      rethrow;
    }

  }
  Future<String> _withRetry(Future<String> Function(Headers) action) async {
    try {
      final header = await _createHeader();
      return await action(header);
    } catch (e) {
      if (e is UnauthorizedException) {
        final manager=_tokenManager;
        if(manager==null){
          throw CustomException(message: 'Token Manager not provided', debugMessage: tag);
        }
        await manager.updateAccessToken();
        final header = await _createHeader();
        return await action(header);
      } else {
        rethrow;
      }
    }
  }

  Future<Headers> _createHeader() async {
    final manager=_tokenManager;
    if(manager==null){
      throw CustomException(message: 'Token Manager not provided', debugMessage: tag);
    }
    final token = await manager.getTokenOrThrow();
    return Headers.createAuthHeader(token);
  }
}
