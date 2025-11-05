import 'dart:convert';
import 'package:snowchat_ios/core/domain/pagination_wrapper.dart';
import 'package:snowchat_ios/core/network/network.dart';
import 'package:snowchat_ios/feature/contact_list/data/entity/contact_entity_mapper.dart';
import 'package:snowchat_ios/feature/contact_list/domain/model/contact_model.dart';
import 'package:snowchat_ios/feature/group_chat/domain/actions.dart';

import '../../../../core/custom_exception/src/custom_exception.dart';
import '../../../../core/data/server_response.dart';
import '../../../../core/misc/logger.dart';
import '../../../../core/network/src/network_factory.dart';
import '../../contact_list/data/entity/contact_entity.dart';
import '../domain/group_creation_model.dart';

//@formatter:off
class GroupChatRepository {
  final _client = NetworkFactory.createApiClient();
  final className = 'GroupChatRepository';
  static const int _generalUser=0;

  Future<PaginationWrapper<List<ContactModel>>> readMembersPagination(int conversationId, String token,String?paginationUrl) async{
    final tag = '$className::readMembers()';
    if(paginationUrl==null){
      return PaginationWrapper(data: <ContactModel>[],next: null);
    }
    final url = replaceHttpWithHttps(paginationUrl);
    return _readContact(url, conversationId, token, tag);
  }


  Future<PaginationWrapper<List<ContactModel>>> readMembers(int conversationId, String token,String?paginationUrl) {
    final tag = '$className::readMembers()';
    final url = replaceHttpWithHttps(paginationUrl ?? 'https://backend.snowtex.org/api/v1/chat/mobile/conversation/$conversationId/group_contacts/');
    return _readContact(url, conversationId, token, tag);
  }

  ///on success return the conversationId or throw custom Exception
  Future<int> createGroupOrThrow({required GroupCreationModel model, required String token}) async {
    final tag = '$className::createGroup()';
    const url = 'https://backend.snowtex.org/api/v1/chat/mobile/conversation/';
    final request = _groupCreationModelToMap(model);
    Logger.debug(tag, 'request:$request');
    try {
      Logger.debug(tag, 'requestToken=$token');
      final response = await _client.postWithTokenOrThrow(url, 'Token $token',request);
      Logger.debug(tag, 'Response=$response');
      final responseEntity = ServerResponse.fromJsonOrThrow(jsonDecode(response));

      if (responseEntity.isSuccess) {
        return 0; //TODO:
      }
      // If failure
      throw CustomException(message: responseEntity.errorMessage ?? 'Something went wrong', debugMessage: 'src:$tag');
    } catch (e,stackStrace) {
      Logger.errorWithTrace(tag, stackStrace);
      throw toCustomException(exception: e, fallBackDebugMsg: 'src=$tag,error=$e');
    }
  }
  //return the success message
  ///add as general member(not as admin)
  Future<String> modifyMember({required int conversationId, required List<int> members,required ActionType action, required String token}) async {
    final tag = '$className::addMembersAsync()';
    final url = 'https://backend.snowtex.org/api/v1/chat/mobile/conversation/$conversationId/manage-user/';
    final request = _createManageUserRequest(
        users: members,
        action: action==(ActionType.add)?0:1,//Right now support only two action, 0=add, 1=remove
        role: _generalUser);
    Logger.debug(tag, 'action:$action,request:$request');
    try {
      Logger.debug(tag, 'requestToken=$token');
      final response = await _client.postWithTokenOrThrow(url, 'Token $token',request);
      Logger.debug(tag, 'Response=$response');
      final responseEntity = ServerResponse.fromJsonOrThrow(jsonDecode(response));

      if (responseEntity.isSuccess) {
        return 'Success';
      }
      // If failure
      throw CustomException(message: responseEntity.errorMessage ?? 'Something went wrong', debugMessage: 'src:$tag');
    } catch (e,stackStrace) {
      Logger.errorWithTrace(tag, stackStrace);
      throw  toCustomException(exception: e, fallBackDebugMsg: 'source:$tag');

    }
  }

  ///role=1 for admin, 0 for general user
  ///action 0=add , 1=remove
  Map<String, dynamic> _createManageUserRequest({required List<int> users, required int action, required int role}) {
    return {
      "users": users,
      "action_type": action,
      "role_type": role,
    };

  }

  Future<PaginationWrapper<List<ContactModel>>> readAdminPaginated(int conversationId, String token,String?paginationUrl)async {
    final tag = '$className::readAdmins()';
    if(paginationUrl==null){
      return PaginationWrapper(data: [],next: null);
    }
    final url = replaceHttpWithHttps(paginationUrl);
    return _readContact(url, conversationId, token, tag);
  }
  Future<PaginationWrapper<List<ContactModel>>> readAdmins(int conversationId, String token,String?paginationUrl) {
    final tag = '$className::readAdmins()';
    final url = replaceHttpWithHttps(paginationUrl ?? 'https://backend.snowtex.org/api/v1/chat/mobile/conversation/$conversationId/group_admins/');
    return _readContact(url, conversationId, token, tag);
  }

  //@formatter:off
  ///Read all the member

  Future<PaginationWrapper<List<ContactModel>>> _readContact(String url, int conversationId, String token,String tag) async {
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
        final entities = (data['results'] as List).map((contactJson) {
          return ContactEntity.fromJson(contactJson as Map<String, dynamic>);
        }).toList();
        Logger.debug(tag, 'entities=$entities');
        final models=entities.map(ContactEntityMapper.fromContactEntityToModel).toList();
        Logger.debug(tag, 'models=$models');
        //Using safe access to avoid causing exception a field that may not exits
        final String? next=data.containsKey('next')?data['next']:null;
        return PaginationWrapper(data: models,next: next);
      }
      // If failure
      throw CustomException(message: responseEntity.errorMessage ?? 'Something went wrong', debugMessage: tag);
    } catch (e) {
      throw  toCustomException(exception: e, fallBackDebugMsg: 'source:$tag');
    }
  }
  Map<String, dynamic> _groupCreationModelToMap(GroupCreationModel model) {
    return {
      "group_name": model.name,
      "convo_type": 1,
      "group_image": model.imageId,
      'is_active':true,
      "users": model.membersId,
      "admins": [],
    };
  }
  String replaceHttpWithHttps(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}
