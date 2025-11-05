import 'package:get/get.dart';
import 'package:snowchat_ios/feature/group_chat/domain/actions.dart';
import '../../../../core/misc/logger.dart';
import '../../../contact_list/data/repository/contact_repository.dart';
import '../../../contact_list/domain/model/contact_model.dart';
import '../../../di/global_controller.dart';
import '../../data/group_chat_repository.dart';

class RemoveMemberController extends GetxController {
  final _class = 'AddMemberController';
  final contacts = <ContactModel>[].obs;
  final isLoading = false.obs;
  final int conversationId;

  RemoveMemberController(this.conversationId);

  String? _nextMembersUrl, _nextAdminsUrls;

  void onEnd() {
    final tag = '$_class::onEndOfList';
    Logger.temp(tag, '$_nextMembersUrl,$_nextAdminsUrls');
    _paginationRead();
  }

  ///Just a wrapper around the _read() for safe access to avoid infinite fetching
  void _paginationRead() async{
    final tag = '$_class::_paginationRead()';
    try {
      isLoading.value = true;
      final info = Get.find<GlobalController>().authInfo;
      final token = info.token;
      final currentUserId = info.currentUserId;

      var memberResponse = await GroupChatRepository().readMembersPagination(conversationId, token, _nextMembersUrl);
      final generalMembers = memberResponse.data;
      _nextMembersUrl = memberResponse.next;
      var adminResponse = await GroupChatRepository().readAdminPaginated(conversationId, token, _nextAdminsUrls);
      final admins = adminResponse.data;
      _nextAdminsUrls = adminResponse.next;

      final adminsAndMembers = [...generalMembers, ...admins];

      final uniqueAdminsAndMembers = {
        for (var contact in adminsAndMembers) contact.id: contact
      }.values.toList();
      Logger.debug(tag, 'uniqueAdminsAndMembers:$uniqueAdminsAndMembers');
      //Remove the signed in user from this list, he has a option for leave from group so need to show in the remove list
      uniqueAdminsAndMembers.removeWhere((contact) => contact.id == currentUserId);
      contacts.addAll(uniqueAdminsAndMembers);
      contacts.refresh();
    } catch (e, stackTrace) {
      Logger.errorWithTrace(tag, stackTrace);
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
      isLoading.refresh();
    }
  }

  Future<void> remove(List<int> members) async {
    final tag = '$_class::addMembersAsync()';
    try {
      isLoading.value = true;
      final token = Get.find<GlobalController>().authInfo.token;
      final response = await GroupChatRepository().modifyMember(
          conversationId: conversationId,
          members: members,
          token: token,
          action: ActionType.remove);
      Logger.debug(tag, 'response:$response');
      Get.find<GlobalController>().showSnackBar(response);
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }


//@formatter:off
  void loadContacts() async {
    final tag = '$_class::loadContacts()';
    try {
      isLoading.value = true;
      final info = Get.find<GlobalController>().authInfo;
      final token = info.token;
      final currentUserId = info.currentUserId;

      var memberResponse = await GroupChatRepository().readMembers(conversationId, token, null);
      final generalMembers = memberResponse.data;
      _nextMembersUrl = memberResponse.next;
      var adminResponse = await GroupChatRepository().readAdmins(conversationId, token, null);
      final admins = adminResponse.data;
      _nextAdminsUrls = adminResponse.next;

      final adminsAndMembers = [...generalMembers, ...admins];

      final uniqueAdminsAndMembers = {
        for (var contact in adminsAndMembers) contact.id: contact
      }.values.toList();
      Logger.debug(tag, 'uniqueAdminsAndMembers:$uniqueAdminsAndMembers');
      //Remove the signed in user from this list, he has a option for leave from group so need to show in the remove list
      uniqueAdminsAndMembers
          .removeWhere((contact) => contact.id == currentUserId);
       contacts.clear();
      contacts.addAll(uniqueAdminsAndMembers);
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
