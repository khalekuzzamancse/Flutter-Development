import 'package:snowchat_ios/core/data/server_response.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:test/test.dart';

void main() {

  group('ErrorHelper Tests', () {
    const classname = 'ErrorHelperTest';

    test('errorHelper', () {
      const tag = '$classname::testWithErrors';
      const errorJson = '''
        "email": ["user with this email already exists."],
        "mobile": "user with this mobile already exists.",
        "country": ["Invalid pk "0" - object does not exist."]
      ''';

      try {
        final errorHelper = ErrorHelper(errorJson);
        final result = errorHelper.parseErrors();
        Logger.debug(tag, 'result: $result');
      } catch (e) {
        Logger.debug(tag, 'ExceptionCause: $e');
      }
    });

    test('test for non array', () {
      const tag = '$classname::testWithErrors';
      const errorJson = '''
        {"email": "user with this email already exists.",
        "mobile": "user with this mobile already exists.",
        "country": "Invalid pk "0" - object does not exist."
        }
      ''';

      try {
        final errorHelper = ErrorHelper(errorJson);
        final result = errorHelper.parseErrors();
        Logger.debug(tag, 'result: $result'); // Logging the result
      } catch (e) {
        Logger.debug(tag, 'ExceptionCause: $e');
      }
    });
    test('should return null when there are no error messages', () {
      const tag = '$classname::testNoErrors';
      const errorJson = '';

      try {
        final errorHelper = ErrorHelper(errorJson);
        final result = errorHelper.parseErrors();
        Logger.debug(tag, 'result: $result'); // Logging the result
        expect(result, null); // Expect null because no error exists
      } catch (e) {
        Logger.debug(tag, 'ExceptionCause: $e');
      }
    });

    test('should return null when errors are missing', () {
      const tag = '$classname::testErrorsMissing';
      const errorJson = null;

      try {
        final errorHelper = ErrorHelper(errorJson);
        final result = errorHelper.parseErrors();
        Logger.debug(tag, 'result: $result'); // Logging the result
        expect(result, null); // Expect null because there are no errors
      } catch (e) {
        Logger.debug(tag, 'ExceptionCause: $e');
      }
    });
  });
}
