import 'package:snowchat_ios/feature/chat/data/entity/peer_entity.dart';
import 'package:snowchat_ios/feature/chat/domain/model/message_model.dart';
import 'package:snowchat_ios/feature/chat/data/entity/message_entity.dart';
import '../../domain/model/conversation_model.dart';
import '../../domain/model/last_message_model.dart';
import 'base_conversation_entity.dart';

class ConversationEntityMapper {
  static List<ConversationModel> toModel2(List<ConversationEntity> entities) {
    return entities.map((entity) {
      final lastMsgEntity = entity.lastMessage;

      final lastMessage = lastMsgEntity == null ? null : LastMessageModel(
              id: lastMsgEntity.id,
              status: lastMsgEntity.status,
              messageOrFileLabel: lastMsgEntity.messageOrFileLabel,
              time: lastMsgEntity.time,
        iAmSender: null
      );
      return ConversationModel(
        peer: entity.peer,
        lastMessage: lastMessage,
        id: entity.conversationId,
        isGroupChat: entity.peer is! ConversationPersonalPeerEntity,
      );
    }).toList();
  }


   //@formatter:off
  static List<MessageModel> toMessageModel(List<MessageEntity> entities, int currentUserId) {
    return entities.map((entity) {
      return MessageModel(
        id: entity.id,
        message: entity.msg,
        senderName: entity.senderName,
        status: entity.status,
        isAmSender: currentUserId == entity.senderId,
        time: entity.createdAt.toString(),
        attachments: entity.attachments
      );
    }).toList();
  }
}
