import 'package:snowchat_ios/feature/chat/data/entity/last_message_entity.dart';
import 'package:snowchat_ios/feature/chat/data/entity/peer_entity.dart';
import 'base_conversation_entity.dart';

//@formatter:off
class ConversationEntityParser{
  static ConversationEntity fromJsonOrThrow(Map<String, dynamic> result, int userId){
    final conversationId=conversationIdOrThrow(result);

    ///Even there may no message still receiver exits  of personal message
    ///the new created group receiver null
    if(_isOpenPersonalConversation(result)){
      return ConversationEntity(
          conversationId: conversationId,
          peer:ConversationPersonalPeerEntity.fromJsonOrThrow(result['receiver']),
          lastMessage: null);
    }
    else if(isGroupConversationWithNoMessage(result)){
      //Has no receiver
      return ConversationEntity(
          conversationId: conversationId,
          peer: ConversationPeerEntity.fromJsonOrThrow(result),
          lastMessage: null);

    }

    else{
      //There is a last message so either it group or personal conversation
      final lastMessage=ConversationLastMessageEntity.fromJsonOrThrow(result['last_message']);
      if(_isGroupConversation(result)){
        return ConversationEntity(
            conversationId: conversationId,
            peer: ConversationPeerEntity.fromJsonOrThrow(result),
            lastMessage: lastMessage);

      }else{
        final receiver=ConversationPersonalPeerEntity.fromJsonOrThrow(result['receiver']);
        //Personal conversation and last message is not null(because not a opened message) so exits sender
        final sender=ConversationPersonalPeerEntity.fromJsonOrThrow(result['last_message']['sender']);

        return ConversationEntity(
            conversationId: conversationId,
            peer:userId==receiver.id?sender:receiver,//if current user is receiver  that sender  is the peer
            lastMessage:lastMessage);
      }
    }

  }
  static int conversationIdOrThrow(Map<String, dynamic> json)=>json['id'];
  static bool _isGroupConversation(Map<String, dynamic> json)=>json['group_name'] != null;
  static bool _isOpenPersonalConversation(Map<String, dynamic> json){
    //for new group that has no message yet also last message=null
   return json['group_name'] == null&&json['last_message'] == null;
  }
  static bool isGroupConversationWithNoMessage(Map<String, dynamic> json){
    return json['group_name'] != null&&json['last_message'] == null;
  }
}