import 'dart:ffi';

import 'package:get/get.dart';
import 'package:snowchat_ios/core/network/socket/socket_observer.dart';
import 'package:snowchat_ios/core/network/socket/web_socket.dart';
import '../../../core/misc/logger.dart';
import '../../chat/domain/model/conversation_model.dart';
import '../../di/global_controller.dart';
import '../data/repository/contact_repository.dart';
import '../domain/model/contact_model.dart';

class ContactController extends GetxController
    implements NewConversationObserver {
  final className = 'ContactController';
  final contacts = <ContactModel>[].obs;
  final isLoading = false.obs;
  var _fetchedList = <ContactModel>[];
  void Function(ConversationModel model)? newConversationObserver;

  ContactController() {
    WebSocketService.registerAsConversationObserver(className, this);
  }

  void openConversation(int userId) {
    WebSocketService().createPersonalConversation(userId);
  }

  void onLocalSearch(String query) {
    final tag = '$className::onLocalSearch';
    if (query.isNotEmpty) {
      final filtered = contacts.where((contact) {
        var shouldFilter =
            contact.name.toLowerCase().contains(query.toLowerCase());
        final profile = contact.profile;
        if (profile != null) {
          shouldFilter = shouldFilter ||
              profile.phone.toLowerCase().contains(query.toLowerCase());
        }
        return shouldFilter;
      }).toList();
      // Logger.temp(tag, 'query:$query,$filtered:$filtered');
      contacts.clear();
      contacts.addAll(filtered);
      contacts.refresh();
      _notifyObserver();
    } else {
      contacts.clear();
      contacts.addAll(_fetchedList);
      contacts.refresh();
      _notifyObserver();
    }
  }

  ///Try with the device that has contact such as android, iPhone
  ///
  ///TODO: find  a way to avoid each time post the contact when user go to contact list
  void postContact(List<String> deviceContacts) async {
    final tag = '$className::postContact()';
    Logger.debug(tag, 'postContact:$deviceContacts');
    try {
      isLoading.value = true;
      final authInfo = Get.find<GlobalController>().authInfo;
      if (deviceContacts.isNotEmpty) {
        await ContactRepository()
            .postContactOrThrow(deviceContacts, authInfo.token);
        //TODO:though read here is side effect in some cases the contact is not loaded
        //properly even though post are success,that is my be because of read was called or executed
        //before post either by network calling mistake or by post and read order mistake that is why
        //reading it to remove the bug
        read();
      }
      _notifyObserver();
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void startLoading() {
    isLoading.value = true;
  }

  void stopLoading() {
    isLoading.value = false;
  }

  Future<void> read() async {
    final tag = '$className::readAsync()';
    try {
      isLoading.value = true;
      final authInfo = Get.find<GlobalController>().authInfo;
      final response = await ContactRepository().readContacts(authInfo.token);
      _fetchedList = response;
      Logger.debug(tag, 'response:$response');
      contacts
          .clear(); //Remove old item if present because my mistake this function may call multiple time
      contacts.addAll(response);
      contacts.refresh();
    } catch (e) {
      _fetchedList = []; //Must clear old state
      _notifyObserver();
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
      isLoading.refresh();
    }
  }

  void _notifyObserver() {
    isLoading.value = true;
    isLoading.value = false;
  }

  @override
  void onNewConversationCreated(ConversationModel conversation) {
    final snapshot=newConversationObserver;
    if(snapshot!=null){
      snapshot(conversation);
    }
  }

  void clearResources() {
    WebSocketService.unRegister(className);
    newConversationObserver=null;
  }
}

// const String _avatarUrl =
//     "https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4";
// final _dummyContact = [
//   ContactModel(
//     avatarUrl: _avatarUrl,
//     name: "Alex Robert",
//     lastSeen: "9:14 PM",
//   ),
//   ContactModel(
//     avatarUrl: _avatarUrl,
//     name: "Ashraf Hossain",
//     lastSeen: "12:14 PM",
//   ),
//   ContactModel(
//     avatarUrl: _avatarUrl,
//     name: "Blake Morison",
//     lastSeen: "Yesterday at 1:14 AM",
//   ),
//   ContactModel(
//     avatarUrl: _avatarUrl,
//     name: "Cathy Friend",
//     lastSeen: "December 09 at 6:14 PM",
//   ),
//   ContactModel(
//     avatarUrl: _avatarUrl,
//     name: "Denvar Home",
//     lastSeen: "Within a month",
//   ),
//   ContactModel(
//     avatarUrl: _avatarUrl,
//     name: "Flora",
//     lastSeen: "Recently",
//   ),
//   ContactModel(
//     avatarUrl: _avatarUrl,
//     name: "Jhon Ray",
//     lastSeen: "11:14 PM",
//   ),
// ];
