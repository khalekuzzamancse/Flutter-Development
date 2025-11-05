import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/feature/contact_list/data/entity/contact_entity.dart';
import 'package:snowchat_ios/feature/contact_list/data/repository/contact_repository.dart';

void main() {

  group('ContactEntity Parsing Tests', () {
    const className = 'ContactEntityTest';

    const jsonResponse = '''{
      "status": "success",
      "code": 200,
      "data": [
        {
          "id": 702,
          "first_name": "string",
          "last_name": "string",
          "mobile": "+8801738813865",
          "email": "md6@example.com",
          "image_url": "https://backend.snowtex.org/media/documents/2024/02/02/ic_launcher_foreground.png",
          "is_online": false,
          "last_seen": null,
          "created_at": "2024-11-29T12:06:35.337639+06:00"
        },
        {
          "id": 622,
          "first_name": "Shafin",
          "last_name": "Ahmed",
          "mobile": "+8801979387872",
          "email": "shafinahmed14dec@gmail.com",
          "image_url": "https://backend.snowtex.org/media/documents/2024/02/02/ic_launcher_foreground.png",
          "is_online": false,
          "last_seen": "2024-07-25T12:20:19.865020+06:00",
          "created_at": "2024-07-25T12:02:30.785734+06:00"
        }
      ],
      "message": null
    }''';

    test('ContactEntity parsing test', () async {
      const tag = '$className::ContactEntityParsing';

      try {

        final decodedJson = jsonDecode(jsonResponse);
        final contactData = decodedJson['data'] as List<dynamic>;


        final contacts = contactData.map((item) {
          return ContactEntity.fromJson(item as Map<String, dynamic>);
        }).toList();


        Logger.debug(tag, 'Parsed Contacts:');
        contacts.forEach((contact) {
          Logger.debug(tag, contact.toString());
        });

        expect(contacts.length, 2, reason: 'There should be 2 contact entities');
        expect(contacts[0].id, 702, reason: 'The first contact ID should be 702');
        expect(contacts[0].firstName, 'string', reason: 'The first name of the first contact should be "string"');
        expect(contacts[1].email, 'shafinahmed14dec@gmail.com', reason: 'The second contact email should be "shafinahmed14dec@gmail.com"');
      } catch (e) {
        Logger.debug(tag, 'ExceptionCause:$e');
        fail('Failed to parse the ContactEntity JSON');
      }
    });
  });


  group('ContactRepository Tests', () {

    const className = 'ContactRepositoryTest';
    const token = '448f0c70564a89a4e29abf4d1ba186ee5234c477';

    test('readContacts', () async {
      const tag = '$className::readContacts::Success';
      try {
        final contacts = await ContactRepository().readContacts(token);
        Logger.debug(tag, 'responseModel: $contacts');
      } catch (e) {
        fail('$tag: Exception thrown: $e');
      }
    });

    test('postContact', () async {
      const tag = '$className::postContactOrThrow::Success';
      try {
        final contacts = ['+8801738813865'];
        await ContactRepository().postContactOrThrow(contacts, token);
        Logger.debug(tag, 'Contact POST success');
      } catch (e) {
        fail('$tag: Exception thrown: $e');
      }
    });

  });
}
