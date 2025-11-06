part of '../../core_presentation_logic.dart';
class MessageToUi {
  final String message;
  final MessageType type;

  MessageToUi._(this.message, this.type);

  factory MessageToUi.error(String message) {
    return MessageToUi._(message, MessageType.error);
  }

  factory MessageToUi.success(String message) {
    return MessageToUi._(message, MessageType.success);
  }

  factory MessageToUi.neutral(String message) {
    return MessageToUi._(message, MessageType.neutral);
  }

  @override
  String toString() {
    return 'Message: $message, Type: ${type.toString().split('.').last}';
  }
}

enum MessageType { error, success, neutral }
