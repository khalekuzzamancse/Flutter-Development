import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/feature/chat/data/entity/base_conversation_entity.dart';
import 'package:snowchat_ios/feature/chat/data/entity/conversation_entity_parser.dart';

main(){


  test('ConversationEntityParsing', () async {
    const tag = 'ConversationEntityParsing:';
    const jsonResponse = '''
    {
  "status": "success",
  "code": 200,
  "data": {
    "count": 4,
    "next": null,
    "previous": null,
    "results": [
      {
        "id": 924,
        "group_name": null,
        "group_image": null,
        "convo_type": 0,
        "is_active": true,
        "last_message": {
          "id": 2497,
          "sender": {
            "id": 683,
            "first_name": "Md",
            "last_name": "Khalekuzzaman1",
            "mobile": "+8801571378537",
            "email": "khalekuzzamancse@gmail.com",
            "image_url": "https://backend.snowtex.org/media/documents/2024/12/02/Linkdin_BG.png",
            "is_online": false,
            "last_seen": "2024-12-05T20:43:05.182086+06:00",
            "created_at": "2024-11-12T12:19:12.355164+06:00"
          },
          "attachments": [],
          "convo_type": 0,
          "convo_group_name": null,
          "created_at": "2024-12-05T20:43:05.171353+06:00",
          "updated_at": "2024-12-05T20:43:05.183733+06:00",
          "message": "tyt",
          "status": 2,
          "message_type": 0,
          "is_deleted": false,
          "conversation": 924,
          "sticker": null
        },
        "unseen_count": 0,
        "receiver": {
          "id": 683,
          "first_name": "Md",
          "last_name": "Khalekuzzaman1",
          "mobile": "+8801571378537",
          "email": "khalekuzzamancse@gmail.com",
          "image_url": "https://backend.snowtex.org/media/documents/2024/12/02/Linkdin_BG.png",
          "is_online": false,
          "last_seen": "2024-12-05T20:43:05.182086+06:00",
          "created_at": "2024-11-12T12:19:12.355164+06:00"
        },
        "user_role": 0,
        "members_count": 2,
        "admin_name": "",
        "created_at": "2024-12-03T11:59:25.199850+06:00"
      },
      {
        "id": 933,
        "group_name": null,
        "group_image": null,
        "convo_type": 0,
        "is_active": true,
        "last_message": null,
        "unseen_count": 0,
        "receiver": {
          "id": 620,
          "first_name": "Radwan",
          "last_name": "Hossain",
          "mobile": "+8801795838487",
          "email": "mdradwanhossain21@gmail.com",
          "image_url": "https://backend.snowtex.org/media/documents/2024/02/02/ic_launcher_foreground.png",
          "is_online": false,
          "last_seen": "2024-11-19T15:47:56.090799+06:00",
          "created_at": "2024-07-24T23:34:57.886087+06:00"
        },
        "user_role": 0,
        "members_count": 2,
        "admin_name": "",
        "created_at": "2024-12-04T14:34:45.849409+06:00"
      },
      {
        "id": 932,
        "group_name": null,
        "group_image": null,
        "convo_type": 0,
        "is_active": true,
        "last_message": null,
        "unseen_count": 0,
        "receiver": {
          "id": 622,
          "first_name": "Shafin",
          "last_name": "Ahmed",
          "mobile": "+8801979387872",
          "email": "shafinahmed14dec@gmail.com",
          "image_url": "https://backend.snowtex.org/media/documents/2024/02/02/ic_launcher_foreground.png",
          "is_online": false,
          "last_seen": "2024-07-25T12:20:19.865020+06:00",
          "created_at": "2024-07-25T12:02:30.785734+06:00"
        },
        "user_role": 0,
        "members_count": 2,
        "admin_name": "",
        "created_at": "2024-12-04T14:34:42.971294+06:00"
      },
      {
        "id": 920,
        "group_name": "ABC",
        "group_image": 632,
        "convo_type": 1,
        "is_active": true,
        "group_image_url": "https://backend.snowtex.org/media/documents/2024/11/22/IMG_Fri_Nov_22_17_53_30_GMT06_00_2024.jpg",
        "last_message": {
          "id": 2370,
          "sender": {
            "id": 702,
            "first_name": "string",
            "last_name": "string",
            "mobile": "+8801738813865",
            "email": "md6@example.com",
            "image_url": "https://backend.snowtex.org/media/documents/2024/02/02/ic_launcher_foreground.png",
            "is_online": true,
            "last_seen": "2024-12-05T20:21:26.996095+06:00",
            "created_at": "2024-11-29T12:06:35.337639+06:00"
          },
          "attachments": [],
          "convo_type": 1,
          "convo_image_url": "https://backend.snowtex.org/media/documents/2024/11/22/IMG_Fri_Nov_22_17_53_30_GMT06_00_2024.jpg",
          "convo_group_name": "ABC",
          "created_at": "2024-12-04T14:15:00.060890+06:00",
          "updated_at": "2024-12-04T14:15:00.074774+06:00",
          "message": "14 2",
          "status": 2,
          "message_type": 0,
          "is_deleted": false,
          "conversation": 920,
          "sticker": null
        },
        "unseen_count": 0,
        "receiver": null,
        "user_role": 0,
        "members_count": 2,
        "admin_name": "Md Khalekuzzaman1",
        "created_at": "2024-11-22T17:53:38.353624+06:00"
      }
    ]
  },
  "message": null
}
    ''';

    final decoded = jsonDecode(jsonResponse);
    Logger.debug(tag, 'decoded:$decoded');
    final List<ConversationEntity> results =
    (decoded['data']['results'] as List)
        .map((result) => ConversationEntityParser.fromJsonOrThrow(result, 683))
        .toList();
    for(final entity in results){
      Logger.debug(tag, '$entity');
    }

  });
}