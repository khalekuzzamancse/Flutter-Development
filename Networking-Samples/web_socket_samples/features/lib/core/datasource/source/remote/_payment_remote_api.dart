library web_socket;
import 'dart:convert';
import 'dart:async';

import 'package:features/core/datasource/source/remote/remote_data_source.dart';

import '../../../language/core_language.dart';
import '../../../network/core_network.dart';
import '../../../network/web_socket_impl.dart';
import '../../../../web_socket_info_preserver.dart';
import '../../api/apis.dart';


 class PaymentWebSocketApiImpl implements PaymentApi, SocketEventObserver {
  late final tag = runtimeType.toString();
  static final Map<String, PaymentConnectionObserver> _observers = {};
  var _cancellable=true;
  late final socket=WebSocket.getInstance();

  PaymentWebSocketApiImpl() {
    socket.registerAsListener(tag, this);
  }

  @override
  void registerAsListener(PaymentConnectionObserver listener) {
    final observerName = listener.runtimeType.toString();
    _observers[observerName] = listener;
    Logger.on('$tag::registerAsListener', "observers: ${_observers.keys.join(', ')}");
    if(isConnected()){
      _onEachConnectionObserver((observer){
        observer.onConnected();
      });
    }
  }

  @override
  void unregister(PaymentEventObserver listener) {
    socket.unRegister(tag);
    final observerName = listener.runtimeType.toString();
    _observers.remove(observerName);
    Logger.on('$tag::unRegister', "observers: ${_observers.keys.join(', ')}");
  }

  @override
  bool isConnected() =>socket.isChannelEstablished();

  @override
  Future<void> cancelTransaction() async {
    final tid = await WebSocketInfoPreserver.retrieveTidOrThrow();
    final payload = PayloadCreator.createCancelTransactionPayload(tid);
    Logger.off(tag, 'startTransaction::payload:$payload');
    socket.sentEventOrThrow(jsonEncode(payload));
  }

  void connectWebSocket({required String softwareHouseId,
    required String deviceUid, required String apiVersion, required String apiKey, required String tid}) async {
    if (isConnected()) {
    // onConnected(); //notify so that can start transaction
      return;
    }
    try {
      final url=UrlProvider.ins.buildPaySocketUrl(softwareHouseId: softwareHouseId, deviceUid: deviceUid, apiVersion: apiVersion, apiKey: apiKey, tid: tid);
      Logger.off('$tag::connectWithLastUrl', "url:$url");
      await socket.connectTry(url);
    } catch (e) {
      Logger.off('$tag::connectWithLastUrl', "error:$e");
    }
  }

  @override
  Future<void> disconnectOrThrow() => socket.closeTry();


  @override
  void startTransaction(
      {required double amount,
      required double discount,
      required double cashback,
      required double gratuity}) async {
    try {
      _onEachPayEventObserver((listener) {
        listener.onTransactionRequesting();
      });

      final tid = await WebSocketInfoPreserver.retrieveTidOrThrow();
      final payload = PayloadCreator.createSalePayload(
          amount: amount,
          tid: tid,
          discount: discount,
          gratuity: gratuity,
          cashback: cashback);
      Logger.off(tag, 'startTransaction::payload:$payload');
     socket.sentEventOrThrow(jsonEncode(payload));
    } catch (e,trace) {
      Logger.errorCaught(tag,'startTransaction', e,trace);
    }
  }

  @override
  void onConnected() {
    _onEachConnectionObserver((listener) {
      listener.onConnected();
    });
  }

  @override
  void onConnecting() {
    _onEachConnectionObserver((listener) {
      listener.onConnecting();
    });
  }

  @override
  void onDisconnected() {
    _onEachConnectionObserver((listener) {
      listener.onDisconnected();
    });
  }

  @override
  void onEvent(response) {
    Logger.on('$tag::_onEventFromSocket', "$response");
    try {
      final json = jsonDecode(response);
      if (SocketEventDetector.isConnectionEvent(json)) {
        _onConnectionEvent(json);
        return;
      }
      if (SocketEventDetector.isTransactionInProgress(json)) {
        _onTransactionInProgress(json);
        return;
      }
      if (SocketEventDetector.isTransactionSuccess(json)) {
        _onEachPayEventObserver((listener) {
          listener.onTransactionSuccess();
        });
        return;
      }
      if (SocketEventDetector.isTransactionCancelled(json)) {
        _onEachPayEventObserver((listener) {
          listener.onTransactionCancelled();
        });
        return;
      }
      if (SocketEventDetector.isError(json)) {
        _onErrorEvent(json);
        return;
      }
    } catch (e) {
      Logger.on('$tag::_onEventFromSocket', "Exception:$e");
    }
  }

  void _onErrorEvent(Json json) {
    try {
      final message = SocketEventParser.parserErrorOrThrow(json);
      Logger.off(tag, '_onErrorEvent::$message');
      _onEachConnectionObserver((listener) {
        listener.onError(message);
      });

    } catch (_) {}
  }

  void _onConnectionEvent(Json json) {
    try {
      final status = SocketEventParser.parserStatusOrThrow(json);
      final isConnected = status.toLowerCase() == 'connected';
      if (isConnected) {
        _onEachConnectionObserver((listener) {
          listener.onConnected();
        });
      }
    } catch (_) {}
  }

  void _onTransactionInProgress(Json json) {
    try {
      final message = SocketEventParser.parserInProgressMessageOrThrow(json);
      _onEachPayEventObserver((listener) {
        listener.onTransactionInProgress(message,cancellable: _cancellable);
      });
      //after card disable should not be cancel
      final cardScreenDisplayed=(message== "GetCard Screen Displayed");
      if(cardScreenDisplayed){
        _cancellable=false;
      }


    } catch (_) {}
  }
  void _onEachConnectionObserver(Function(PaymentConnectionObserver) callback) {
    for (final observer in _observers.values) {
      callback(observer);
    }
  }
  void _onEachPayEventObserver(Function(PaymentEventObserver) callback) {
    for (final observer in _observers.values) {
      if(observer is PaymentEventObserver){
        callback(observer);
      }

    }
  }






}



