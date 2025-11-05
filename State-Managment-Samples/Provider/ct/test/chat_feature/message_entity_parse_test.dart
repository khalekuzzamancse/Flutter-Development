import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/feature/chat/data/entity/message_entity.dart';

main() {


  test('MessageEntityParsing', () async {
    const tag = 'conversation_test:MessageTest:MessageEntityParsing:';
    const jsonResponse = '''
{
  "status": "success",
  "code": 200,
  "data": {
    "count": 6,
    "next": null,
    "previous": null,
    "results": [
      {
        "id": 2294,
        "sender": {
          "id": 683,
          "first_name": "Md",
          "last_name": "Khalekuzzaman1",
          "mobile": "+8801571378537",
          "email": "khalekuzzamancse@gmail.com",
          "image_url": "https://backend.snowtex.org/media/documents/2024/12/02/Linkdin_BG.png",
          "is_online": true,
          "last_seen": "2024-12-03T16:04:52.419579+06:00",
          "created_at": "2024-11-12T12:19:12.355164+06:00"
        },
        "attachments": [],
        "convo_type": 0,
        "convo_group_name": null,
        "created_at": "2024-12-03T16:04:52.408112+06:00",
        "updated_at": "2024-12-03T16:04:52.422293+06:00",
        "message": "repluy 123",
        "status": 0,
        "message_type": 0,
        "is_deleted": false,
        "conversation": 924,
        "sticker": null
      },
      {
        "id": 2293,
        "sender": {
          "id": 702,
          "first_name": "string",
          "last_name": "string",
          "mobile": "+8801738813865",
          "email": "md6@example.com",
          "image_url": "https://backend.snowtex.org/media/documents/2024/02/02/ic_launcher_foreground.png",
          "is_online": false,
          "last_seen": "2024-12-03T15:10:17.769359+06:00",
          "created_at": "2024-11-29T12:06:35.337639+06:00"
        },
        "attachments": [],
        "convo_type": 0,
        "convo_group_name": null,
        "created_at": "2024-12-03T15:10:17.743397+06:00",
        "updated_at": "2024-12-03T15:10:17.772783+06:00",
        "message": "123",
        "status": 2,
        "message_type": 0,
        "is_deleted": false,
        "conversation": 924,
        "sticker": null
      },
      {
        "id": 2292,
        "sender": {
          "id": 702,
          "first_name": "string",
          "last_name": "string",
          "mobile": "+8801738813865",
          "email": "md6@example.com",
          "image_url": "https://backend.snowtex.org/media/documents/2024/02/02/ic_launcher_foreground.png",
          "is_online": false,
          "last_seen": "2024-12-03T15:10:17.769359+06:00",
          "created_at": "2024-11-29T12:06:35.337639+06:00"
        },
        "attachments": [
         {
            "id": 650,
            "doc_url": "https://backend.snowtex.org/media/documents/2024/12/04/Screenshot_2024-12-04-12-10-29-136_com.google.android.gm.jpg",
            "created_at": "2024-12-04T14:50:14.645091+06:00",
            "updated_at": "2024-12-04T14:50:14.645114+06:00",
            "document": "http://backend.snowtex.org/media/documents/2024/12/04/Screenshot_2024-12-04-12-10-29-136_com.google.android.gm.jpg",
            "doc_type": 0,
            "owner": 702
          }
        ],
        "convo_type": 0,
        "convo_group_name": null,
        "created_at": "2024-12-03T14:56:05.349644+06:00",
        "updated_at": "2024-12-03T14:56:05.368681+06:00",
        "message": "bismillah",
        "status": 2
      }
    ]
  }
}
''';
    final decoded = jsonDecode(jsonResponse);
    Logger.debug(tag, 'decoded:$decoded');

    try {
      final messages = decoded['data']['results'] as List<dynamic>;
      for (final msg in messages) {
        final entity = MessageEntity.fromJsonOrThrow(msg);
        Logger.debug(tag, 'entity:$entity');
      }
    } catch (e) {
      fail('$tag:Exception thrown: $e');
    }
  });
}
