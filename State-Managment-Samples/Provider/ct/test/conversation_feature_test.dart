import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/core/network/socket/web_socket.dart';
import 'package:snowchat_ios/core/network/src/network_factory.dart';
import 'package:snowchat_ios/feature/chat/presentation/presentationLogic/conversation_controller.dart';
import 'package:snowchat_ios/feature/chat/data/repository/converstation_repository.dart';
import 'package:snowchat_ios/feature/di/global_controller.dart';



import 'core.dart';

main() {
  const token = '0526d6fabdf6eaea6c79cf03e5481b325d8da377';
  const useId = 683;


  test('core:networkTesting', () async {
    const tag = 'ConversationTesting::core:networkTesting:';
    final client = NetworkFactory.createApiClient();
    const url = 'https://backend.snowtex.org/api/v1/chat/mobile/conversation/';

    try {
      final json = await client.readWithTokenOrThrow(url, 'Token $token');
      Logger.debug(tag, 'readJson: $json');
      final decoded = jsonDecode(json);


    } catch (e) {
      fail('Exception thrown: $e');
    }
  });

  //@formatter:off
  group('RepositoryTest', () {
    test('chatListFromRepository', () async {
      const tag = 'ConversationTesting::chatListFromRepository';
      try {
        final models = await ConversationRepository().readConversation(token, 683,null);
        Logger.debug(tag, 'responseModel: $models');
      } catch (e) {
        fail('$tag:Exception thrown: $e');
      }
    });

    test('messageList', () async {
      const tag = 'conversation_feature_test::RepositoryTest::messageList';
      try {
        final models = await ConversationRepository().readMessages(await TestFactory.createTokenOrThrow(), 683,924,null);
        Logger.debug(tag, 'responseModel: $models');
      } catch (e) {
        fail('$tag:Exception thrown: $e');
      }
    });

  });

  test('controllerTest', () async {
    const tag = 'ConversationTesting::controllerTest';
    Get.put(GlobalController());
    Get.find<GlobalController>().updateAuthInfo(AuthInfo(token: token, currentUserId: 683));
    try {
      await ConversationController().read();
    } catch (e) {
      fail('$tag:Exception thrown: $e');
    }
  });
  // @formatter:off
group('MessageTest',(){

  test('MessageModelFromJson', () async {
    const tag = 'MessageModelFromJson:';
    const decodedJson = '''
  {
    "data": {
      "id": 2304,
      "sender": {
        "id": 683,
        "first_name": "Md",
        "last_name": "Khalekuzzaman1",
        "mobile": "+8801571378537",
        "email": "khalekuzzamancse@gmail.com",
        "image_url": "https://backend.snowtex.org/media/documents/2024/12/02/Linkdin_BG.png",
        "is_online": true,
        "last_seen": "2024-12-03T18:21:30.548434+06:00",
        "created_at": "2024-11-12T12:19:12.355164+06:00"
      },
      "attachments": [],
      "convo_type": 0,
      "convo_group_name": null,
      "created_at": "2024-12-03T18:21:30.538494+06:00",
      "updated_at": "2024-12-03T18:21:30.550611+06:00",
      "message": "1",
      "status": 0,
      "message_type": 0,
      "is_deleted": false,
      "conversation": 924,
      "sticker": null
    }
  }
  ''';

    try {
      final decoded = jsonDecode(decodedJson);
      Logger.debug(tag, 'decoded:$decoded');

      final model =SocketProtocol.toNewMsgOrNull(decoded,1);

      Logger.debug(tag, 'entity:$model');
    } catch (e) {
      fail('$tag:Exception thrown: $e');
    }
  });

});

}
