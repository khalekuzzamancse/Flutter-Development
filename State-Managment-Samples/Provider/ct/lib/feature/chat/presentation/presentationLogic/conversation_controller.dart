import 'package:get/get.dart';
import 'package:snowchat_ios/core/network/socket/socket_observer.dart';
import 'package:snowchat_ios/core/network/socket/socket_status.dart';
import '../../../../core/misc/logger.dart';
import '../../../../core/network/socket/web_socket.dart';
import '../../../di/global_controller.dart';
import '../../data/entity/peer_entity.dart';
import '../../data/repository/converstation_repository.dart';
import '../../domain/model/conversation_model.dart';
import '../../domain/model/last_message_model.dart';
import '../../domain/model/message_model.dart';

//@formatter:off
class ConversationController extends GetxController implements WebSocketObserver {
  var isLoading = false.obs;
  var conversations = <ConversationModel>[].obs;
  final _class = 'ConversationController';
  String? _next;
  ///Use for local search
  ///for preserving the read list so that not destroy upon search
   List<ConversationModel> _fetchedList=[]; //Non null means already saved the old list
  ConversationController(){
    WebSocketService.registerAsListener(_class,this);

  }
  void onLocalSearch(String query){
    final tag='$_class::onLocalSearch';
    if(query.isNotEmpty){
      final filtered=conversations.where((conversation) {
        final peer=conversation.peer;
        var shouldFilter=peer.name.toLowerCase().contains(query.toLowerCase());
        if(peer is ConversationPersonalPeerEntity){
           shouldFilter=shouldFilter||peer.phone.toLowerCase().contains(query.toLowerCase());
        }
        return shouldFilter;
      }).toList();
    // Logger.temp(tag, 'query:$query,$filtered:$filtered');
      conversations.clear();
      conversations.addAll(filtered);
      conversations.refresh();
      _notifyObserver();
    }
    else{
      conversations.clear();
      conversations.addAll(_fetchedList);
      conversations.refresh();
      _notifyObserver();
    }
  }


  @override
  void onNewMessage(MessageModel model, int conversationId) {
    final tag = '$_class::onNewMessage';
    final index = conversations.indexWhere((conv) => conv.id == conversationId);
    // if (index != -1) {
    //   //TODO:Linear search O(n) , should refactor for large list???
    //   //The reality is the chatList be at most 1000 size in worst case so linear search is okay
    //   final lastMessage= LastMessageModel(
    //       id: model.id, status: model. status, messageOrFileLabel:
    //   model.message, time:  model.time,iAmSender: model.isAmSender);
    //   final updated= conversations[index].copyWith(lastMessage: lastMessage);
    //   conversations[index] = updated;
    // }
    if (index != -1) {
      // TODO: Linear search O(n), should refactor for large list???
      // The reality is the chatList be at most 1000 size in worst case so linear search is okay
      final lastMessage = LastMessageModel(
        id: model.id,
        status: model.status,
        messageOrFileLabel: model.message,
        time: model.time,
        iAmSender: model.isAmSender,
      );

      final updated = conversations[index].copyWith(lastMessage: lastMessage);

      // Remove the item from its current position
      conversations.removeAt(index);

      // Insert the updated item at the beginning of the list
      conversations.insert(0, updated);
    }
    conversations.refresh();
    ///Sometimes GetX may properly notify that is why forcefully notifying
    _notifyObserver();
  }

  @override
  void onReceived(int conversationId, int messageId) {
   _updateMessageStatus(conversationId,messageId,1);
  }

  @override
  void onSeen(int conversationId, int messageId) {
    final tag = '$_class::onSeen';
    Logger.debug(tag, 'conversations:$conversations');
    Logger.debug(tag, 'conversationId:$conversationId, msgId:$messageId');
   _updateMessageStatus(conversationId,messageId,2);
  }

  void _updateMessageStatus(int conversationId,int messageId,int newStatus){
    final tag = '$_class::_updateMessageStatus';
    Logger.debug(tag, 'conversationId:$conversationId,messageId:$messageId,newStatus:$newStatus');

    final index = conversations.indexWhere((conversation) =>
    (conversation.id==conversationId&&conversation.lastMessage?.id == messageId));
    if (index != -1) {
      var lastMessage= conversations[index].lastMessage;
      if(lastMessage==null)
        {
          return;
        }
      lastMessage=lastMessage.copyWith(status: newStatus);
      final updated = conversations[index].copyWith(lastMessage: lastMessage);
      conversations[index] = updated;
      conversations.refresh();
      _notifyObserver();
    }

  }

