part of 'domain.dart';
abstract interface class VerificationRepository{
  ///user id may be phone or email or else based on client requirement
  Future<dynamic> isVerified(String userId);
  Future<dynamic> sendVerification(String userId);
  Future<dynamic> confirmVerification(String userId, String code);
}
