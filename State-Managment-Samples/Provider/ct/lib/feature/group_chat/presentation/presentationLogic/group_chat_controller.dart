import 'package:get/get.dart';
import 'package:snowchat_ios/feature/group_chat/data/group_chat_repository.dart';
import 'package:snowchat_ios/feature/group_chat/domain/actions.dart';
import '../../../../core/misc/logger.dart';
import '../../../contact_list/domain/model/contact_model.dart';
import '../../../di/global_controller.dart';


class GroupChatController extends GetxController {
  final className = 'GroupChatController';
  final isLoading = false.obs;

  ///is the current user in the admin or not
  final isAdmin = false.obs;

  GroupChatController(int conversationId) {
    updateAdminStatus(conversationId);
  }

  void updateAdminStatus(int conversationId) async {
    final tag = '$className::updateAdminStatus()';
    final admins = await _readAdminsAsync(conversationId);
    final signedInUserId = Get.find<GlobalController>().authInfo.currentUserId;
    isAdmin.value = admins.any((user) => user.id == signedInUserId);
    isAdmin.refresh();
    update();
    ;
  }

  ///add as general member(not as admin)
  Future<void> addMembers(int conversationId, List<int> members) async {
    await _modifyMembers(conversationId, members, ActionType.add);
  }

  Future<void> leaveGroup(int conversationId) async {
    final currentUser = Get.find<GlobalController>().authInfo.currentUserId;
    final tag = '$className::leaveGroup()';
    await removeMember(conversationId, [currentUser]);
  }

  ///remove members
  Future<void> removeMember(int conversationId, List<int> members) async {
    await _modifyMembers(conversationId, members, ActionType.remove);
  }

  Future<void> _modifyMembers(
      int conversationId, List<int> members, ActionType action) async {
    final tag = '$className::addMembersAsync()';
    try {
      isLoading.value = true;
      final token = Get.find<GlobalController>().authInfo.token;
      final response = await GroupChatRepository().modifyMember(
          conversationId: conversationId,
          members: members,
          token: token,
          action: action);
      Logger.debug(tag, 'response:$response');
      Get.find<GlobalController>().showSnackBar(response);
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ContactModel>> _readAdminsAsync(int conversationId) async {
    final tag = '$className::readAdminsAsync()';
    try {
      isLoading.value = true;
      final token = Get.find<GlobalController>().authInfo.token;

      var response =
          await GroupChatRepository().readAdmins(conversationId, token, null);
      Logger.debug(tag, 'response:$response');
      final admins = <ContactModel>[];
      String? nextPaginationUrl = response.next;
      admins.addAll(response.data);
      //TODO:Refactor it later, find a better solution
      // while(nextPaginationUrl!=null){
      //   response = await GroupChatRepository().readAdmins(conversationId,token,nextPaginationUrl);
      //   nextPaginationUrl=response.next;
      //   admins.addAll(response.data);
      // }
      return admins;
    } catch (e) {
      Get.find<GlobalController>().onError(e);
      return List.empty();
    } finally {
      isLoading.value = false;
    }
  }
}
