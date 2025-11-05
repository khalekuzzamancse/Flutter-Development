import 'dart:convert';
import 'package:snowchat_ios/core/network/network.dart';
import 'package:snowchat_ios/feature/chat/data/entity/base_conversation_entity.dart';
import 'package:snowchat_ios/feature/chat/data/entity/conversation_entity_parser.dart';
import 'package:snowchat_ios/feature/chat/data/entity/message_entity.dart';
import '../../../../core/domain/pagination_wrapper.dart';
import '../../../../core/misc/logger.dart';
import '../../../../core/network/src/network_factory.dart';
import '../../domain/model/message_model.dart';
import '../../domain/model/conversation_model.dart';
import '../entity/mapper.dart';
//@formatter:off
class ConversationRepository {
  final className = "ConversationRepository";


  Future<PaginationWrapper<List<ConversationModel>>> readConversation(String token, int userId,String? paginationUrl) async {
    final tag = '$className:readConversation:';
    try{
      final client = NetworkFactory.createApiClient();
      final url = replaceHttpWithHttps(paginationUrl ?? 'https://backend.snowtex.org/api/v1/chat/mobile/conversation/');

      Logger.debug(tag, 'request={token:$token,userId:$userId}');
      final response = await client.readWithTokenOrThrow(url, 'Token $token');

      Logger.debug(tag, 'response: $response');
      final decoded = jsonDecode(response);


      Logger.debug(tag, 'decoded: $decoded');

      //If we do not handle exception for each entity while parsing then if any one of
      //entity parse fail then entire will causes exception as result user will not see any item
      //even the other items may be parsed successfully
      final  parsedEntity = (decoded['data']['results'] as List)
          .map((result)=> _parseOrNull(result,userId))
          .where((conversation) => conversation != null)
          .cast<ConversationEntity>()
          .toList();
      Logger.debug(tag, 'ParsedEntity: $parsedEntity');
      final Map<String,dynamic> data=decoded['data'];



      //Using safe access to avoid causing exception a field that may not exits
      final String? next=data.containsKey('next')?data['next']:null;
      return PaginationWrapper(data: ConversationEntityMapper.toModel2(parsedEntity), next: next);
    }
    catch(e){
      throw  toCustomException(exception: e, fallBackDebugMsg: 'source:$tag');
    }


  }
  Future<void> deleteConversationOrThrow(String token, int conversationId) async {
    final tag = '$className:deleteConversationOrThrow:';
    try{

      final client = NetworkFactory.createApiClient();
      final url = 'https://backend.snowtex.org/api/v1/chat/mobile/conversation/$conversationId/';

      Logger.debug(tag, 'request={token:$token,userId:$conversationId}');
      final json = await client.deleteWithTokenOrThrow(url, 'Token $token');

      Logger.debug(tag, 'readJson: $json');
      final decoded = jsonDecode(json);
      Logger.debug(tag, 'decoded: $decoded');
    }
    catch(e){
      throw  toCustomException(exception: e, fallBackDebugMsg: 'source:$tag');
    }


  }

  ConversationEntity? _parseOrNull(dynamic result,int currentUseId){
    final tag = '$className::_parseOrNull';
    try {
      return ConversationEntityParser.fromJsonOrThrow(result, currentUseId);
    }
    catch (e, stackTrace) {
      Logger.errorWithTrace(tag, stackTrace);
      return null;
    }
  }


  Future<PaginationWrapper<List<MessageModel>>> readMessages(String token, int currentUserId,int conversationId,String? paginationUrl) async {
    final tag = '$className::readMessages:';
    final client = NetworkFactory.createApiClient();
    final url = replaceHttpWithHttps(paginationUrl ?? 'https://backend.snowtex.org/api/v1/chat/mobile/conversation/$conversationId/messages/');
    try {
      Logger.debug(tag, 'request={token:$token,currentUserId:$currentUserId,conversationId:$conversationId,url:$url}');

      final json = await client.readWithTokenOrThrow(url, 'Token $token');

      final  decoded = jsonDecode(json);
      Logger.debug(tag, 'decoded: $decoded');

      final parsedEntity = (decoded['data']['results'] as List<dynamic>) //TODO:TypeCast may cause exception
          .map((conversation) => MessageEntity.fromJsonOrThrow(conversation))
          .toList();
      final models=ConversationEntityMapper.toMessageModel(parsedEntity, currentUserId);
      final Map<String,dynamic> data=decoded['data'];
      //Using safe access to avoid causing exception a field that may not exits
      final String? next=data.containsKey('next')?data['next']:null;
      return PaginationWrapper(data: models, next: next);
    } catch (e) {

     throw toCustomException(exception: e,fallBackDebugMsg: 'source:$tag\n,error=$e');
    }
  }
  String replaceHttpWithHttps(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

}
