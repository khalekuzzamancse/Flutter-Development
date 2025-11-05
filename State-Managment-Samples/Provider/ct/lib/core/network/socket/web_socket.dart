import 'dart:convert';
import 'package:get/get.dart';
import 'package:snowchat_ios/core/custom_exception/custom_exception.dart';
import 'package:snowchat_ios/core/network/socket/socket_observer.dart';
import 'package:snowchat_ios/core/network/socket/socket_response_parser.dart';
import 'package:snowchat_ios/core/network/socket/socket_status.dart';
import 'package:snowchat_ios/feature/chat/data/entity/mapper.dart';
import 'package:snowchat_ios/feature/chat/domain/model/conversation_model.dart';
import 'package:snowchat_ios/feature/di/global_controller.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import '../../../feature/chat/data/entity/message_entity.dart';
import '../../../feature/chat/domain/model/message_model.dart';
import '../../../feature/group_chat/domain/group_creation_model.dart';
import '../../misc/logger.dart';

//@formatter:off
///This is singleton
class WebSocketService{
  static const String className = 'WebSocketService';
  WebSocketChannel? _channel;

  ///Should follow UDF,Observer design pattern to reduce couping or cyclic dependency, that why using observer
  static final Map<String, WebSocketObserver> _observers = {};
  static final Map<String, GroupCreationObserver> _groupCreationObserver = {};
  static final Map<String,NewConversationObserver> _newConversationObserver={};

  static void registerAsListener(String observerName, WebSocketObserver observer) {
    _observers[observerName] = observer;
    Logger.debug('$className::registerAsListener', "observers: ${_observers.keys.join(', ')}");
  }
  static void registerAsGroupCreateListener(String observerName, GroupCreationObserver observer) {
    _groupCreationObserver[observerName] = observer;
    Logger.debug('$className::registerAsGroupCreationListener', "observers: ${_observers.keys.join(', ')}");
  }
  static void registerAsConversationObserver(String observerName, NewConversationObserver observer) {
    _newConversationObserver[observerName] = observer;
    Logger.debug('$className::registerAsListener', "observers: ${_newConversationObserver.keys.join(', ')}");
  }

  static void unRegister(String observerName) {
    _observers.remove(observerName);
    _groupCreationObserver.remove(observerName);
    _newConversationObserver.remove(observerName);
    Logger.debug('$className::unRegister', "observers: ${_observers.keys.join(', ')}");
    Logger.debug('$className::unRegister', "groupObservers: ${_groupCreationObserver.keys.join(', ')}");
    Logger.debug('$className::unRegister', "newConversationObserver: ${_newConversationObserver.keys.join(', ')}");
  }


  final StreamController<String> _messageController = StreamController<String>.broadcast();
  Stream<String> get messages => _messageController.stream;

  // Private constructor for singleton
  WebSocketService._privateConstructor();

  // Static instance of WebSocketService
  static final WebSocketService _instance = WebSocketService._privateConstructor();

  /// Public method to access the singleton instance
  factory  WebSocketService() {
    return _instance;
  }
  // Connect to the WebSocket server,it try to connect until get connected
  Future<void> connectBy() async {
    const tag = '$className::connectBy';

    //TODO:Do not check as if (_channel != null) return;
    //because it is possible that channel is exit(not null) but is stream is closed so need to reconnect
    //To prevent reconnect if already is connected try a better approach
    try {
      _channel= await _connectUntilSuccess();
      for (final observer in _observers.values) {
        observer.onConnectionStatusChanged(SocketConnectStatus.connected);
      }
      Logger.logSocket(tag, 'Connected:$_channel');
      //listen method belongs to the Stream not related to channel and this stream belongs to the channel
      _channel!.stream.listen(_onEventFromSocket, onError: _onError, onDone:_onClose);
    } catch (e) {
      Logger.logSocket(tag, 'ExceptionThrown: $e');
    }
  }

  void _onError(Object error){
    const tag = '$className::_onError';
    Logger.logSocket(tag, 'onError: $error');
  }

