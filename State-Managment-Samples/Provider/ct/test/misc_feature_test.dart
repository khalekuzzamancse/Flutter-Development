import 'package:flutter_test/flutter_test.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/feature/misc/data/misc_info_repository.dart';

main(){
  group('MiscInfoRepository Tests', () {
    const className = 'MiscInfoRepositoryTest';

    test('readPrivacyPolicy', () async {
      const tag = '$className::readPrivacyPolicy';
      try {
        final entity = await MiscInfoRepository().readPrivacyPolicy();
        Logger.debug(tag, 'responseModel: $entity');
      } catch (e) {
        fail('$tag: Exception thrown: $e');
      }
    });

  });
}