//@formatter:off
class MessageEntity {
  final int id;
  ///Helpful for group message to know who sent this message
  final String senderName;
  final String msg;
  final DateTime createdAt;
  final int status;
  final int senderId;
  final List<AttachmentEntity> attachments;

  MessageEntity({
    required this.senderName,
    required this.id,
    required this.msg,
    required this.createdAt,
    required this.status,
    required this.senderId,
    required this.attachments
  });

  /// Avoid explicit type casting such ['x'] as y to avoid unwanted exception or bug as the backend may return a JSON
  /// with missing or null fields. Typecasting null values or using expressions can throw exceptions and cause unwanted bugs
  static MessageEntity fromJsonOrThrow(Map<String, dynamic> json) {
    var attachmentsList = json['attachments'] as List;
    List<AttachmentEntity> attachments = attachmentsList.map((attachmentJson) => AttachmentEntity.fromJsonOrThrow(attachmentJson)).toList();

    return MessageEntity(
      id: json['id'],
      msg: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'],
      senderName: json['sender']['first_name'] + ' ' + json['sender']['last_name'],
      senderId: json['sender']['id'],
      attachments: attachments
    );
  }

  @override
  String toString() {
    return 'MessageEntity(id: $id, msg: "$msg", createdAt: $createdAt, status: $status,senderName:$senderName senderId: $senderId,attachment:$attachments)';
  }
}

//@formatter:off
class AttachmentEntity {
  ///Need when forwarding a message
  ///Added later that is why null-able to make sure old feature does not break,later refactor it
  final int? id;
  final String url;
  /// 0=Image, 1=Video , ...

  final int docType;
  AttachmentEntity({required this.url, required this.docType,required this.id});
  get isImage => docType == 0;
  get isVideo=>docType==1;
  get isOtherType=>docType>=2;

  // fromJson method to parse the JSON
  factory AttachmentEntity.fromJsonOrThrow(Map<String, dynamic> json) {
    return AttachmentEntity(
      id:json.containsKey('id')?json['id']:null,
      url: json['doc_url'],
      docType: json['doc_type'],
    );
  }

  // toString method to return a string representation of the object
  @override
  String toString() {
    return 'Attachment(docUrl: $url,docType: $docType)';
  }
}
