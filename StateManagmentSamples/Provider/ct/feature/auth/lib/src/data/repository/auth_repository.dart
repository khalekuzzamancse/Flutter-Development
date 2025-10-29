

import 'dart:convert';

import 'package:auth/src/data/api/entity/code_verify_entitity.dart';
import 'package:auth/src/data/api/entity/entity_mapper.dart';
import 'package:auth/src/data/api/entity/login_response_entity.dart';
import 'package:auth/src/data/api/entity/register_response_entities.dart';
import 'package:auth/src/data/api/entity/server_generic_response.dart';
import 'package:auth/src/domain/domain.dart';
import 'package:auth/src/domain/user_model.dart';
import 'package:core/language/core_language.dart';
import 'package:core/network/core_network.dart';

import 'apis.dart';

class AuthRepository {
  final _client = NetworkClient.createBaseClient();
  final className = 'AuthRepository';

  //@formatter:off
  Future<UserModel> loginOrThrow(String mobile, String password) async {
    const tag='AuthRepository::login()';

    final payload = {"mobile": mobile, "password": password};
    // Logger.debug(tag, 'RequestJson=$requestJson');
    final response = await _client.postOrThrow(url:ApiEndpoints.LOGIN,payload: payload);
      //Logger.debug(tag, 'ResponseJson=$response');
      final entity=LoginResponseParser.parseOrThrow(jsonEncode(response));

      return AuthEntityMapper.toUserModel(entity);
      
  }

  Future<RegisterSuccessEntity> register(RegisterModel model) async {
    //TODO:as per the back-end right default country code=20(BD) and append +880 as +8801738....
    var request = model; //.copyWith(mobile:"+880${model.mobile}");
    //  print('AuthRepoRegisterMode:$actions.dart');
    final body = AuthEntityMapper.toRegisterEntity(request).toJson();
    //Logger.debug('$className::register::request', '$request');
    final response = await _client.postOrThrow(url:ApiEndpoints.SIGN_UP,payload: body );
    //Logger.debug('$className::register::jsonResponse', response);
    final parsedResponse = RegisterResponseParser.parseResponse(jsonEncode(response));
    return parsedResponse;
  }

  ///pass the number as: +8801571..., return the message from server,basically the success message
  Future<String> sendVerification(String mobile) async {
    //Logger.debug('$className::sendVerification::request', mobile);
    final response = await _client.postOrThrow(url:ApiEndpoints.resendVerification,payload: _createMobileJson(mobile));

   // Logger.debug('$className::sendVerification::jsonResponse', response);
    final parsed = ServerGenericResponseParser.parseOrThrow(jsonEncode(response));
    if (parsed.isSuccess) {
      return parsed.message ?? 'Success';
    } else {
      throw CustomException(
          message: 'Something is went wrong',
          debugMessage: '$className::sendVerification,response->$response');
    }
  }

  ///Return feedback message such as success, on failure throw custom exception
  Future<String> confirmVerification(String mobile, String code) async {
    final response = await _client.postOrThrow(url:ApiEndpoints.confirmVerification, payload: _createMobileAndCodeJson(mobile, code));

    //Logger.debug("AuthRepository:confirmVerification:", response);
    final parsedResponse = VerifyResponseParser.parseResponse(jsonEncode(response));
    return parsedResponse.message.isEmpty ? 'Success' : parsedResponse.message;
  }

  ///pass the number as: +8801571..., return the message from server,basically the success message
  Future<String> resetPassword(
      String mobile, String code, String password) async {
    const methodName='resetPassword()';
    final requestJson = {"mobile": mobile, "code": code, 'password': password};

    final response = await _client.postOrThrow(url:ApiEndpoints.resetPassword,payload: requestJson);

   // Logger.debug('$className::$methodName::jsonResponse', response);

    final parsed = ServerGenericResponseParser.parseOrThrow(jsonEncode(response));
    if (parsed.isSuccess) {
      return parsed.message ?? 'Success';
    } else {
      throw CustomException(
          message: 'Something is went wrong',
          debugMessage: '$className::$methodName,response->$response');
    }
  }

  Map<String, dynamic> _createMobileJson(String mobile) {
    return {
      "mobile": mobile,
    };
  }

  Map<String, dynamic> _createMobileAndCodeJson(String mobile, String code) {
    return {
      "mobile": mobile,
      "code": code,
    };
  }
}
