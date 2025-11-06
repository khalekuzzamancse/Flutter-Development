part of '../../core_network.dart';

abstract interface class SocketEventObserver {
  void onEvent(dynamic response);
  void onConnecting();
  void onConnected();
  void onDisconnected();
}

abstract interface class WebSocket {
  bool isChannelEstablished();
  void registerAsListener(String observerName, SocketEventObserver observer);
  void unRegister(String observerName);
  Future<void> connectTry(String url);
  void sentEventOrThrow(String message);
  Future<void> closeTry();
  static WebSocket  getInstance() {
    return WebSocketImpl._instance;
  }

}


//@formatter:off
///This is singleton
class WebSocketImpl implements WebSocket{
  static const tag='WebSocketImpl';
   @override
  bool isChannelEstablished(){
    return _channel!=null;
  }
  ///Should follow UDF,Observer design pattern to reduce couping or cyclic dependency, that why using observer
  static final Map<String, SocketEventObserver> _observers = {};

  //@formatter:off
   @override
  void registerAsListener(String observerName, SocketEventObserver observer) {
    _observers[observerName] = observer;
    Logger.on('$tag::registerAsListener', "observers: ${_observers.keys.join(', ')}");
    if(isChannelEstablished()){
      _onConnected();
    }
    else{
      _onDisconnected();
    }
  }

//@formatter:off
   @override
  void unRegister(String observerName) {
    _observers.remove(observerName);
    Logger.on('$tag::unRegister', "observers: ${_observers.keys.join(', ')}");
  }
  static const String className = 'WebSocketService';
  WebSocketChannel? _channel;

   void _onEachObserver(Function(SocketEventObserver) callback){
    for(final observer in _observers.values){
      callback(observer);
    }
  }

  // Private constructor for singleton
  WebSocketImpl._();

  // Static instance of WebSocketService
  static final WebSocketImpl _instance = WebSocketImpl._();

  @override
  Future<void> connectTry(String url) async {
    const tag = '$className::_connectTry';
    //TODO:Do not check as if (_channel != null) return;
    //because it is possible that channel is exit(not null) but is stream is c+losed so need to reconnect
    //To prevent reconnect if already is connected try a better approach
    try {
      _onConnecting();
      _channel= await _connectOrThrow(url);
      Logger.on(tag, 'Channel:$_channel');
      _onConnected();
      //listen method belongs to the Stream not related to channel and this stream belongs to the channel
      _channel!.stream.listen(_onEventFromSocket, onError: _onError, onDone:_onClose);
    } catch (e,trace) {
      Logger.errorCaught(className,'_connectTry', e,trace);
      _onDisconnected();

    }
  }
  void _onError(Object error){
    const tag = '$className::_onError';
    Logger.on(tag, 'onError: $error');
  }
  void _onConnecting(){
    _channel=null; //clear old channel if any
    _onEachObserver((observer){
      observer.onConnecting();
    });
  }
  void _onConnected(){
    _onEachObserver((observer){
      observer.onConnected();
    });
  }
   void _onDisconnected(){
    _channel=null;
    _onEachObserver((observer){
      observer.onDisconnected();
    });
  }

  ///This method was intended to call when the channel(or it stream) is closed
  ///As result maintaining the single source of truth of notified about closing as well as this place can be
  ///used for try to reconnected when closed
  void _onClose(){
    const tag = '$className::_onDone';
    Logger.off(tag, 'onDone:closeCode: ${_channel?.closeCode},closeReason:${_channel?.closeReason}');
    Logger.off(tag, 'onDone: Connection closed,channel:$_channel');
    _onDisconnected();
  }

  ///Meant to be used for the Channel::Stream::listen , means the stream event
  void _onEventFromSocket(dynamic response) async{
    const tag='$className::_onEventFromSocket';
    try{
      final Map<String, dynamic> decodedJson=jsonDecode(response);
      Logger.on(tag, 'response: $decodedJson');
      _onEachObserver((observer){
        observer.onEvent(response);
      });
    }
    catch(e,trace){
      Logger.on(tag,'response:$response');
      Logger.errorCaught(className,'_onEventFromSocket',e,trace);
    }

  }

  Future<WebSocketChannel> _connectOrThrow(String url) async {
    const tag='$className::_connectOrThrow';
    try {
      Logger.on(tag, 'Url:$url');
      // const String wsUrl = "wss://psa1.paymentsave.co.uk/ws/v1/pos/?data_source-key=a03bdd29-afec-4f1f-ba9e-c82c23b28aa1&data_source-version=v1&software-house-id=V7BYZNI7&device-uid=T1R236HN";
      //   const urlTest='wss://echo.websocket.events';
      final channel = WebSocketChannel.connect(Uri.parse(url));
      await channel.ready;//TODO:may throw Exception if not able to connect
      return channel;
    } catch (e,trace) {
      Logger.errorCaught(className, '_connectOrThrow',e,trace);
      throw CustomException(message: 'Channel creation failed', debugMessage: tag);
    }

  }


  ///TODO:Is early stages, if a message failed to send such as for socket stream or channel closed not able to
  ///handle automatically and does not try re-connect automatically to avoid dead-lock/infinite loop
  ///that is why throw exception on failure
  @override
  void sentEventOrThrow(String message) {
    const tag = '$className::_sentEvent';
    try{
      Logger.on(tag, 'sentEventRequest with source=$message');
      //TODO: as per the concept is channel is closed the reasonCode and message is not null so we can use that
      //to check connected or not.
      //However if find a better way to do that then refactor it
      //TODO: closing the stream will close the connection even if the channel may not be null
      //TODO:Though the the document they promises that close code will be non null but in practical the code sometimes is null
      //even the stream is closed that why commenting the code
      // final isClosed=(_channel == null||_channel!.closeCode!=null); //either channel null or stream is not closed(close code null)
      final isClosed=(_channel == null);//TODO:Refactor , even  there exits a channel(non null) it might be closed(stream closed)
      Logger.off(tag, 'isClosed:$isClosed, closeCode:${_channel?.closeCode},closeReason:${_channel?.closeReason}');
      if (!isClosed) {
        _channel!.sink.add(message);
        Logger.off(tag, 'sent:$message');
      } else {
        Logger.off(tag, 'WebSocket stream is closed');
      }
    }
    catch(e){
      ///TODO:Right now did not find a better way to check if the socket/steam is closed or not
      ///so if closed and try to send message then execution will be here, so in that case handle it
      Logger.off(tag, 'ExceptionCaught:$e');
      //TODO(Refactor) Should throw the exception after converting to appropriate  CustomException
      throw CustomException(message: 'Sent failed', debugMessage: "Source:$tag\n,error:$e");
    }
  }
  // Close the WebSocket connection
  @override
  Future<void> closeTry()async {
    try{
      await delayInSecond(2); //Just for fake loading test
      const tag = '$className::close';
      final response= await _channel?.sink.close();
      Logger.on(tag, '$response');
      _channel=null;
     _onDisconnected();
    }
    catch(_){

    }
  }

}