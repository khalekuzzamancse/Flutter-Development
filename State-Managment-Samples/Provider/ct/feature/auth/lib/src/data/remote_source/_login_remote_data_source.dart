part of 'remote_data_source.dart';

abstract class LoginRemoteDataSource implements LoginApi {
  late final className = runtimeType.toString();
  ///return the token
  Pair<String,String> parserOrThrow(Json response);
  Json createPayload({required String username,required String password});
  static LoginApi create()=>AuthDevsStreamSource._();

  @override
  //@formatter:off
  Future<Pair<String,String>> loginOrThrow(String username, String password) async{
    final payload= createPayload(username: username,password: password);
    Logger.on(className, 'payload=$payload');
    final response=  await NetworkClient.createBaseClient()
        .postOrThrow(url:UrlFactory.urls.login,headers: null, payload:payload );

    Logger.on(className, 'response=$response');
    return parserOrThrow(response);
  }
  @override
  Future<String> readTokenOrThrow(String refreshToken) async{
    throw NotImplementedException();
  }
}

class AuthDevsStreamSource extends LoginRemoteDataSource{
  AuthDevsStreamSource._();
  static LoginApi create()=>AuthDevsStreamSource._();
  @override
  Pair<String,String> parserOrThrow(Json response) {
    final responseEntity = ServerResponse.fromJsonOrThrow(response);
    if (responseEntity.isSuccess) {
      final Map<String,dynamic> data = responseEntity.data;
     // final String token = data['token']; //capable of throw exception is key not present
      final accessToken= data['access_token'];
      final refreshToken= data['refresh_token'];
      return Pair(accessToken, refreshToken);
    }
    //On failure
    throw CustomException(message: responseEntity.errorMessage ?? 'Login: Something is went wrong', debugMessage: 'local:$className,response:$response');

  }


  @override
  Json createPayload({required String username, required String password}) {
    return {'phone': username, 'password': password};
  }

}