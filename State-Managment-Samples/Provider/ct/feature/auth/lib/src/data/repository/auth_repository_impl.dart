import 'package:core/language/core_language.dart';
import '../../domain/domain.dart';
import '../api/api.dart';
import '../api/api_factory.dart';

class AuthRepositoryImpl implements AuthRepository{
late final _loginApi=ApiFactory.create.loginApi();
late final _registerAPI=ApiFactory.create.registerApi();
late final _verifyApi=ApiFactory.create.verificationApi();
late final _resetPasswordApi=ApiFactory.create.resetPasswordApi();

@override
//@formatter:off
  Future<Pair<String,String>> loginOrThrow(String username, String password)=>_loginApi.loginOrThrow(username, password);

@override
Future<dynamic> registerOrThrow(RegisterModel model) async{
 await _registerAPI.registerOrThrow(
 RegisterEntity(firstName: model.firstName, lastName:model. lastName, email:model. email, mobile:model. mobile, password:model. password)
 );
}



  @override
  Future confirmVerification(String userId, String code)async {
   await _verifyApi.confirmVerification(userId, code);
  }

  @override
  Future isVerified(String userId) async{
        await _verifyApi.isVerified(userId);
  }
  @override
  Future resetPassword(String userId, String code, String password) async{
   await _resetPasswordApi.resetPassword(userId, code, password);
  }

  @override
  Future sendVerification(String userId) async{
        await  _verifyApi.sendVerification(userId);
  }
}
