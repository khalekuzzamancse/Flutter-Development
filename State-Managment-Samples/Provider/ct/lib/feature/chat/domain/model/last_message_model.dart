class LastMessageModel {
  final int id,status;
  final String messageOrFileLabel;
  final String time;
  ///null means not decided, because this is import for the last message only
  ///that can be handled
  final bool? iAmSender;


  LastMessageModel({required this.id, required this.status, required this.messageOrFileLabel, required this.time,required this.iAmSender, });

  @override
  String toString() {
    return 'LastMessageEntity(id: $id, status: $status, content: "$messageOrFileLabel", time: "$time")';
  }

  LastMessageModel copyWith({
    int? id,
    int? status, String? content,
    String? time
  }) {
    return LastMessageModel(id: id ?? this.id, status: status ?? this.status,
        messageOrFileLabel: content ?? messageOrFileLabel, time: time ?? this.time,iAmSender: iAmSender);
  }
}