import 'package:get/get.dart';
import 'package:snowchat_ios/core/network/socket/socket_status.dart';
import 'package:snowchat_ios/core/network/socket/web_socket.dart';
import 'package:snowchat_ios/feature/chat/presentation/presentationLogic/picked_media_model.dart';
import 'package:snowchat_ios/feature/di/global_controller.dart';
import '../../../../core/data/media_repository.dart';
import '../../../../core/misc/logger.dart';
import '../../../../core/network/socket/socket_observer.dart';
import '../../domain/model/message_model.dart';
import '../../data/repository/converstation_repository.dart';
import '../../domain/model/conversation_model.dart';

//@formatter:off
class MessageController extends GetxController implements WebSocketObserver{
  ///Making it nullable will prevent the invalid api request
 final int conversationId;
  final _class='MessageController';
  late final authInfo = Get.find<GlobalController>().authInfo;
  var messages = <MessageModel>[].obs;
  var isLoading=false.obs;
  String? _next;

   MessageController(this.conversationId){
    WebSocketService.registerAsListener(_class,this);
    readMessages();
   }
   ///Call when back from the screen so need to clean up or un register something
   void onExit(){
     WebSocketService.unRegister(_class);
   }
   void onBeggingOfMessageList(){

   }
   void onEndOfMessageList(){
     final tag='$_class::onEndOfMessageList';
     Logger.debug(tag, '$_next');
     final next=_next;//capture as immutable of the mutable copy to avoid risk of crash or safe access
     if(next!=null){
       _paginationRead(next);
     }
   }


@override
  void onNewMessage(MessageModel model,int conversationId){
  final tag='$_class::onNewMessage';
     if(conversationId!=this.conversationId) {
       return;
     }
    Logger.temp(tag, '$model');
    messages.insert(0, model); //Must insert at begging
    messages.refresh();
  final isMessageReceived = !model.isAmSender;
      _sendMsgOpenAckOrDoNothing(); //This controller is using means user in the message list so need to sent ACK for msg seen
    _notifyObserver();

  }
  @override
  void onReceived(int conversationId,int messageId){
    final shouldUpdateCurrentMsgList=(conversationId==this.conversationId);
    if(shouldUpdateCurrentMsgList){
      _updateMessageStatus(messageId,1);//1=Received
    }

  }
  @override
  void onSeen(int conversationId,int messageId){
    final shouldUpdateCurrentMsgList=(conversationId==this.conversationId);
    if(shouldUpdateCurrentMsgList){
      _updateMessageStatus(messageId,2);//2=Seen
    }
  }

  void _updateMessageStatus(int messageId,int newStatus){
    final tag='$_class::_updateMessageStatus';
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      Logger.debug(tag, 'messageId:$messageId,newStatus:$newStatus');
      final updated = messages[index].copyWith(status: newStatus);
      messages[index] = updated;
      messages.refresh();
      _notifyObserver();
    }
  }
///Just a wrapper around the _read() for safe access to avoid infinite fetching
  void _paginationRead(String url)=>_read(url);
   void readMessages() async {
     _read(null);
  }

  ///url is nullable means for the initial load the url is null
 /// if the consumer/client is uses tha method for initial load then pass url=null
 /// but for pagination must pass a link otherwise it will do infinite next, as  a cycle
  Future<void> _read(String? url) async{
    final tag='$_class::read()';
    try {
      isLoading.value=true;
      final response = await ConversationRepository().readMessages(authInfo.token, authInfo.currentUserId,conversationId,url);
      Logger.debug(tag, 'responseData:${response.data}');
      Logger.debug(tag, 'responsePaginationInfo:Next${response.next}');
      final message=response.data.map((msg)=>msg.message).toList();
      Logger.debug(tag, 'message:$message');
      Logger.debug(tag, 'response:${response.data.length}');
      //Used for pagination nso not deleting the old message
    //  messages.clear(); // remove old message if any
      messages.addAll(response.data);
      messages.refresh();
      _next=response.next;
      //Read is called basically when chat list is opened so make sense to sent the ack for msg open event
      _sendMsgOpenAckOrDoNothing();
    } catch (e,trace) {
      Logger.errorWithTrace(tag, trace);
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }

  }



   ///Sometimes GetX may properly notify that is why forcefully notifying
   void _notifyObserver(){
     isLoading.value=true;
     isLoading.value=false;
   }
  void _sendMsgOpenAckOrDoNothing(){
    final tag='$_class::_sendMsgOpenAck()';
    try{
     final lastMsg= messages.first;
     final isMessageReceived = !lastMsg.isAmSender;
     if(isMessageReceived){
       //As per back-end , it is okay to sent the ack for last message
       //If not work then do for all that msg that status<2;
       WebSocketService().onMessageOpen(conversationId: conversationId, messageId: lastMsg.id);
     }

    }
    catch(_){}
  }

  void deleteMessage(int msgId){
      final tag = '$_class::deleteMessage()';
      final conversationId=this.conversationId;//Capture the state because it might change immediately such as user go back
      try{
        isLoading.value=true;
        WebSocketService().deleteMessageOrThrow(conversationId, msgId);
        isLoading.value=false;
      }
      catch(e){
        Get.find<GlobalController>().onError(e);
      }

  }
  void sendMsg(String msg,List<PickedMediaModel> attachments) async{
    final tag = '$_class::sendMsg()';
    final conversationId=this.conversationId;//Capture the state because it might change immediately such as user go back
    final token = Get.find<GlobalController>().authInfo.token;

   try{
      isLoading.value=true;

     final List<int> ids=[];
     if(attachments.isNotEmpty)
     {
       Logger.debug(tag, 'attachments=$attachments');
       for(final media in attachments){
         final docId= await MediaRepository().uploadFileOrThrow(path: media.path,token: token,type: media.type);
         ids.add(docId.id);
       }
       Logger.debug(tag, 'ids=$ids');
     }

     WebSocketService().sendMsgOrThrow(conversationId, msg,ids);
     isLoading.value=false;

   }
    catch(e){
      Get.find<GlobalController>().onError(e);
    }

  }

  @override
  void onNewConversationOpen(ConversationModel model) {

  }

  @override
  void onConnectionStatusChanged(SocketConnectStatus status) {

  }

  @override
  void onNewGroupCreated() {
    // TODO: implement onNewGroupCreated
  }

  @override
  void onMessageDeleted(int conversationId, int messageId) {
     if(conversationId!=this.conversationId) {
       return;
     }
    messages.removeWhere((message) => message.id ==messageId);
     messages.refresh();
     _notifyObserver();
  }

}

