import 'message_entity.dart';

///TODO: Assuming that attachment is non null , in case of no attachment return empty list
///If the assumption fail
String getLastMessageOrAttachmentLabel(Map<String, dynamic> lastMessage) {
  try {
    final String msg = lastMessage['message'];
    //handle if message is empty but has attachment
    if (msg.trim().isNotEmpty) {
      return msg;
    }

    var attachmentsList = lastMessage['attachments'] as List;
    List<AttachmentEntity> attachments = attachmentsList
        .map((attachmentJson) => AttachmentEntity.fromJsonOrThrow(attachmentJson))
        .toList();

    if (attachments.isNotEmpty) {
      final doc = attachments.last;
      if (doc.docType == 0) {
        return 'Photo';
      } else if (doc.docType == 1) {
        return 'Video';
      } else {
        return 'File';
      }
    }
    return '..'; //TODO:Edge case(Normally will not happen)
  } catch (e, stackTrace) {
    return '...';
  }
}
