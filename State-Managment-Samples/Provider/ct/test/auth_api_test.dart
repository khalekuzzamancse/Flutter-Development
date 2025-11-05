import 'package:snowchat_ios/core/network/src/network_factory.dart';
import 'package:snowchat_ios/feature/auth/data/entity/login_response_entity.dart';
import 'package:test/test.dart';

void main() {
  group('API client test', () {

    test('login', () async {
      final client = NetworkFactory.createApiClient();
      const url = 'https://backend.snowtex.org/api/v1/auth/login/';
      final body = {
        "mobile": "+8801571378537",
        "password": "12345678"
      };

      try {
        final result = await client.postOrThrow(url, body);
        print(result);
        expect(result, isNotNull); // Ensure the result is not null
        expect(result, contains('id')); // Validate that the response contains an 'id'
      } catch (e) {
        fail('Exception thrown: $e');
      }
    });
    test('loginSuccessParseTest', () async {
      final client = NetworkFactory.createApiClient();
      const url = 'https://backend.snowtex.org/api/v1/auth/login/';
      final body = {
        "mobile": "+8801571378537",
        "password": "12345678"
      };

      try {
        final result = await client.postOrThrow(url, body);
        final parser = NetworkFactory.createJsonParser<LoginSuccessResponseEntity>();
        LoginSuccessResponseEntity response = parser.parseOrThrow(result, LoginSuccessResponseEntity.fromJson);
        print(response);
        expect(result, isNotNull);
      } catch (e) {
        fail('Exception thrown: $e');
      }
    });
    test('loginFailureResponse', () async {
      final client = NetworkFactory.createApiClient();
      const url = 'https://backend.snowtex.org/api/v1/auth/login/';
      final body = {
        "mobile": "+8801571378537",
        "password": "1234567"
      };

      try {
        final result = await client.postOrThrow(url, body);
        print(result);
        expect(result, isNotNull);
      } catch (e) {
        fail('Exception thrown: $e');
      }
    });

    test('loginFailureInvalidCredentialParser', () async {
      final client = NetworkFactory.createApiClient();
      const url = 'https://backend.snowtex.org/api/v1/auth/login/';
      final body = {
        "mobile": "+8801571378537",
        "password": "1234567"
      };
      try {
        final result = await client.postOrThrow(url, body);
        print(LoginErrorResponseParser.extractFailureMessage(result));

        expect(result, isNotNull);
      } catch (e) {
        fail('Exception thrown: $e');
      }
    });
    test('loginFailureUnRegisterPhoneParser', () async {
      final client = NetworkFactory.createApiClient();
      const url = 'https://backend.snowtex.org/api/v1/auth/login/';
      final body = {
        "mobile": "+88015713785",
        "password": "1234567"
      };
      try {
        final result = await client.postOrThrow(url, body);
        print(LoginErrorResponseParser.extractFailureMessage(result));

        expect(result, isNotNull);
      } catch (e) {
        fail('Exception thrown: $e');
      }
    });
  });
}
