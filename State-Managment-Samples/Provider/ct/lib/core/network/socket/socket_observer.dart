import 'package:snowchat_ios/core/network/socket/socket_status.dart';
import 'package:snowchat_ios/feature/chat/domain/model/conversation_model.dart';
import '../../../feature/chat/domain/model/message_model.dart';

abstract class WebSocketObserver {
  ///When a sent message is successfully received by the peer
  void onReceived(int conversationId, int messageId);
  /// when a message is seen by the peer
  void onSeen(int conversationId, int messageId);

  ///when a new message received in the server, either the message that I sent(echo) or a new message
  ///that I received
  void onNewMessage(MessageModel model, int conversationId);
  ///When conversation is open  and server sent this event
  ///It might possible that the conversation is already exits
  void onNewConversationOpen(ConversationModel entity);
  ///Notify so that conversation list refresh because socket for this project does not return a group image link
  ///instead return a image id as a result UI will not able to update group image which misleads the user that
  ///group image may not be updated properly
  void onNewGroupCreated();
  void onConnectionStatusChanged(SocketConnectStatus status);
  void onMessageDeleted(int conversationId, int messageId);
}
abstract interface class GroupCreationObserver{
  void onNewGroupCreated();
}
abstract  class NewConversationObserver{
  void onNewConversationCreated(ConversationModel model);
}