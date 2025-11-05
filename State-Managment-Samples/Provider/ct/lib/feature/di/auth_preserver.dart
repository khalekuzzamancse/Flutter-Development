import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/misc/logger.dart';
import 'global_controller.dart';

class Preserver {
  static const String _keyToken = 'token';
  static const String _keyUserId = 'user_id';
  static const String _keyWelcomeScreenShown = 'welcome_screen_shown';

  static Future<void>  addAuthDetails(AuthInfo authInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, authInfo.token);
    await prefs.setInt(_keyUserId, authInfo.currentUserId);
    getAuthInfo(); //Just for Log
  }

  static Future<bool?> shouldShowWelcomeScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  return  prefs.getBool(_keyWelcomeScreenShown);
  }
  static Future<void> welcomeScreenShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyWelcomeScreenShown, true);
  }

 static Future<AuthInfo?> getAuthInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_keyToken);
    int? userId = prefs.getInt(_keyUserId);
    if (token != null && userId != null) {
      final authInfo=AuthInfo(token: token, currentUserId: userId);
      Logger.authInfoLog('AuthPreserver::getAuthInfo','authInfo:$authInfo');
      return  authInfo;
    }
    return null;
  }

 static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
  }

}
