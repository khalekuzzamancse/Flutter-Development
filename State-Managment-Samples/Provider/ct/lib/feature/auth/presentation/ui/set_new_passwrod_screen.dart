import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/core/ui/spacer.dart';
import 'package:snowchat_ios/feature/misc/presentation/ui/core.dart';
import '../../../../core/ui/app_color.dart';
import '../../../../core/ui/buttons.dart';
import '../presentationLogic/forget_password_controller.dart';
import 'core.dart';

//@formatter:off
class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgetPasswordController>();
    return GenericScreen(content:  SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const _Header(),
              const SpacerVertical(32),
              CustomOutlinedTextField(
                  value: controller.phoneNumber,
                  readOnly: true,
                  label: 'Phone Number',
                  onChange: (value){},
                  hint: 'Phone Number'),
              const SpacerVertical(8),
              CustomOutlinedTextField(
                label: 'OTP Code',
                onChange:controller.onOtpChanged,
                hint: 'OTP Code',
              ),
              const SpacerVertical(8),
              PasswordField(
                onInputChanged:controller.onNewPasswordChanged,
                hints: 'New Password',
              ),
              const SpacerVertical(64),
              RoundedButton(
                  label: 'Finish',
                  height: 48,
                  onPressed: () async{
                    if(await controller.resetPassword()){
                      Navigator.pop(context); //Go to reset password
                      Navigator.pop(context); //Go to Login

                    }
                  }
              )
            ],
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

