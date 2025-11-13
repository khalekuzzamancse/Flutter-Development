part of 'data_source.dart';
/// The abstract factory
abstract interface class ApiFactory{
  AccountApi get accountApi;
  ProductApi get productApi;
  static ApiFactory create(){
    return ApiFactoryMixed.create();
  }
}
class ApiFactoryRemote implements ApiFactory{
  ApiFactoryRemote._();
  static ApiFactory create(){
    return ApiFactoryRemote._();
  }
  @override
  AccountApi get accountApi => throw UnimplementedError();
  @override
  ProductApi get productApi => ProductRemoteDataSrc.create();

}
class ApiFactoryLocal implements ApiFactory{
  ApiFactoryLocal._();
  static ApiFactory create()=> ApiFactoryLocal._();
  @override
  AccountApi get accountApi => AccountLocalDataSource.create();
  @override
  ProductApi get productApi => ProductLocalDataSource.create();

}
class ApiFactoryMixed implements ApiFactory{
  ApiFactoryMixed._();
  static ApiFactory create()=> ApiFactoryMixed._();
  @override
  AccountApi get accountApi =>AccountLocalServer.create();
      //AccountLocalDataSource.create();
  @override
  ProductApi get productApi => ProductRemoteDataSrc.create();

}