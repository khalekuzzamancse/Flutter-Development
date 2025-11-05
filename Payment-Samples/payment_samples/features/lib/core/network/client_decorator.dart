part of api_client;

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
  Future<Json> getOrThrow({required String url, Headers? headers}) =>
      _withAuthStrategy((header) => client.getOrThrow(url: url, headers: header));

  @override
  Future<Json> postOrThrow({required String url, required payload, Headers? headers})=>
      _withAuthStrategy((header) => client.postOrThrow(url: url, payload: payload, headers: header));


  @override
  Future<Json> putOrThrow({required String url, payload, Headers? headers})=>
      _withAuthStrategy((header) => client.putOrThrow(url: url, payload: payload, headers: header));


  @override
  Future<Json> patchOrThrow({required String url, required payload, Headers? headers})=>
      _withAuthStrategy((header) => client.patchOrThrow(url: url, payload: payload, headers: header));


  @override
  Future<Json> deleteOrThrow({required String url, Headers? headers})=>
      _withAuthStrategy((header) => client.deleteOrThrow(url: url, headers: header));

  Future<Json> _withAuthStrategy(Future<Json> Function(Headers) action) async {
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
  Future<Json> _withRetry(Future<Json> Function(Headers) action) async {
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
