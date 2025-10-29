class MiscInfoEntity {
  final String desc;
  final String? thumbnailUrl;

  MiscInfoEntity({
    required this.desc,
    required this.thumbnailUrl,
  });

  static MiscInfoEntity fromJsonOrThrow(Map<String, dynamic> json) {

    return MiscInfoEntity(
      desc: json['desc'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }

  @override
  String toString() {
    return 'MiscInfoEntity{desc: $desc, thumbnail: $thumbnailUrl}';
  }
}