  Future<void> deleteConversation(int conversationId) async{
      final tag = '$_class::deleteConversation()';
      try {
        isLoading.value = true;
        final authInfo = Get.find<GlobalController>().authInfo;
       await ConversationRepository().deleteConversationOrThrow(authInfo.token,conversationId);
       ///OnSuccess
        conversations.removeWhere((conv)=>conv.id==conversationId);
        conversations.refresh();
        _notifyObserver();
      } catch (e) {
        Get.find<GlobalController>().onError(e);
      } finally {
        isLoading.value = false;
      }

  }
  void onEndOfList(){
    final tag='$_class::onEndOfList';
    Logger.debug(tag, '$_next');
    final next=_next;//capture as immutable of the mutable copy to avoid risk of crash or safe access
    if(next!=null){
      _paginationRead(next);
    }
  }
  ///Just a wrapper around the _read() for safe access to avoid infinite fetching
  void _paginationRead(String nextUrl)=>_read(nextUrl);

  void readMessages() async {
    _read(null);
  }
  void refreshData()async{
    final tag = '$_class::refreshData()';
    try {
      isLoading.value=true;
      final authInfo = Get.find<GlobalController>().authInfo;
      final response = await ConversationRepository().readConversation(authInfo.token, authInfo.currentUserId,null);
      Logger.debug(tag, 'response:$response');
      final models=response.data;
      _next=response.next;
      _fetchedList=models;
      conversations.clear();
      conversations.addAll(models); //need to add instead of replace because pagination is there
      conversations.refresh();
    } catch (e) {
      _fetchedList=[];//Must clear old state
      Get.find<GlobalController>().onError(e);
    }
    finally{
      isLoading.value=false;
    }
  }

