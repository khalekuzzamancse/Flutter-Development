import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/core/ui/loading_overlay.dart';
import 'package:snowchat_ios/core/ui/spacer.dart';
import 'package:snowchat_ios/feature/auth/presentation/presentationLogic/register_controller.dart';
import 'package:snowchat_ios/feature/misc/presentation/ui/core.dart';
import '../../../../core/ui/app_color.dart';
import '../../../../core/ui/buttons.dart';
import '../../../navigation/routes.dart';
import 'core.dart';

//@formatter:off
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.put(RegisterController());
    return
      Obx((){
        final isLoading=controller.isLoading.value;
        return GenericScreen(
          title: '',
          content: LoadingOverlay(isLoading: isLoading,
              content: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: SingleChildScrollView(

                      child: ConstrainedBox(
                        constraints:const BoxConstraints(
                            maxWidth: 500
                        ),
                        child: Column(
                          children: [
                            const _Header(),
                            const SizedBox(height:24),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: "First Name",
                                    leadingIcon: Icons.person_outline,
                                    onChanged: controller.onFirstNameChanged,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    label: "Last Name",
                                    onChanged: controller.onLastNameChanged,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: "Email",
                              leadingIcon: Icons.email_outlined,
                              onChanged: controller.onEmailChanged,
                            ),
                            const SizedBox(height: 16),
                            PhoneNumberPicker(
                              onCountryCodeChanged:controller.onCountryChanged,
                              onNumberChanged: controller.onMobileChanged,
                              onFullNumberChanged: (value){},
                              hintsAsLabel: true,
                            ),
                            const SizedBox(height: 16),
                            _PasswordField(
                              label: "Password",
                              onChanged: controller.onPasswordChanged,
                            ),
                            const SizedBox(height: 16),
                            _PasswordField(
                              label: "Confirm Password",
                              onChanged: controller.onConfirmPasswordChanged,
                            ),
                            const SizedBox(height: 16),
                            TermsAndConditionsCheckbox(onChanged:controller.onCheckChanged),
                            const SpacerVertical64(),


                            RoundedButton(label: "Sign Up", height: 48,
                                onPressed:() async{
                                  FocusScope.of(context).unfocus();//Hide soft keyboard
                                  if(await controller.register()) {
                                    if(context.mounted){
                                      Navigation.gotoVerifyCode(context);
                                    }

                                  }
                                }
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

          ),
        );
      });


  }
}


class _PasswordField extends StatefulWidget {
  final String label;
  final Function(String) onChanged;

  const _PasswordField({
    Key? key,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      leadingIcon: Icons.lock_outline,
      obscureText: _isObscured,
      trailingIcon: IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      ),
      onChanged: widget.onChanged,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Create new account",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color:AppColor.headingText,
          ),
        ),
        const SizedBox(height: 16),
        Image.asset(
          'assets/image/profile.png',
          width: 100,
          height: 70,
        )

      ],
    );
  }
}


class TermsAndConditionsCheckbox extends StatefulWidget {
  final ValueChanged<bool?> onChanged;

  TermsAndConditionsCheckbox({required this.onChanged});

  @override
  _TermsAndConditionsCheckboxState createState() =>
      _TermsAndConditionsCheckboxState();
}

class _TermsAndConditionsCheckboxState extends State<TermsAndConditionsCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value ?? false;
            });
            widget.onChanged(isChecked);
          },
        ),
        const Flexible(
          child: Text(
            "I have read and accept the Terms and Conditions",
            style: TextStyle(
            ),
          ),
        ),
      ],
    );
  }
}
