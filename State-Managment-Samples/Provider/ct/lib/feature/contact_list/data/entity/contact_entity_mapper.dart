import 'package:snowchat_ios/feature/chat/data/entity/peer_entity.dart';

import '../../domain/model/contact_model.dart';
import 'contact_entity.dart';

class ContactEntityMapper{
  static ContactModel fromContactEntityToModel(ContactEntity entity) {
    return ContactModel(
      id: entity.id,
      avatarUrl: entity.imageUrl,
      name: '${entity.firstName} ${entity.lastName}',
      lastSeen: entity.lastSeen,
      profile: ConversationPersonalPeerEntity(
        lastSeen:entity.lastSeen ,
          id: entity.id, name: '${entity.firstName} ${entity.lastName}',
          image: entity.imageUrl, phone: entity.mobile, email:entity.email, isOnline: false
      ),
    );
  }

}