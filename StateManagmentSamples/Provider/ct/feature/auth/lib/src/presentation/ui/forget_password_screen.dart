//@formatter:off
import 'package:auth/src/presentation/ui/set_new_passwrod_screen.dart';
import 'package:core/ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../_core/text_fields.dart';
import '../logic/forget_password_controller.dart';
import '../_core/button.dart';
import '../_core/misc.dart';
import '../_core/screens.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final  controller = Get.put(ForgetPasswordController());
    final inputController=TextEditingController();
    String? error;
    return GenericScreen(
        content:  Padding(
      padding: const EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
                  constraints:const BoxConstraints(
                      maxWidth: 500
                  ),
            child: _LayoutStrategy(

                header: const _Header(),
                phoneNoField: AuthTextField(
                  controller: inputController,
                  label: 'Phone number or email',
                  leadingIcon: Icons.person,
                  keyboardType: TextInputType.number,
                  errorText: error,
                  onDone: () {

                  },),
                action: RoundedButton(
                  label: 'Next',
                  height:48,onPressed: ()async {
                  context.push(SetNewPasswordScreen());
                  FocusScope.of(context).unfocus();//Hide soft keyboard
                  if(await  controller.sendVerificationCode()){
                    //context.push(SetNewPasswordScreen());

                  }
                })),
          ),
        ),
      ),
    ));
  }
}


class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Logo(),
        Text(
          "Forger Password",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color:Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}


class _LayoutStrategy extends StatelessWidget {
  final Widget header, phoneNoField, action;

  const _LayoutStrategy({
    Key? key,
    required this.header,
    required this.phoneNoField,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          minWidth: 300,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            header,
            const SizedBox(height: 32),
            phoneNoField,
            const SizedBox(height: 32),
            action,
          ],
        ),
      ),
    );
  }
}

