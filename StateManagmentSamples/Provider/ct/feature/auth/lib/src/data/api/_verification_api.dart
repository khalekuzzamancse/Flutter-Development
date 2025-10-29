part of 'api.dart';

abstract interface class VerificationApi{
  ///user id may be phone or email or else based on client requirement
  Future<dynamic> isVerified(String userId);
  Future<dynamic> sendVerification(String userId);
  Future<dynamic> confirmVerification(String userId, String code);
}
