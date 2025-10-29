import 'package:snowchat_ios/feature/chat/data/entity/peer_entity.dart';

class ContactModel {
  final int id;
  final String? avatarUrl;
  final String name;
  final String? lastSeen;
  //for profile ui
  ConversationPersonalPeerEntity? profile;


  ContactModel({
    required this.id,
    required this.profile,
    required this.avatarUrl,
    required this.name,
    required this.lastSeen,
  });

  ContactModel copyWith({
    String? avatarUrl,
    String? name,
    String? lastSeen,
  }) {
    return ContactModel(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      profile: profile,
      name: name ?? this.name,
      id: id,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  String toString() {
    return 'ContactModel{id:$id, avatarUrl: $avatarUrl, name: $name, lastSeen: $lastSeen}';
  }
}
