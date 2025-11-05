part of 'api.dart';
abstract interface class ResetPasswordApi{
  Future<dynamic> resetPassword(String userId, String code, String password);
}