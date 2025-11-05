
import 'package:snowchat_ios/feature/chat/data/entity/peer_entity.dart';
import 'last_message_entity.dart';

//formatter:off
class ConversationEntity {
  ///Need for further query such as in case of group chat to find the group members or message list
  final int conversationId;
  final ConversationPeerEntity peer;
  final ConversationLastMessageEntity? lastMessage;

  ConversationEntity({required this.conversationId, required this.peer, this.lastMessage});

  @override
  String toString()=>'ConversationEntity(id:$conversationId, name: $peer,lastMessage:$lastMessage)';

}
