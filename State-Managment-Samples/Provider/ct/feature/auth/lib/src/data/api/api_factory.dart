import '../remote_source/remote_data_source.dart';
import 'api.dart';
///The abstract factory
abstract class ApiFactory {
  LoginApi  loginApi();
  RegisterApi  registerApi();
  VerificationApi  verificationApi();
  ResetPasswordApi  resetPasswordApi();
  //Used such as so that client can call it as ApiFactory.create.loginApi()
  static final create=_RemoteFactory();
}
final class _RemoteFactory implements ApiFactory{
  @override
  RegisterApi  registerApi() =>RegisterRemoteDataSrc();
  @override
  LoginApi  loginApi() =>AuthDevsStreamSource.create();
  @override
  ResetPasswordApi  resetPasswordApi ()=>ResetPasswordRemoteDataSrc();
  @override
  VerificationApi  verificationApi() => VerificationRemoteDataSrc();
}

