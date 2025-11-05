part of 'logic.dart';
abstract class AuthController{
  Future<dynamic> login(String userId,String password);
  Future<dynamic> register(RegisterModel model);
  void updateVerificationCodeId(String userId);
  Future<dynamic> sendVerificationCode();
  Future<dynamic> confirmVerification(String code);
  Future<dynamic> resetPassword(String userId, String code, String password);
}

