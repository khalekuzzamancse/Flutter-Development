import 'package:get/get.dart';
import 'package:snowchat_ios/feature/group_chat/data/group_chat_repository.dart';
import '../../../../core/misc/logger.dart';
import '../../../contact_list/domain/model/contact_model.dart';
import '../../../di/global_controller.dart';

class GroupAdminListController extends GetxController {
  final _class = 'GroupAdminListController';
  final admins = <ContactModel>[].obs;
  final isLoading = false.obs;
  final int conversationId;
  GroupAdminListController(this.conversationId) ;
  String? _next;

  void onEndOfList() {
    final tag = '$_class::onEndOfList';
    Logger.debug(tag, '$_next');
    final next = _next; //capture as immutable of the mutable copy to avoid risk of crash or safe access
    if (next != null) {
      _paginationRead(next);
    }
  }

  ///Just a wrapper around the _read() for safe access to avoid infinite fetching
  void _paginationRead(String url) => _read(url);

  void read() async {
    _read(null);
  }

  Future<void> _read(String? url) async {
    final tag = '$_class::read()';
    try {
      isLoading.value = true;
      final token = Get.find<GlobalController>().authInfo.token;
      var response = await GroupChatRepository().readAdmins(conversationId,token,url);
      Logger.temp(tag, 'response:$response');
      _next=response.next;
      admins.addAll(response.data);
      admins.refresh();
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }

}