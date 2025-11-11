import 'package:get/get.dart';
import 'model.dart';

//@formatter:off
class MessageController{
  ///Making it nullable will prevent the invalid api request
 final int conversationId;
  final _class='MessageController';
  var messages = <MessageModel>[].obs;
  var isLoading=false.obs;
  String? _next;
   MessageController(this.conversationId){
    readMessages();
   }
   ///Call when back from the screen so need to clean up or un register something
   void onExit(){
   }
   void onBeggingOfMessageList(){

   }
   void onEndOfMessageList(){
     final tag='$_class::onEndOfMessageList';
     final next=_next;//capture as immutable of the mutable copy to avoid risk of crash or safe access
     if(next!=null){
       _paginationRead(next);
     }
   }



  void onNewMessage(MessageModel model,int conversationId){
  final tag='$_class::onNewMessage';
     if(conversationId!=this.conversationId) {
       return;
     }

    messages.insert(0, model); //Must insert at begging
    messages.refresh();
  final isMessageReceived = !model.isAmSender;
      _sendMsgOpenAckOrDoNothing(); //This controller is using means user in the message list so need to sent ACK for msg seen
    _notifyObserver();

  }

  void onReceived(int conversationId,int messageId){
    final shouldUpdateCurrentMsgList=(conversationId==this.conversationId);
    if(shouldUpdateCurrentMsgList){
      _updateMessageStatus(messageId,1);//1=Received
    }

  }

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

    } catch (e,trace) {

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
     //  WebSocketService().onMessageOpen(conversationId: conversationId, messageId: lastMsg.id);
     }

    }
    catch(_){}
  }

  void deleteMessage(int msgId){
      final tag = '$_class::deleteMessage()';
      final conversationId=this.conversationId;//Capture the state because it might change immediately such as user go back
      try{
        isLoading.value=true;
      //  WebSocketService().deleteMessageOrThrow(conversationId, msgId);
        isLoading.value=false;
      }
      catch(e){

      }

  }
  void sendMsg(String msg,List<PickedMediaModel> attachments) async{
    final tag = '$_class::sendMsg()';
    final conversationId=this.conversationId;//Capture the state because it might change immediately such as user go back


   try{


   }
    catch(e){

    }

  }

  void onMessageDeleted(int conversationId, int messageId) {
     if(conversationId!=this.conversationId) {
       return;
     }
    messages.removeWhere((message) => message.id ==messageId);
     messages.refresh();
     _notifyObserver();
  }

}

