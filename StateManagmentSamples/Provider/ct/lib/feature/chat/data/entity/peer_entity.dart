
import 'package:snowchat_ios/core/misc/logger.dart';

///Denote Person peer or the Group the base is contain the common info of person and group peer
//@formatter:off
class ConversationPeerEntity {
  final int id;
  final String name;
  final String? image;
  ///For the peer , nullable for group
  final String? lastSeen;
  ///Nullable because the field may not exits
  final bool? isOnline;
  ConversationPeerEntity( {required this.id, required this.name,required this.image,this.isOnline,required this.lastSeen,});

  ///Pass only the receiver part of the Json(Not the whole Json)-> result[index]
  factory ConversationPeerEntity.fromJsonOrThrow(Map<String, dynamic> result){
    return ConversationPeerEntity(
      lastSeen: null,
      id: result['id'],
      name: result['group_name'],
      image: result['group_image_url'],
    );
  }
  @override
  String toString() {
    return 'ConversationPeerEntity(id: $id, name: $name, image:$image)';
  }
}
//@formatter:off
class ConversationPersonalPeerEntity  extends ConversationPeerEntity{
  final String phone, email;
  ConversationPersonalPeerEntity({
    required int id, required String name, required String? image,
    required this.phone, required this.email,required bool? isOnline,required String?lastSeen}):super(id:id,name:name, image:image,isOnline:isOnline,lastSeen: lastSeen);

  ///Pass only the receiver part of the Json(Not the whole Json)-> result[index][receiver]
  factory ConversationPersonalPeerEntity.fromJsonOrThrow(Map<String, dynamic> receiver){
    final parsed= ConversationPersonalPeerEntity(
      id: receiver['id'],
      name: receiver['first_name']+' '+receiver['last_name'],
      image: receiver['image_url'],
      phone: receiver['mobile'],
      email: receiver['email'],
      isOnline: receiver['is_online'],
      lastSeen: receiver.containsKey('last_seen')? receiver['last_seen']:null //safe access to avoid exception
    );

    return parsed;
  }

  @override
  String toString() {
    return 'ConversationPeerEntity(id: $id, name: $name,phone:$phone, email:$email, image:$image,isOnline:$isOnline,lastSeen:$lastSeen)';
  }
}

