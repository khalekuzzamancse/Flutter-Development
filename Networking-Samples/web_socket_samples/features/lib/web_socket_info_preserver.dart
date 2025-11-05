import 'package:features/core/ui/core_ui.dart';
import '_payment_models.dart';
import 'core/language/core_language.dart';
class WebSocketInfoPreserver {
  static const _tag = 'PaymentConnectionPreserver';
  static const _keyApi = 'keyApi';
  static const _keySoftwareHouseId = 'softwareHouseId';
  static const _keyDeviceUid = 'keyDeviceUid';
  static const _keyDeviceTid = 'deviceTid';
  static const _keyApiVersion = 'apiVersion';
  static const _keyActiveProtocol = 'activeProtocol';


  static Future<String> buildWebSocketUrlOrThrow()async{
    final  info=await retrieveWebSocket();
    final exception=  CustomException(message: 'Unable to build Url, make sure saved connection info', debugMessage: '$_tag::buildWebSocketUrlOrThrow');

    if(info!=null){
      if(info.apiKey.isEmptyOrBlank()||info.softwareHouseId.isEmptyOrBlank()||
          info.deviceUid.isEmptyOrBlank()||info.tid.isEmptyOrBlank()||info.apiVersion.isEmptyOrBlank()){
        showSnackBar('Make sure saved connection info');
        throw exception;
      }
      return "wss://psa1.paymentsave.co.uk/ws/v1/pos/?api-key=${info.apiKey}&api-version=${info.apiVersion}&software-house-id=${info.softwareHouseId}&device-uid=${info.deviceUid}";
    }
    throw exception;

  }
  static Future<void> clearAll() async {

  }
  static Future<PaySocketInfo> getSocketInfoOrThrow() async {
    final info = await retrieveWebSocket();
    final exception = CustomException(
      message: 'Unable to build AuthInfo, make sure saved connection info',
      debugMessage: '$_tag::buildAuthInfoOrThrow',
    );

    if (info != null) {
      if(info.apiKey.isEmptyOrBlank()||info.softwareHouseId.isEmptyOrBlank()||
          info.deviceUid.isEmptyOrBlank()||info.tid.isEmptyOrBlank()||info.apiVersion.isEmptyOrBlank()){
        showSnackBar('Make sure saved connection info');
        throw exception;
      }
      final authInfo = PaySocketInfo(
        softwareHouseId: info.softwareHouseId,
        deviceUid: info.deviceUid,
        apiVersion: info.apiVersion,
        apiKey: info.apiKey,
        tid: info.tid,
      );

      return authInfo;

    }
    throw exception;
  }



  static Future<String> retrieveTidOrThrow()async{
    final tid ="hello";
    return tid!;
  }

  static Future<dynamic?> retrieveWebSocket() async {

      return null;
  }

}