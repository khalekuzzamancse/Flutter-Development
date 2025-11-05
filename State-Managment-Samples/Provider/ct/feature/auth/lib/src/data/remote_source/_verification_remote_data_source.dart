part of 'remote_data_source.dart';

 abstract class VerificationRemoteDataSrcTemplate implements VerificationApi{
   late final client=  NetworkClient.createBaseClient();
   late final tag=runtimeType.toString();

   Json createConfirmPayload(String userId, String code);
   Json createIsVerifiedPayload(String userId);
   Json createSendVerificationPayload(String userId);

  @override
  Future confirmVerification(String userId, String code) async{
    const method='confirmVerification';
    final payload= createConfirmPayload(userId,code);
    Logger.keyValueOff(tag,method, 'payload',payload);
    final response= await client.postOrThrow(url: UrlFactory.urls.confirmVerification,headers: null, payload:payload );
    Logger.keyValueOff(tag,method, 'response',response);
    return "Not implemented yet";
  }

  @override
  Future<dynamic> isVerified(String userId) async{
    const method='isVerified';
    final payload= createIsVerifiedPayload(userId);
    Logger.keyValueOff(tag,method, 'payload',payload);
    final response= await client.postOrThrow(url: UrlFactory.urls.isVerified,headers: null, payload:payload );
    Logger.keyValueOff(tag,method, 'response',response);
    return "Not implemented yet";
  }

  @override
  Future<dynamic> sendVerification(String userId) async{
    const method='sendVerification';
    final payload= createSendVerificationPayload(userId);
    Logger.keyValueOff(tag,method, 'payload',payload);
    final response=await client.postOrThrow(url: UrlFactory.urls.verificationRequest,headers: null, payload:payload );
    Logger.keyValueOff(tag,method, 'response',response);
    return "Not implemented yet";
  }

}
final class VerificationRemoteDataSrc extends VerificationRemoteDataSrcTemplate{
  @override
  Json createConfirmPayload(String userId, String code) {

    // TODO: implement createConfirmPayload
    throw NotImplementedException();
  }

  @override
  Json createIsVerifiedPayload(String userId) {
    // TODO: implement createIsVerifiedPayload
    throw NotImplementedException();
  }

  @override
  Json createSendVerificationPayload(String userId) {
    // TODO: implement createSendVerificationPayload
    throw NotImplementedException();
  }

}