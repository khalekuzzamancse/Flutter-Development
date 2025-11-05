import 'package:get/get.dart';
import '../../../contact_list/data/repository/contact_repository.dart';
import '../../../contact_list/domain/model/contact_model.dart';
import '../../../di/global_controller.dart';
import '../../data/group_chat_repository.dart';

// class ContactReader {
//   final className = 'ContactLoader';
//
//
//   Future<List<ContactModel>> readOrThrowAsync() async {
//     final tag = '$className::readAsync()';
//     final authInfo = Get.find<GlobalController>().authInfo;
//     final response = await ContactRepository().readContacts(authInfo.token);
//     return response;
//   }
//   ///On fail or  rise return empty list or group members(admin+general members)
//   Future<List<ContactModel>> readGroupMembers(int conversationId) async {
//     final tag = '$className::readGroupMembers()';
//     try{
//       final token = Get.find<GlobalController>().authInfo.token;
//       final generalMembers = await GroupChatRepository().readMembers(conversationId,token);
//       final admins = await GroupChatRepository().readAdmins(conversationId,token);
//       return [...generalMembers, ...admins];
//     }
//     catch(e){
//       return List.empty();
//     }
//
//   }
// }
