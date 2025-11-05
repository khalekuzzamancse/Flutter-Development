import 'dart:convert';
import 'package:snowchat_ios/core/network/network.dart';
import 'package:snowchat_ios/feature/contact_list/data/entity/contact_entity_mapper.dart';
import 'package:snowchat_ios/feature/contact_list/domain/model/contact_model.dart';

import '../../../../core/custom_exception/src/custom_exception.dart';
import '../../../../core/data/server_response.dart';
import '../../../../core/misc/logger.dart';
import '../../../../core/network/src/network_factory.dart';
import '../entity/contact_entity.dart';

class ContactRepository {
  final _client = NetworkFactory.createApiClient();
  final className = 'ContactRepository';

  //pass list mobile no
  Future<void> postContactOrThrow(List<String> contacts,String token) async{
    final tag = '$className::postContactOrThrow()';
    const url = 'https://backend.snowtex.org/api/v1/chat/mobile/contact/';

    String response = '';
    try {
      Logger.debug(tag, 'requestToken=$token');
      final convertedData=_toMobileNumbersMap(contacts);
      Logger.debug(tag, 'convertedData=$convertedData');
      response = await _client.postWithTokenOrThrow(url, 'Token $token',convertedData);
      Logger.debug(tag, 'Response=$response');
      final responseEntity = ServerResponse.fromJsonOrThrow(jsonDecode(response));
      Logger.debug(tag, 'isSuccess=${responseEntity.isSuccess}');

      if (responseEntity.isSuccess) return;


      throw CustomException(message: responseEntity.errorMessage ?? 'Something went wrong', debugMessage: tag);
    } catch (e) {
      throw  toCustomException(exception: e, fallBackDebugMsg: 'source:$tag');
    }
  }
  Map<String, dynamic> _toMobileNumbersMap(List<String> contacts) {
    // return {
    //   "mobile_numbers": ['01571378537'],
    // };
    return {
      "mobile_numbers": contacts.map((contact) => contact).toList(),
    };
  }

  //@formatter:off
  Future<List<ContactModel>> readContacts(String token) async {
    final tag = '$className::readContacts()';
    const url = 'https://backend.snowtex.org/api/v1/chat/mobile/contact/';

    String response = '';
    try {
      Logger.debug(tag, 'requestToken=$token');
      response = await _client.readWithTokenOrThrow(url, 'Token $token');

      Logger.debug(tag, 'Response=$response');
      final responseEntity = ServerResponse.fromJsonOrThrow(jsonDecode(response));
      Logger.debug(tag, 'isSuccess=${responseEntity.isSuccess}');
      final data = responseEntity.data;
      Logger.debug(tag, 'data=$data');

      if (responseEntity.isSuccess) {
        final entities = (data as List).map((contactJson) {
         return ContactEntity.fromJson(contactJson as Map<String, dynamic>);
        }).toList();
        Logger.debug(tag, 'entities=$entities');
        final models=entities.map(ContactEntityMapper.fromContactEntityToModel).toList();
        Logger.debug(tag, 'models=$models');
        return models;
      }
      // If failure
      throw CustomException(message: responseEntity.errorMessage ?? 'Something went wrong', debugMessage: tag);
    } catch (e) {
      throw  toCustomException(exception: e, fallBackDebugMsg: 'source:$tag');
    }
  }
}
