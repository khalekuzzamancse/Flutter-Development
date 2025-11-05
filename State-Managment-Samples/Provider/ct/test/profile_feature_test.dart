import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/core/custom_exception/custom_exception.dart';
import 'package:snowchat_ios/core/data/server_response.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/core/network/src/network_factory.dart';

import 'package:snowchat_ios/feature/auth/data/entity/login_response_entity.dart';
import 'package:snowchat_ios/feature/auth/data/entity/profile_update_entity.dart';
import 'package:snowchat_ios/feature/auth/data/entity/register_response_entities.dart';
import 'package:snowchat_ios/feature/auth/data/entity/server_generic_response.dart';
import 'package:snowchat_ios/feature/auth/data/repository/apis.dart';
import 'package:snowchat_ios/feature/auth/data/repository/auth_repository.dart';
import 'package:snowchat_ios/feature/profile_management/data/profile_repository.dart';
import 'package:snowchat_ios/feature/auth/domain/model/register_model.dart';
import 'package:snowchat_ios/feature/profile_management/presentation/presentation_logic/profile_controller.dart';
import 'package:snowchat_ios/feature/di/global_controller.dart';

import 'core.dart';

void main() {
  const className = 'ProfileRepositoryTest';
  const token = '4b6955f5fb2d5457113cf3d150fe31fb9ac12bb8';
  test('readProfile', () async {
    const tag = '$className::readProfile';
    // ProfileRepository().readProfile(id);
  });

  //@formatter:off
    test('profileRepoTest', () async {
      const tag='$className::profileRepoTest';
      try {
        final models = await ProfileRepository().readProfile(token);
        Logger.debug(tag, 'responseModel: $models');
      } catch (e) {
        fail('$tag:Exception thrown: $e');
      }

    });
    test('controllerTest', () async {
      const tag = '$className::controllerTest';
    final controller=  Get.put(GlobalController());
      controller.updateAuthInfo(AuthInfo(token: token, currentUserId: 683));
      try {
        await ProfileController().read();
      } catch (e) {
        fail('$tag:Exception thrown: $e');
      }
    });

  group('UpdateProfileEntity::test', () {
    test('jsonTest', () async {
      const tag = 'UpdateProfileEntity::jsonTest::Success';
      try {
        final profile = EditProfileEntity(
          firstName: 'John',
          lastName: 'Doe',
          bio: 'Some bio',
          website: 'https://example.com',
        );
        final jsonString = profile.json();
        Logger.debug(tag, 'jsonString: $jsonString');
      } catch (e) {
        fail('$tag: Exception thrown: $e');
      }
    });

    test('toJsonTest', () async {
      const tag = 'UpdateProfileEntity::toJsonTest::Success';
      try {
        final profile = EditProfileEntity(
          firstName: 'Jane',
          lastName: 'Doe',
        );
        final jsonMap = profile.toJson();
        Logger.debug(tag, 'jsonMap: $jsonMap');
      } catch (e) {
        fail('$tag: Exception thrown: $e');
      }
    });

    test('toStringTest', () async {
      const tag = 'UpdateProfileEntity::toStringTest::Success';
      try {
        final profile = EditProfileEntity(
          firstName: 'Alice',
          lastName: 'Smith',
          bio: 'A bio',
        );
        final profileString = profile.toString();
        Logger.debug(tag, 'profileString: $profileString');
      } catch (e) {
        fail('$tag: Exception thrown: $e');
      }
    });
  });

  test('editProfileTest', () async {
    const tag = 'EditProfileRepositoryTest::editProfile';
    try {
      final profile = EditProfileEntity(
        firstName: 'John',
        lastName: 'Doe',
        bio: 'Developer',
        website: 'https://john.doe.com',
      );

      final result = await ProfileRepository().editProfile(profile, token);
      Logger.debug(tag, 'result: $result');
    } catch (e) {
      fail('$tag: Exception thrown: $e');
    }
  });

group('ProfileControllerTest', (){
  const className='ProfileControllerTest';

  test('uploadImage', () async {
    const tag = '$className::uploadImage';
    final token= await TestFactory.createTokenOrThrow();
    const path= "C:\\Users\\Khalekuzzaman\\Downloads\\test_optimized_1.png";
    try {
      Get.put(GlobalController());
      Get.find<GlobalController>().authInfo=AuthInfo(token: token, currentUserId: 1);
      await ProfileController().uploadProfileImage(path);

    } catch (e) {
      fail('$tag: Exception thrown: $e');
    }
  });

  test('editProfile', () async {
    const tag = 'ProfileControllerTest::editProfile';
    try {
      final profile = EditProfileEntity(
        firstName: 'John34',
        lastName: 'Doe',
        bio: 'Developer',
        website: 'https://john.doe.com',
      );
      Get.put(GlobalController());
     Get.find<GlobalController>().authInfo=AuthInfo(token: token, currentUserId: 1);
     await ProfileController().editProfile(profile);

    } catch (e) {
      fail('$tag: Exception thrown: $e');
    }
  });

});


}
