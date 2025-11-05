//@formatter:off
import 'misc.dart';

class ConversationLastMessageEntity {
  final int id,status;
  final String messageOrFileLabel;
  final String time;

  ConversationLastMessageEntity({required this.id, required this.status, required this.messageOrFileLabel, required this.time});
  ///Pass the result[index][last_message]
  factory ConversationLastMessageEntity.fromJsonOrThrow(Map<String, dynamic> lastMessage){
    return ConversationLastMessageEntity(
      id: lastMessage['id'],
      status: lastMessage['status'],
      messageOrFileLabel:getLastMessageOrAttachmentLabel(lastMessage),
      time: lastMessage['created_at'],
    );
  }

  @override
  String toString() {
    return 'LastMessageEntity(id: $id, status: $status, content: "$messageOrFileLabel", time: "$time")';
  }

  ConversationLastMessageEntity copyWith({int? id, int? status, String? content, String? time}) {
    return ConversationLastMessageEntity(id: id ?? this.id, status: status ?? this.status,
      messageOrFileLabel: content ?? messageOrFileLabel, time: time ?? this.time);
  }
}
