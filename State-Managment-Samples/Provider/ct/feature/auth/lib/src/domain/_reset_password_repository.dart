part of 'domain.dart';
abstract interface class ResetPasswordRepository{
  Future<dynamic> resetPassword(String userId, String code, String password);
}