  ///For initial loading
  Future<void> read()=>_read(null);
  ///url is nullable means for the initial load the url is null
  /// if the consumer/client is uses tha method for initial load then pass url=null
  /// but for pagination must pass a link otherwise it will do infinite next, as  a cycle
  Future<void> _read(String? url,) async {
    final tag = '$_class::read()';
    try {
      isLoading.value = true;
      final authInfo = Get.find<GlobalController>().authInfo;

      final reponse = await ConversationRepository().readConversation(authInfo.token, authInfo.currentUserId,url);
      Logger.debug(tag, 'response:$reponse');
      final models=reponse.data;
      _next=reponse.next;
      _fetchedList=models;
      conversations.addAll(models); //need to add instead of replace because pagination is there
      conversations.refresh();

    } catch (e) {
      _fetchedList=[];//Must clear old state
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onNewConversationOpen(ConversationModel model){
    final tag='$_class::onNewConversationOpen';
    final conversationNotExits=(conversations.indexWhere((conv) => conv.id == model.id))==-1;
    if(conversationNotExits){
      ///Append at begging
      Logger.debug(tag, '$model');
      conversations.insert(0, model);
      conversations.refresh();
      _fetchedList=conversations;
      _notifyObserver();
    }
  }

  void _notifyObserver(){
    isLoading.value=true;
    isLoading.value=false;
  }

  @override
  void onConnectionStatusChanged(SocketConnectStatus status) {
  }

  @override
  void onNewGroupCreated() async{
    final tag='$_class::onNewGroupCreated';
    //TODO: creating new group via the socket so it does not give the image link, it give the image id
    //that is why reading the whole conversation so that get the image link also
    //it has pagination so reading will duplicate the element so we need to full refresh that by
    //cleaning the old list
    //but the bad news is that pagination will be cleared so try a better way
    try {
      isLoading.value = true;
      final authInfo = Get.find<GlobalController>().authInfo;
      final reponse = await ConversationRepository().readConversation(authInfo.token, authInfo.currentUserId,null);
      Logger.debug(tag, 'response:$reponse');
      final models=reponse.data;
      _next=reponse.next;
      _fetchedList=models;
      conversations.clear();
      conversations.addAll(models); //replace
      conversations.refresh();

    } catch (e) {
      _fetchedList=[];//Must clear old state
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onMessageDeleted(int conversationId, int messageId) {
    ///Better to refresh the all conversation to update the last message
    ///other wise will cause in consistence state
    ///but the problem with refresh it will read the whole conversation again
    ///since we do not have any api to fetch the last message for a particular conversation that is why
    ///the refresh the list only the solution here
    ///but refresh can cause problem to user if we are not implementing the Pagination carefully
    read();
  }

}

// List<ConversationModelHome> generateChatList() {
//   final List<ConversationModelHome> chatList = [
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Robert Alexa',
//       lastMessage: 'How are you?',
//       time: '9:14 PM',
//       isSeen: true,
//       isSent: true,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: '+546964802',
//       lastMessage: 'Ok. I will try my best',
//       time: '6:14 PM',
//       isSeen: false,
//       isSent: false,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Istiak Ahmed',
//       lastMessage: 'I will give you the number',
//       time: '3:12 PM',
//       isSeen: true,
//       isSent: false,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Flora Smith',
//       lastMessage: 'Photo',
//       time: '2:14 PM',
//       isSeen: true,
//       isSent: true,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: '+880 168191044',
//       lastMessage: 'Just try to improve you',
//       time: '10:12 AM',
//       isSeen: false,
//       isSent: true,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Arian Friend',
//       lastMessage: 'Why?',
//       time: '10:12 AM',
//       isSeen: true,
//       isSent: true,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Home',
//       lastMessage: 'Typing...',
//       time: '9:12 AM',
//       isSeen: false,
//       isSent: false,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: '+546964807',
//       lastMessage: 'Here I am giving you',
//       time: '9:26 AM',
//       isSeen: false,
//       isSent: true,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Mostofa Ahad',
//       lastMessage: 'No, I can',
//       time: '8:12 AM',
//       isSeen: true,
//       isSent: false,
//     ),
//   ];
//
//   return chatList;
// }
// final List<MessageModel> _conversations = [
//   MessageModel(
//     message: 'Hi, How are you?',
//     time: '7:03 PM',
//     isAmSender: false,
//     isSeen: true,
//     senderName: 'Alex Robert',
//   ),
//   MessageModel(
//     message: 'Hi, I am fine.',
//     time: '7:04 PM',
//     isAmSender: true,
//     isSeen: true,
//     senderName: 'Alex Robert',
//   ),
//   MessageModel(
//     message: 'What are you doing?',
//     time: '7:05 PM',
//     isAmSender: false,
//     isSeen: true,
//     senderName: 'Alex Robert',
//   ),
//   MessageModel(
//     message: 'I am free now.',
//     time: '7:06 PM',
//     isAmSender: true,
//     isSeen: true,
//     senderName: 'Alex Robert',
//   ),
//   MessageModel(
//     message:
//         'I need a website of my business. I want to develop my business through a website.',
//     time: '7:08 PM',
//     isAmSender: false,
//     isSeen: true,
//     senderName: 'Alex Robert',
//   ),
// ];
// List<ConversationModelHome> generateChatList() {
//   final List<ConversationModelHome> chatList = [
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Robert Alexa',
//       lastMessage: 'How are you?',
//       time: '9:14 PM',
//       isSeen: true,
//       isSent: true,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: '+546964802',
//       lastMessage: 'Ok. I will try my best',
//       time: '6:14 PM',
//       isSeen: false,
//       isSent: false,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Istiak Ahmed',
//       lastMessage: 'I will give you the number',
//       time: '3:12 PM',
//       isSeen: true,
//       isSent: false,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Flora Smith',
//       lastMessage: 'Photo',
//       time: '2:14 PM',
//       isSeen: true,
//       isSent: true,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: '+880 168191044',
//       lastMessage: 'Just try to improve you',
//       time: '10:12 AM',
//       isSeen: false,
//       isSent: true,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Arian Friend',
//       lastMessage: 'Why?',
//       time: '10:12 AM',
//       isSeen: true,
//       isSent: true,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Home',
//       lastMessage: 'Typing...',
//       time: '9:12 AM',
//       isSeen: false,
//       isSent: false,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: '+546964807',
//       lastMessage: 'Here I am giving you',
//       time: '9:26 AM',
//       isSeen: false,
//       isSent: true,
//     ),
//     ConversationModelHome(
//       avatarUrl:
//       'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
//       name: 'Mostofa Ahad',
//       lastMessage: 'No, I can',
//       time: '8:12 AM',
//       isSeen: true,
//       isSent: false,
//     ),
//   ];
//
//   return chatList;
