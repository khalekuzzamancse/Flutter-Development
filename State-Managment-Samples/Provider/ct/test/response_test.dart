import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:snowchat_ios/core/custom_exception/custom_exception.dart';
import 'package:snowchat_ios/core/data/server_response.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/core/network/src/network_factory.dart';

import 'package:snowchat_ios/feature/auth/data/entity/login_response_entity.dart';
import 'package:snowchat_ios/feature/auth/data/entity/register_response_entities.dart';
import 'package:snowchat_ios/feature/auth/data/entity/server_generic_response.dart';
import 'package:snowchat_ios/feature/auth/data/repository/apis.dart';
import 'package:snowchat_ios/feature/auth/data/repository/auth_repository.dart';
import 'package:snowchat_ios/feature/auth/domain/model/register_model.dart';

void main() {

  group('ResponseTest', () {
    final client = NetworkFactory.createApiClient();
    test('parsingTest', () async {
      const tag = 'ResponseTest::parsingTest';
      final responseJson = {
        "status": "error",
        "code": 400,
        "data": null,
        "message": "Invalid login credentials",
        "errors": {}
      };

      final entity = ServerResponse.fromJsonOrThrow(responseJson);
      Logger.debug(tag, 'ParsedResponse::isSuccess={${entity.isSuccess}}');
      Logger.debug(tag, 'ParsedResponse::isFailure={${entity.isFailure}}');
      Logger.debug(tag, 'ParsedResponse::errorMessages={${entity.errorMessage}}');
      Logger.debug(tag, 'ParsedResponse::successMessage={${entity.successMessage}}');
      Logger.debug(tag, 'ParsedResponse::data={${entity.data}}');
    });

    test('login', () async {
      const tag='ResponseTest::login';
      final requestJson = {"mobile": '+8801571378537', "password":'87654321'};
      final responseJson = await client.postOrThrow(ApiEndpoints.LOGIN, requestJson);
      final decoded=jsonDecode(responseJson);
      Logger.debug(tag, 'ResponseJson=$responseJson');
      final entity=ServerResponse.fromJsonOrThrow(decoded);
      Logger.debug(tag, 'ParsedResponse::isSuccess={${entity.isSuccess}}');
      Logger.debug(tag, 'ParsedResponse::errorMessages={${entity.errorMessage}}');
      Logger.debug(tag, 'ParsedResponse::successMessage={${entity.successMessage}}');
      Logger.debug(tag, 'ParsedResponse::data={${entity.data}}');
    });


  });


}
