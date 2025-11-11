//@formatter:off
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
//@formatter:off
class PickedMediaModel {
  final MediaType type;
  final String path;
  final String name; //added later that is why optional

  PickedMediaModel({required this.type, required this.path, this.name=''});
  get isImage=>type==MediaType.image;
  get isVideo=>type==MediaType.video;
  get isOtherFile=>type==MediaType.otherFile;

  @override
  String toString() {
    return 'PickedMediaModel(type: $type, path: $path)';
  }
}
enum MediaType { image, video, otherFile }