class SocketEventDetector {
  static bool isEvent(Map<String, dynamic> response) {
    return response.containsKey('event');
  }

  static bool isConnectionEvent(Json json) {
    return json.containsKey('status');
  }

  static bool isError(Map<String, dynamic> response) {
    return response.containsKey('error');
  }

  static bool isTransactionInProgress(Map<String, dynamic> response) {
    try {
      return response['event'] == 'CONNECT_TERMINAL_NOTIFICATION';
    } catch (_) {}
    return false;
  }

  static bool isTransactionSuccess(Json response) {
    try {
      if (response['event'] != 'SALE_COMD_RESULT') {
        return false;
      }
      final data = response['data'] as Json;
      final message = data['message'] as Json;
      return message['Approved'] == true;
    } catch (_) {}
    return false;
  }

  static bool isTransactionCancelled(Json response) {
    try {
      if (response['event'] != 'SALE_COMD_RESULT') {
        return false;
      }
      final data = response['data'] as Json;
      final message = data['message'] as Json;
      return message['Cancelled'] == true;
    } catch (_) {}
    return false;
  }

  static bool isRefundStarted(Map<String, dynamic> response) {
    try {
      return response['event'] == 'CONNECT_REFUND_NOTIFICATION';
    } catch (_) {}
    return false;
  }
}

class PayloadCreator {
  //@formatter:off
  static Map<String, dynamic> createSalePayload(
      {required double amount,
        double discount =0,
        required String tid,
        double gratuity=0,
        cashback=0
      }) {
    return {
      "event":"CONNECT_RUN_SALE",
      "message": {
        "tid":tid,
        "currency":"GBP",
        "amount":amount*100.toInt(),
        "discount":0,
        "gratuity":0,
        "cashback":0,
        "print_receipt":false
      }
    };

  }

  static Map<String, dynamic> createRefundPayload({required double amount,required String tid}) {
    return {
      "event": "CONNECT_RUN_REFUND",
      "message": {
        "tid": tid,
        "currency": "GBP",
        "amount": amount,
        "refund_uti": "C3GHDDH-R3567GHF-45GFDDGBH-85FDDGHDF",
        "receipt_print": false
      }
    };
  }

  //@formatter:off
  static Map<String, dynamic> createCancelTransactionPayload(String tid) {
    return {
      "event": "CONNECT_CANCEL_TRANSACTION",
      "message": {"tid": tid}
    };
  }
  //@formatter:off
  Map<String, dynamic> createXReportPayload(String tid) {
    return
      {
        "event":"CONNECT_RUN_XREPORT",
        "message":{
          "tid":tid,
          "receipt_print":false
        }
      };
  }
  //@formatter:off
  static Map<String, dynamic> createRePrintPayload({required String tid,required String uti}) {
    return
      {
        "event":"CONNECT_REPRINT_RECEIPT",
        "message":{
          "tid":tid,
          "uti":uti
        }
      };
  }
}
class SocketEventParser {
  static String parserErrorOrThrow(Json json) {
    final error = json['error'] as Json;
    return error['message'];
  }

  static String parserInProgressMessageOrThrow(Json json) {
    final data = json['data'] as Json;
    return data['message'];
  }

  static String parserStatusOrThrow(Json json) {
    return json['status'];
  }
}





