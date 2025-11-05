part of 'domain.dart';
abstract interface class LoginRepository{
  Future<dynamic> loginOrThrow(String username,String password);
}