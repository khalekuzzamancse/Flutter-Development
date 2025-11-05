import 'package:snowchat_ios/core/data/document_entity.dart';

import '../../../../core/domain/media_type.dart';

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
