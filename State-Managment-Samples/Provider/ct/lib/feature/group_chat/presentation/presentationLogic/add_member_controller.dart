import 'package:get/get.dart';
import 'package:snowchat_ios/feature/group_chat/domain/actions.dart';
import '../../../../core/misc/logger.dart';
import '../../../contact_list/data/repository/contact_repository.dart';
import '../../../contact_list/domain/model/contact_model.dart';
import '../../../di/global_controller.dart';
import '../../data/group_chat_repository.dart';

class AddMemberController extends GetxController {
  final className = 'AddMemberController';
  final contacts = <ContactModel>[].obs;
  final isLoading = false.obs;
  final int conversationId;

  AddMemberController(this.conversationId);

  Future<void> add(List<int> members) async {
    final tag = '$className::addMembersAsync()';
    try {
      isLoading.value = true;
      final token = Get.find<GlobalController>().authInfo.token;
      final response = await GroupChatRepository().modifyMember(
          conversationId: conversationId,
          members: members,
          token: token,
          action: ActionType.add);
      Logger.debug(tag, 'response:$response');
      Get.find<GlobalController>().showSnackBar(response);
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void loadContacts() async {
    final tag = '$className::loadContacts()';
    try {
      isLoading.value = true;
      final tag = '$className::readAsync()';
      final authInfo = Get.find<GlobalController>().authInfo;
      final models = await ContactRepository().readContacts(authInfo.token);

      final token = Get.find<GlobalController>().authInfo.token;

      var memberResponse = await GroupChatRepository().readMembers(conversationId, token, null);
      final generalMembers = memberResponse.data;
      var nextPaginationUrl = memberResponse.next;
      //Get all the member by the pagination url
      while(nextPaginationUrl!=null){
        memberResponse = await GroupChatRepository().readMembers(conversationId, token, nextPaginationUrl);
        nextPaginationUrl = memberResponse.next;
        generalMembers.addAll(memberResponse.data);
      }
      nextPaginationUrl=null;
      var adminResponse = await GroupChatRepository().readAdmins(conversationId, token, null);
      final admins = adminResponse.data;
       nextPaginationUrl = adminResponse.next;

      while(nextPaginationUrl!=null){
        adminResponse = await GroupChatRepository().readAdmins(conversationId, token, nextPaginationUrl);
        nextPaginationUrl = adminResponse.next;
        admins.addAll(adminResponse.data);
      }

      final adminsAndMembers = [...generalMembers, ...admins];
      final uniqueAdminsAndMembers = {
        for (var contact in adminsAndMembers) contact.id: contact
      }.values.toList();

      final filteredModels = models.where((model) {
        return !uniqueAdminsAndMembers
            .any((uniqueMember) => uniqueMember.id == model.id);
      }).toList();
      Logger.debug(tag, 'uniqueAdminsAndMembers:$uniqueAdminsAndMembers');
      //contacts.clear();//Should not clear otherwise will not work with pagination
      contacts.addAll(filteredModels);
      contacts.refresh();
    } catch (e, stackTrace) {
      Logger.errorWithTrace(tag, stackTrace);
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
      isLoading.refresh();
    }
  }
}