  ///This method was intended to call when the channel(or it stream) is closed
  ///As result maintaining the single source of truth of notified about closing as well as this place can be
  ///used for try to reconnected when closed
  void _onClose(){
    const tag = '$className::_onDone';
    Logger.logSocket(tag, 'onDone:closeCode: ${_channel?.closeCode},closeReason:${_channel?.closeReason}');
    Logger.logSocket(tag, 'onDone: Connection closed,channel:$_channel');
    for (final observer in _observers.values) {
      observer.onConnectionStatusChanged(SocketConnectStatus.disconnected);
    }
    //TODO:There for whatEver reason the channel(it's stream) is closed this will be executed
    //so it is one of the better place to try for reconnect
    connectBy();

  }

  ///Meant to be used for the Channel::Stream::listen , means the stream event
  void _onEventFromSocket(dynamic response) async{
    final currentUserId=Get.find<GlobalController>().authInfo.currentUserId;
    const tag = '$className::_onEventFromSocket';
    Logger.logSocket(tag, '::listen::response $response');

    final Map<String, dynamic> decodedJson=jsonDecode(response);
    Logger.debug(tag,'::listen:decodedJson:$response');
    final isNewMsg=SocketProtocol.isNewMessageEvent(decodedJson);
    final isAckForMsgReceived=SocketResponseParser.isACKForReceived(decodedJson);
    final isAskForSeen=SocketResponseParser.isACKForSeen(decodedJson);
    //TODO: why a bug why received message is acting as sent message
    if(isNewMsg){
      final newMsg=SocketProtocol.toNewMsgOrNull(decodedJson,currentUserId);
      if(newMsg!=null){
        final conversationId=decodedJson['data']['conversation'];
        for (final observer in _observers.values) {
          observer.onNewMessage(newMsg, conversationId);
        }
        //sent ack that message is received
      try{
        _sentEventOrThrow( SocketProtocol.createMessageReceivedEvent(conversationId, newMsg.id));
      }
        catch(_){}
      }

    }
     if(isAckForMsgReceived){
      //  Logger.logSocket(tag,'::listen::isAckForMsgReceived:$isAckForMsgReceived for:$response');
      final ack=SocketResponseParser.extractAckOrThrow(decodedJson);
      for (final observer in _observers.values) {
        observer.onReceived(ack.conversationId,ack.msgId);
      }
    }
     if(isAskForSeen){
      final ack=SocketResponseParser.extractAckOrThrow(decodedJson);
      for (final observer in _observers.values) {
        observer.onSeen(ack.conversationId,ack.msgId);
      }
      //  Logger.logSocket(tag,'::listen::isAskForSeen:$isAskForSeen for:$response');
    }

    if(SocketProtocol.isDeleteMessageResponse(decodedJson)){
      final record=SocketProtocol.parseAsDeleteResponseOrThrow(decodedJson);
      for (final observer in _observers.values) {
        observer.onMessageDeleted(record.conversationId,record.messageId);
      }
      //  Logger.logSocket(tag,'::listen::isAskForSeen:$isAskForSeen for:$response');
    }
     if(SocketResponseParser.isNewGroupCreateEvent(decodedJson['data'])){
      for (final observer in _observers.values) {
        observer.onNewGroupCreated();
      }
      for (final observer in _groupCreationObserver.values) {
        observer.onNewGroupCreated();
      }
    }
     if(SocketResponseParser.isCreateConversation(decodedJson)){
      if(decodedJson.containsKey('data')){//To avoid side effect and exception
        Logger.temp(tag,'::listen::newConversation:$isAskForSeen for:$response');
        try{
          final entity=SocketResponseParser.parseAsCreatedConversationOrThrow(decodedJson['data']);
          final ConversationModel conversation= ConversationEntityMapper.toModel2([entity]).first;
          for (final observer in _observers.values) {
            observer.onNewConversationOpen(conversation);
          }
          for (final observer in _newConversationObserver.values) {
            if(!conversation.isGroupChat){
              observer.onNewConversationCreated(conversation);
            }

          }
        }
        catch(_){}

        // Logger.logSocket(tag,'::listen::created conversationEntity:$entity');
      }

    }
    _messageController.add(response);
  }

