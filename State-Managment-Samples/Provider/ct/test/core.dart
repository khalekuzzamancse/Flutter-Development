import 'package:snowchat_ios/core/custom_exception/custom_exception.dart';
import 'package:snowchat_ios/feature/auth/data/repository/auth_repository.dart';

class TestFactory{
  static createTokenOrThrow() async{
    const mobile = "+8801571378537"; //  "+8801738813865";
    const password = "87654321";
      final result = await AuthRepository().login(mobile, password);
      if(result.token==null) {
        throw CustomException(message: 'Token is null ', debugMessage: 'TestFactory::createTokenOrThrow');
      }
      return result.token!;

  }
}