
import 'package:core/ui/_render_img.dart';
import 'package:core/ui/core_ui.dart';
import 'package:flutter/material.dart';
import '../../domain/domain.dart';
import '../_core/text_fields.dart';
import '../logic/di_container.dart';
import '../_core/resource_factory.dart';
import '../_core/button.dart';
import '../_core/screens.dart';
import 'navigation.dart';


//@formatter:off
class RegisterScreen extends StatefulWidget {
   const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final controller=DiContainer.createRegisterController();
  final firstNameController=TextEditingController();
  final lastNameController=TextEditingController();
  final emailController=TextEditingController();
  final phoneController=TextEditingController();
  final passwordController=TextEditingController();
  final confirmPasswordController=TextEditingController();

  late var error=controller.errors.value();
  @override
  void initState() {
    super.initState();
    controller.errors.listen((value){
      safeSetState((){
        error=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return GenericScreen(
      title: '',
      content: LoadingOverlay(isLoading: false,
        child: Padding(
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
                    CustomTextField(
                      label: "First Name",
                      leadingIcon: Icons.person_outline,
                      controller: firstNameController,
                      error: error.firstNameError,
                    ),
                    const SpacerVertical(16),
                    CustomTextField(
                      leadingIcon: Icons.person_outline,
                      label: "Last Name",
                      controller:lastNameController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Email",
                      leadingIcon: Icons.email_outlined,
                      controller: emailController,
                      error: error.emailError,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Phone",
                      leadingIcon: Icons.phone,
                      controller: phoneController,
                      error: error.phoneError,
                    ),
                    const SizedBox(height: 16),
                    _PasswordField(
                      label: "Password",
                      controller:passwordController,
                      error: error.passwordError,
                    ),
                    const SizedBox(height: 16),
                    _PasswordField(
                      label: "Confirm Password",
                      controller: confirmPasswordController,
                      error: error.confirmPasswordError,
                    ),
                    const SpacerVertical(64),

                    RoundedButton(label: "Sign Up", height: 48,
                        onPressed:() async{
                          FocusScope.of(context).unfocus();//Hide soft keyboard
                          final model= RegisterModel(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              confirmPassword: confirmPasswordController.text,
                              email: emailController.text,
                              mobile: phoneController.text,
                              password: passwordController.text);
                         final success=  await controller.register(model);
                         if(success){
                           final verifyController=DiContainer.createVerificationController();
                           verifyController.updateVerificationCodeId(model.mobile);
                           verifyController.sendVerificationCode();
                           if(context.mounted){
                             Navigation.navigateToVerifyScreen(context,verifyController);
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


  }
}


class _PasswordField extends StatefulWidget {
  final String label;
  final String? error;
  final TextEditingController controller;

  const _PasswordField({
    Key? key,
    required this.label,
    required this.controller,
     this.error
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
      controller: widget.controller,
      leadingIcon: Icons.lock_outline,
      obscureText: _isObscured,
      error: widget.error,
      trailingIcon: IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility_off : Icons.visibility,
          color: AppColor.primary,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Create new account",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color:AppColor.headingText,
          ),
        ),
        SizedBox(height: 16),
       RenderImg(
          path: Images.logo,
          height: 70,
          width: 100,
        )

      ],
    );
  }
}
