import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:snowchat_ios/core/domain/media_type.dart';
import 'package:snowchat_ios/core/network/socket/socket_observer.dart';
import 'package:snowchat_ios/core/network/socket/web_socket.dart';
import 'package:snowchat_ios/feature/group_chat/domain/group_creation_model.dart';
import '../../../../core/data/media_repository.dart';
import '../../../../core/misc/logger.dart';
import '../../../contact_list/data/repository/contact_repository.dart';
import '../../../contact_list/domain/model/contact_model.dart';
import '../../../di/global_controller.dart';

class CreateGroupController extends GetxController implements GroupCreationObserver {
  final _class = 'CreateGroupController';
  final isLoading = false.obs;
  final contacts = <ContactModel>[].obs;
  VoidCallback groupCreationObserver=(){};
  CreateGroupController(){
    WebSocketService.registerAsGroupCreateListener(_class, this);
  }
  void loadContacts() async {
    final tag = '$_class::loadContacts()';
    try {
      isLoading.value = true;
      final tag = '$_class::readAsync()';
      final authInfo = Get.find<GlobalController>().authInfo;
      final models = await ContactRepository().readContacts(authInfo.token);
      models.removeWhere((contact) => contact.id == authInfo.currentUserId);
      contacts.clear();
      contacts.addAll(models);
      contacts.refresh();
    } catch (e, stackTrace) {
      Logger.errorWithTrace(tag, stackTrace);
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }

  ///conversationId
  Future<void> createGroup(
      String imagePath, String name, List<int> members) async {
    final tag = '$_class::createGroup';
    try {
      isLoading.value = true;
      final authInfo = Get.find<GlobalController>().authInfo;
      final token = authInfo.token;
      final admin = authInfo.currentUserId;
      final groupMembers = [...members, admin]; //admin itself a member
      final imageId = await MediaRepository().uploadFileOrThrow(
          path: imagePath, token: token, type: MediaType.image);
      Logger.debug(tag, 'uploadedImageId=$imageId');

      final model = GroupCreationModel(
          name: name,
          imageId: imageId.id,
          membersId: groupMembers,
          adminId: admin);
      WebSocketService().createNewGroup(model);
      // Logger.temp(tag, 'groupCreationResponse=$response');
      // return response;
    } catch (e, trace) {
      Logger.errorWithTrace(tag, trace);
      Get.find<GlobalController>().onError(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onNewGroupCreated() {
    final tag = '$_class::onNewGroupCreated';
    Logger.temp(tag, 'onNewGroupCreated');
    groupCreationObserver();
  }
}
