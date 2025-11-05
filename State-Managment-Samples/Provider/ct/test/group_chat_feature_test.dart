import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/feature/contact_list/data/entity/contact_entity.dart';
import 'package:snowchat_ios/feature/contact_list/data/repository/contact_repository.dart';
import 'package:snowchat_ios/feature/di/global_controller.dart';
import 'package:snowchat_ios/feature/group_chat/data/group_chat_repository.dart';
import 'package:snowchat_ios/feature/group_chat/presentation/presentationLogic/group_chat_controller.dart';

void main() {


  group('GroupChatFeatureRepositoryTest', () {
    const className = 'GroupChatFeatureRepositoryTest';
    const token = '699d3154d9707939b50111c74f8d8ca19ff80f49';

    test('readMembers', () async {
      const tag = '$className::readMembers';
      const conversationId=920;
      try {
        final contacts = await GroupChatRepository().readMembers(conversationId,token,null);
        Logger.debug(tag, 'responseModel: $contacts');
      } catch (e) {
        fail('$tag: Exception thrown: $e');
      }
    });
    test('readAdmins', () async {
      const tag = '$className::readAdmins';
      const conversationId=920;
      try {
        final contacts = await GroupChatRepository().readAdmins(conversationId,token,null);
        Logger.debug(tag, 'responseModel: $contacts');
      } catch (e) {
        fail('$tag: Exception thrown: $e');
      }
    });


  });
  group('GroupChatFeatureControllerTest', () {
    const className = 'GroupChatFeatureControllerTest';
    const token = 'bf10a86522fbceeb15343f43af48520b14a7e657';

    test('readMembers', () async {
      Get.put(GlobalController());
      Get.find<GlobalController>().authInfo=AuthInfo(token: token, currentUserId: 1);

      const tag = '$className::readMembers';
      const conversationId=920;
      try {
         // await GroupChatController(conversationId).readMemberAsync(conversationId);
      } catch (e) {
        fail('$tag: Exception thrown: $e');
      }
    });

    test('readAdmins', () async {
      Get.put(GlobalController());
      Get.find<GlobalController>().authInfo=AuthInfo(token: token, currentUserId: 1);

      const tag = '$className::readAdmins';
      const conversationId=920;
      try {
       // await GroupChatController(conversationId).readAdminsAsync(conversationId);
      } catch (e) {
        fail('$tag: Exception thrown: $e');
      }
    });


  });
}