  Future<WebSocketChannel> _connectUntilSuccess() async {
    const tag='$className::_connectUntilSuccess';
    final token=Get.find<GlobalController>().authInfo.token;

    while (true) {
      for (final observer in _observers.values) {
        observer.onConnectionStatusChanged(SocketConnectStatus.connecting);
      }
      //Logger.logSocket(tag, 'connecting with token:$token');
      try {
        final channel = WebSocketChannel.connect(Uri.parse('wss://backend.snowtex.org/ws/chat/$token/'));
        //wait till connected by using the ready feature
        await channel.ready;//TODO:may throw Exception if not able to connect
        return channel;
      } catch (_) {
        await Future.delayed(const Duration(seconds: 3));
      }
    }
  }


  void createPersonalConversation(int userId) {
    const tag = '$className::createPersonalConversation';
    final requestJson=jsonEncode(SocketProtocol.createPersonalConversationStructure(userId));
    Logger.logSocket(tag, 'requestJson:$requestJson');
     _sentEventOrThrow(requestJson);
  }
  void createNewGroup(GroupCreationModel model){
    const tag = '$className::sendPersonalMsgOrThrow';
    final requestJson=jsonEncode(SocketProtocol.createGroupJson(model));
     Logger.logSocket(tag, 'requestJson:$requestJson');
    _sentEventOrThrow(requestJson);
  }

  void sendMsgOrThrow(int conversationId,String msg,List<int> attachmentIds){
    const tag = '$className::sendPersonalMsgOrThrow';
    final requestJson=jsonEncode(SocketProtocol.personalSendMsgStructure(conversationId,msg,attachmentIds));
   // Logger.logSocket(tag, 'requestJson:$requestJson');
    _sentEventOrThrow(requestJson);
  }
  void deleteMessageOrThrow(int conversationId,int messageId){
    const tag = '$className::deleteMessageOrThrow';
    final requestJson=SocketProtocol.createDeleteMessageJson(conversationId,messageId);
    Logger.logSocket(tag, 'requestJson:$requestJson');
    _sentEventOrThrow(requestJson);
  }

  ///TODO:Is early stages, if a message failed to send such as for socket stream or channel closed not able to
  ///handle automatically and does not try re-connect automatically to avoid dead-lock/infinite loop
  ///that is why throw exception on failure
  void _sentEventOrThrow(String message) {
    const tag = '$className::_sentEvent';
    try{
      Logger.logSocket(tag, 'sentEventRequest with data=$message');
      //TODO: as per the concept is channel is closed the reasonCode and message is not null so we can use that
      //to check connected or not.
      //However if find a better way to do that then refactor it
      //TODO: closing the stream will close the connection even if the channel may not be null
      //TODO:Though the the document they promises that close code will be non null but in practical the code sometimes is null
      //even the stream is closed that why commenting the code
     // final isClosed=(_channel == null||_channel!.closeCode!=null); //either channel null or stream is not closed(close code null)
      final isClosed=(_channel == null);//TODO:Refactor , even  there exits a channel(non null) it might be closed(stream closed)
      Logger.logSocket(tag, 'isClosed:$isClosed, closeCode:${_channel?.closeCode},closeReason:${_channel?.closeReason}');
      if (!isClosed) {
         _channel!.sink.add(message);
        Logger.logSocket(tag, 'sent:$message');
      } else {
        Logger.logSocket(tag, 'WebSocket stream is closed');
      }
    }
    catch(e){
      ///TODO:Right now did not find a better way to check if the socket/steam is closed or not
      ///so if closed and try to send message then execution will be here, so in that case handle it
      Logger.logSocket(tag, 'ExceptionCaught:$e');
      //TODO(Refactor) Should throw the exception after converting to appropriate  CustomException
      throw CustomException(message: 'Sent failed', debugMessage: "Source:$tag\n,error:$e");

    }
  }
  void onMessageOpen({required int conversationId, required int messageId}){
    const tag = '$className::onMessageOpen';
    final request=SocketProtocol.createMessageOpenEvent(conversationId, messageId);
    Logger.logSocket(tag,request);
    _sentEventOrThrow(request);
    //Should notify the user that a message is open so that it can react on that
    //Example when this event will trigger from messageList then the chatList will received that event and it change
    //that last message status such as stop lighting
    
    for (final observer in _observers.values) {
      observer.onSeen(conversationId,messageId);
    }

  }

