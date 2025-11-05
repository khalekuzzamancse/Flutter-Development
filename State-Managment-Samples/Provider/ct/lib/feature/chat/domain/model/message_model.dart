//@formatter:off
import 'package:snowchat_ios/feature/chat/data/entity/message_entity.dart';

class MessageModel {
  final int id, status;
  final String message, time;
  final bool isAmSender;
  ///null if this device is sender, this is useful for group message
  final String? senderName;
  final List<AttachmentEntity> attachments;

  MessageModel({required this.message, required this.time, required this.isAmSender, required this.senderName, required this.id, required this.status,required this.attachments});
  @override
  String toString() {
    return 'MessageModel{id:$id, message: $message, time: $time, isAmSender: $isAmSender, senderName: $senderName, status:$status}';
  }
  MessageModel copyWith({
    int? id,
    int? status,
    String? message,
    String? time,
    bool? isAmSender,
    String? senderName,
    List<AttachmentEntity>? attachments,
  }) {
    return MessageModel(
      id: id ?? this.id, // Use the current value if the parameter is null
      status: status ?? this.status,
      message: message ?? this.message,
      time: time ?? this.time,
      isAmSender: isAmSender ?? this.isAmSender,
      senderName: senderName ?? this.senderName,
      attachments: attachments ?? this.attachments,
    );
  }

}