

import 'package:auth/src/presentation/ui/register_screen.dart';
import 'package:auth/src/presentation/ui/verify_screen.dart';
import 'package:core/ui/core_ui.dart';
import 'package:flutter/material.dart';

import '../logic/logic.dart';
import 'forget_password_screen.dart';
class Navigation{
  static navigateToRegister(BuildContext context){
    context.push(const RegisterScreen());
  }
  static navigateToResetPassword(BuildContext context){
    context.push(const ForgetPasswordScreen());
  }
  static navigateToVerifyScreen(BuildContext context,VerificationController controller){
    context.push( VerifyCodeScreen(controller: controller));
  }


}