  // Close the WebSocket connection
  void close() {
    _channel?.sink.close();
    _messageController.close();
  }

}

class MsgACK {
  int msgId;
  int conversationId;

  MsgACK({
    required this.msgId,
    required this.conversationId,
  });
}
class DeleteMessageRecord {
  final int conversationId;
  final int messageId;

  DeleteMessageRecord({required this.conversationId, required this.messageId});
}
class SocketProtocol{
  static Map<String,dynamic> createPersonalConversationStructure(int userId){
   return {
      "event":"create_convo",
      "data":{
        "group_name": null,
        "convo_type": 0,
        "is_active": true,
        "group_image": null,
        "users": [userId],
        "admins": []
      }
    };
  }
  static Map<String,dynamic> createGroupJson(GroupCreationModel model){
    final members=[...model.membersId,model.adminId];
    return {
      "event":"create_convo",
      "data":{
        "group_name": model.name,
        "convo_type": 1,
        "is_active": true,
        "group_image": model.imageId,
        "users": members,
        "admins": []
      }
    };
  }
  ///As per backend it will be called for new event such as this device sent message or new message received
  static bool isNewMessageEvent(Map<String, dynamic> json) {
   // Logger.logSocket('SocketDS::toSentMessageOrThrow', "${json['sender']}");
    try{
      return json['event'] == null;
    }
    catch(e){
      return false;
    }

  }

  static String createMessageOpenEvent(int conversationId, int messageId) {
    Map<String, dynamic> eventData = {
      "event": "message_open",
      "data": {
        "conversation": conversationId,
        "message": messageId
      }
    };
    return jsonEncode(eventData);
  }
  static String createMessageReceivedEvent(int conversationId, int messageId) {
    Map<String, dynamic> eventData = {
      "event": "message_received",
      "data": {
        "conversation": conversationId,
        "message": messageId
      }
    };
    return jsonEncode(eventData);
  }

  ///Call this if you sure that sent the message successfully
  ///TODO:Refactor  it later since passing the json so has no type safety so need to handle that edge case
  ///later try to pass type safe instance
  ///Exception safe, handle the exception
  static MessageModel? toNewMsgOrNull(Map<String, dynamic> json,int currentUserId) {
   try{

     final sender=json['data']['sender'];
     var attachmentsList = json['data']['attachments'] as List;
     List<AttachmentEntity> attachments = attachmentsList.map((attachmentJson) => AttachmentEntity.fromJsonOrThrow(attachmentJson)).toList();
     return MessageModel(
       attachments: attachments,
       id: json['data']['id'],
       //TODO: why server send 0 for both send and receive message that is using default=1 means
       //msg is sent because this method was intent to call
       //but while fetching from server is it show sometimes...
       status:json['data']['status'] ,
       message:json['data']['message'],
       time:json['data']['created_at'],
       isAmSender:currentUserId==sender['id'],
       senderName: sender['first_name']+' '+sender['last_name'],
     );
   }
   catch(e){
     return null;
   }
  }
  static Map<String,dynamic> personalSendMsgStructure(int conversationId,String msg,List<int> attachmentIds){
    final attachments=attachmentIds.isNotEmpty?[attachmentIds.first]:[];  //TODO:Fix it later why it wrapping double quote for list
   return {
    "event": "message_send",
    "data": {
    "conversation": conversationId,
    "message": msg,
      "attachments":attachments ,
 //   "attachments":attachmentId==null?[]:[attachmentId] ,
    "sticker": null,
    "message_type": 0
    }
    };

  }


  static String createDeleteMessageJson(int convId, int msgId) {
    Map<String, dynamic> jsonMap = {
      "event": "delete_message",
      "data": {
        "conversation": convId,
        "message": msgId,
      },
    };
    return jsonEncode(jsonMap);
  }
  static bool isDeleteMessageResponse(Map<String, dynamic> response) {
    try {
      return response['event'] == 'delete_message';
    } catch (e) {
      return false;
    }
  }


  static DeleteMessageRecord parseAsDeleteResponseOrThrow(Map<String, dynamic> response) {
  int conversationId = response['data']['data']['conversation'];
  int messageId = response['data']['data']['message'];
  return DeleteMessageRecord(conversationId: conversationId, messageId: messageId);
  }


}




