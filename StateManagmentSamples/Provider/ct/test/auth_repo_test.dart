import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:snowchat_ios/core/custom_exception/custom_exception.dart';
import 'package:snowchat_ios/core/misc/logger.dart';

import 'package:snowchat_ios/feature/auth/data/entity/login_response_entity.dart';
import 'package:snowchat_ios/feature/auth/data/entity/register_response_entities.dart';
import 'package:snowchat_ios/feature/auth/data/repository/auth_repository.dart';
import 'package:snowchat_ios/feature/auth/domain/model/register_model.dart';

void main() {
  final authRepository = AuthRepository();

  const classname = 'AuthRepositoryTest';

  test('login', () async {
    const tag = '$classname::login';
    const mobile = "+8801571378537"; //  "+8801738813865";
    const password = "87654321";
    try {
      final result = await authRepository.login(mobile, password);
      Logger.debug(tag, 'result:$result');
    } catch (e) {
      Logger.debug(tag, 'ExceptionCause:$e');
    }
  });

  //@formatter:off
  test('LoginSuccessResponseParsing', () async {
    const tag = 'LoginSuccessResponseParsing:';
    const jsonResponse = '''
  {"id":702,"first_name":"string","last_name":"string","email":"md6@example.com",
  "mobile":"+8801738813865","image":"https://backend.snowtex.org/media/documents/2024/02/02/ic_launcher_foreground.png","gender":0,"is_approved":true,"is_verified":false,"is_staff":false,"is_superuser":false,"token":"sample_token"}
  ''';
    final decoded=jsonDecode(jsonResponse);
    Logger.debug(tag, 'decoded:$decoded');
      final entity = LoginSuccessResponseEntity.fromJson(decoded);
    Logger.debug(tag, 'entity:$entity');
      expect(entity.id, 702);
      expect(entity.firstName, "string");
      expect(entity.lastName, "string");
      expect(entity.email, "md6@example.com");
      expect(entity.mobile, "+8801738813865");
      expect(entity.image, "https://backend.snowtex.org/media/documents/2024/02/02/ic_launcher_foreground.png");
      expect(entity.isVerified, false);
      expect(entity.token, "sample_token");

  });

  test('register success', () async {
    final model = RegisterModel(
      firstName: "John",
      lastName: "Doe",
      email: "john1.doe@example.com",
      mobile: "1738813865",
      password: "string",
      confirmPassword: "string",
    );
    try {
      final result = await authRepository.register(model);
      print(result);
      expect(result, isA<RegisterSuccessEntity>());
      expect(result.isSuccess, true);
    } catch (e) {
      fail('Expected a success response, but got an exception: $e');
    }
  });

  test('register failure user already exists', () async {
    final model = RegisterModel(
      firstName: "John",
      lastName: "Doe",
      email: "existing.user@example.com",
      // Simulating an existing user
      mobile: "+8801571378522",
      password: "12345678",
      confirmPassword: "12345678",
    );

    try {
      await authRepository.register(model);
      fail('Expected a CustomException but got success');
    } catch (e) {
      if (e is CustomException) {
        print('Actual Error Message: ${e.message}');
      } else {
        print('Unexpected Exception: $e');
      }
      expect(e, isA<CustomException>());
    }
  });

  test('register failure invalid data', () async {
    final model = RegisterModel(
      firstName: "John",
      lastName: "Doe",
      email: "invalid.email",
      // Invalid email format
      mobile: "1571378500",
      password: "12345678",
      confirmPassword: "12345678",
    );

    try {
      await authRepository.register(model);
      fail('Expected a CustomException but got success');
    } catch (e) {
      if (e is CustomException) {
        print('Actual Error Message: ${e.message}');
      } else {
        print('Unexpected Exception: $e');
      }
      expect(e, isA<CustomException>());
    }
  });

  test('confirmVerification ', () async {
    try {
      final repository = AuthRepository();
      final response =
          await repository.confirmVerification("+8801571378537", "113140");
      print("Response: $response"); // This will print the success message
    } catch (e) {
      fail('Expected success but caught an exception: $e');
    }
  });
}
