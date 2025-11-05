//@formatter:off
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/feature/misc/presentation/ui/core.dart';
import '../../../../core/ui/buttons.dart';
import '../../../navigation/routes.dart';
import '../presentationLogic/forget_password_controller.dart';
import 'core.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final  controller = Get.put(ForgetPasswordController());
    return GenericScreen(
        content:  Padding(
      padding: const EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        child: _LayoutStrategy(
            header: const _Header(),
            phoneNoField: PhoneNumberPicker(
                onCountryCodeChanged: (value ) {  },
                onNumberChanged: (value){},
                onFullNumberChanged:controller.onPhoneNoChanged),
            action: RoundedButton(
              label: 'Next',
              height:48,onPressed: ()async {
              FocusScope.of(context).unfocus();//Hide soft keyboard
              if(await  controller.sendVerificationCode()){
                Navigation.goToSetNewPassword(context);
              }
            })),
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

