import 'package:snowchat_ios/core/network/socket/web_socket.dart';
import 'package:snowchat_ios/feature/chat/data/entity/peer_entity.dart';

import '../../../feature/chat/data/entity/base_conversation_entity.dart';

class SocketResponseParser {
  ///Safe , not throw any exception
  static bool isCreateConversation(Map<String, dynamic> response) {
    try {
      return response['event'] ==
          'create_convo'; //If key not exit may rise exception
    } catch (e, stackTrace) {
      return false;
    }
  }

  static bool isNewGroupCreateEvent(Map<String, dynamic> data) {
   try{
     final receiver = data['receiver'];
     final groupName = data['group_name'];
     //For new group receiver is null, with no message
     return receiver == null && groupName != null;
   }
   catch(e){
     return false;
   }
  }

  ///Pass the response['data'] field
  //@formatter:off
  static ConversationEntity parseAsCreatedConversationOrThrow(Map<String, dynamic> data) {
    return ConversationEntity(
        conversationId: data['id'],
        peer: ConversationPersonalPeerEntity.fromJsonOrThrow(data['receiver']),
        lastMessage: null //No message yet with this conversation just created the link
        );
  }


  //Acknowledgement for received,safe not throw exception
  static bool isACKForReceived(Map<String, dynamic> json) {
    // Logger.logSocket('SocketDS::toSentMessageOrThrow', "${json['sender']}");
    try {
      return json['data']['event'] == 'message_received';
    } catch (e) {
      return false;
    }
  }

  static bool isACKForSeen(Map<String, dynamic> json) {
    // Logger.logSocket('SocketDS::toSentMessageOrThrow', "${json['sender']}");
    try {
      return json['data']['event'] == 'message_open';
    } catch (e) {
      return false;
    }
  }

  static MsgACK extractAckOrThrow(Map<String, dynamic> json) {
    final data = json['data']['data'];

    // Logger.logSocket('SocketDS::toSentMessageOrThrow', "${json['sender']}");
    return MsgACK(msgId: data['message'], conversationId: data['conversation']);
  }
}
