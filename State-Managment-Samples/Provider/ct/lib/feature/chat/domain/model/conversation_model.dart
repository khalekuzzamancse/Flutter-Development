
import '../../data/entity/peer_entity.dart';
import 'last_message_model.dart';

class ConversationModel {
  ///Need for further query such as in case of group chat to find the group members
  final int id;
  ///Need for show profile
  final ConversationPeerEntity peer;
  final bool isGroupChat;
  final LastMessageModel? lastMessage;
  ConversationModel({
    required this.peer,
     this.lastMessage,
    required this.isGroupChat,
    required this.id,
  });

  ConversationModel copyWith({
    String? avatarUrl,
    String? name,
    LastMessageModel? lastMessage,
  }) {
    return ConversationModel(
        peer: peer,
        lastMessage: lastMessage ?? this.lastMessage,
        isGroupChat: isGroupChat,
        id: id);
  }

  @override
  String toString() {
    return 'ConversationModelHome(conversationId:$id, isGroupChat:$isGroupChat, peer:$peer, lastMessage: $lastMessage)';
  }
}
