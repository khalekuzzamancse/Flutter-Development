part of 'remote_data_source.dart';

abstract class ResetPasswordRemoteDataSrcTemplate implements ResetPasswordApi {
  late final tag=runtimeType.toString();
  late final client=NetworkClient.createBaseClient();
   Json createPayload(String userId, String code, String password);

  @override
  Future<dynamic> resetPassword(String userId, String code, String password)async {
    const method='sendVerification';
    final payload= createPayload(userId,code,password);
    Logger.keyValueOff(tag,method, 'payload',payload);
    final response= await client.postOrThrow(url: UrlFactory.urls.verificationRequest,headers: null, payload:payload );
    Logger.keyValueOff(tag,method, 'response',response);
    throw NotImplementedException();
  }

}
final class ResetPasswordRemoteDataSrc extends ResetPasswordRemoteDataSrcTemplate{
  @override
  Json createPayload(String userId, String code, String password) {
    // TODO: implement createPayload
    throw NotImplementedException();

  }

}