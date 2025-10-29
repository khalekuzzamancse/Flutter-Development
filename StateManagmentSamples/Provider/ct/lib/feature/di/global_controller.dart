
import 'dart:ui';

import 'package:get/get.dart';

import 'auth_preserver.dart';
import '../../core/custom_exception/src/custom_exception.dart';
import '../../core/misc/logger.dart';
import '../../core/network/socket/web_socket.dart';

class AuthInfo {
  final String token;
  final int currentUserId;

  AuthInfo({required this.token, required this.currentUserId});

  @override
  String toString() {
    return 'AuthInfo(token: $token, userId: $currentUserId)';
  }
}

///handle snackBar message
///handle other global value such as token

class GlobalController extends GetxController {
  final _className = 'GlobalController';
  var errorMsg = Rx<String?>(null);
  late AuthInfo authInfo;
  VoidCallback? _loginSessionObserver;


  void setLoginSessionExpire(VoidCallback onSessionExpire) {
    _loginSessionObserver = onSessionExpire;
  }

  ///Call it from  when session is expire
  void onLoginSessionExpire() {
    final tag = '$_className::onLoginSessionExpire';
    Logger.temp(tag, 'Session expired called');
    if (_loginSessionObserver != null) {
      final tag = '$_className::onLoginSessionExpire';
      Logger.temp(tag, 'calling observer');
      _loginSessionObserver!();
    }
  }

  void showSnackBar(String msg) {
    //For maintaining singleton
    Get.find<GlobalController>().updateErrorMessage(msg);
  }

  void updateErrorMessage(String message) {
    //if the message is same as the previous it can cause side effect such as not Render the UI so need to clear the old message
    //If already the same message is showing,then skip the new message

    final alreadyTheSameMsgIsShowing=(errorMsg.value==message);
    if(alreadyTheSameMsgIsShowing){
      return;
    }

    errorMsg.value = null;
    const tag = 'className::updateErrorMessage';
    errorMsg.value = message;
    Logger.temp(tag, 'newErrorMsg:$errorMsg}');
    Logger.debug(tag, '${errorMsg.value}');
    errorMsg.refresh();
    // Clear the error message after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      errorMsg.value = null;
      Logger.debug(tag, '${errorMsg.value}');
    });
  }

  ///Token, userId should be update via this
  void updateAuthInfo(AuthInfo info) async {
    Get.find<GlobalController>().authInfo = info;
    //update the token
    //Now token is available so make sense to initialize the socket
    await Preserver.addAuthDetails(info);
    WebSocketService().connectBy();
  }

  void onError(Object exception) {
    final tag = "$_className::onError()";
    final observer = _loginSessionObserver; //capture it
    if (exception is AuthTokenExpireException) {
      Logger.temp(tag, 'token expire');
      if (observer != null) {
        Logger.temp(tag, 'token expire:observer calling');
        observer();
      }
    }
    Logger.debug(tag, "$exception");
    if (exception is CustomException) {
      showSnackBar(exception.message);
    }
  }
}
