import 'package:core/ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../_core/text_fields.dart';
import '../logic/forget_password_controller.dart';
import '../_core/resource_factory.dart';
import '../_core/button.dart';
import '../_core/misc.dart';
import '../_core/screens.dart';

//@formatter:off
class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgetPasswordController>();
    final otpController=TextEditingController();
    final passwordController=TextEditingController();
    return GenericScreen(content:  SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints:const BoxConstraints(
                  maxWidth: 500
              ),
                child: Column(
                  children: [
                    const _Header(),
                    const SpacerVertical(32),
                    AuthTextField(
                      controller: otpController,
                      keyboardType:TextInputType.number ,
                      label: 'OTP Code',
                    ),
                    const SpacerVertical(8),
                    AuthTextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      label: 'New Password',
                    ),
                    const SpacerVertical(64),
                    RoundedButton(
                        label: 'Finish',
                        height: 48,
                        onPressed: () async{
                          Navigator.pop(context); //Go to reset password
                          Navigator.pop(context); //Go to Login
                          // if(await controller.resetPassword()){
                          //   Navigator.pop(context); //Go to reset password
                          //   Navigator.pop(context); //Go to Login
                          //
                          // }
                        }
                    )
                  ],
                ),
              ),
            ),
          )

      ),
    ));
  }

}


class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Logo(),
        Text(
          "Forget Password Confirm",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.headingText,
          ),
        ),
      ],
    );
  }
}

