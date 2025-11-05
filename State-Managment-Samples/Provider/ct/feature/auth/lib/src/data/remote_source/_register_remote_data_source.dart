part of 'remote_data_source.dart';

abstract class RegisterRemoteDataSrcTemplate implements RegisterApi{
  late final tag=runtimeType.toString();

   Json createPayload(RegisterEntity entity);

  @override
  Future<dynamic> registerOrThrow(RegisterEntity entity) async{
    const method='registerOrThrow';
    final payload= createPayload(entity);
    Logger.keyValueOff(tag,method, 'payload',payload);
    final response=  await NetworkClient.createBaseClient()
        .postOrThrow(url: UrlFactory.urls.register,headers: null, payload:payload );
    Logger.keyValueOff(tag,method, 'response',response);
    return "Not implemented yet";
  }

}
final class RegisterRemoteDataSrc extends RegisterRemoteDataSrcTemplate{
  @override
  Json createPayload(RegisterEntity entity) {
    // TODO: implement createPayload
    throw NotImplementedException();
  }

}