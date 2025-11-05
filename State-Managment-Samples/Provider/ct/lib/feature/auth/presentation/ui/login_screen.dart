import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snowchat_ios/core/ui/spacer.dart';
import '../../../../core/network/socket/web_socket.dart';
import '../../../../core/ui/app_color.dart';
import '../../../../core/ui/buttons.dart';
import '../../../di/global_controller.dart';
import '../../../navigation/routes.dart';
import '../presentationLogic/login_controller.dart';
import '../presentationLogic/register_controller.dart';
import 'core.dart';

//@formatter:off
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller =LoginController();
  @override
  Widget build(BuildContext context) {
return AuthModule(onLoginSuccess: (_){});
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(

          padding: const EdgeInsets.all(24.0),
          child: _LayoutStrategy(
              header: const _Header(),
              phoneNoField: PhoneNumberPicker(
                onCountryCodeChanged: (value){},
                onNumberChanged: controller.onPhoneNoChanged,
                onFullNumberChanged: (value){},
              ),
              passwordField: PasswordField(
                onInputChanged: controller.onPasswordChanged,
                hints: 'Password',
              ),
              resetPasswordAction: CustomTextButton(
                label: "Forget Password ?",
                onPressed: () {
                  Navigation.navigateToForgetPassword(context);
                },

              ),
              actions: Column(
                children: [
                  RoundedButton(
                      label: 'Login',
                      height: 48,
                      onPressed: () async{
                        // Hides the keyboard
                        FocusScope.of(context).unfocus();
                        //TODO:Fix about accessing context in async block
                        final user= await controller.login();
                        if(user!=null){
                          if(!user.isVerified){
                            //Need to sent verification code so need registration controller
                            final  registerController = Get.put(RegisterController());
                            registerController.onMobileChanged(user.mobile);
                            registerController.sendVerificationWithMobileNo(user.mobile);
                            Navigation.gotoVerifyCode(context);
                          }
                          else{
                            //update token and userId
                            Get.find<GlobalController>().updateAuthInfo(AuthInfo(token: user.token??'nullAtLoginScreen', currentUserId: user.id));

                            if(context.mounted){
                              Navigator.pop(context); //do not option to go back Login screen again
                              Navigation.goToHome(context);
                            }

                          }
                        }
                      }
                  ),
                  const SpacerVertical16(),
                  const Text('Or',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,color:AppColor.headingText)
                  ),
                  const SpacerVertical16(),
                  RoundedButton(
                      label: 'Create an account',
                      height: 48,
                      onPressed: () {Navigation.navigateToRegister(context);}
                  ),
                ],
              )),
        ),
      ),
    );
  }
}



//@formatter:off
class _LayoutStrategy extends StatelessWidget {
  final Widget header, phoneNoField, passwordField, resetPasswordAction, actions;

  const _LayoutStrategy({Key? key, required this.header, required this.phoneNoField,
    required this.passwordField, required this.resetPasswordAction, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500, // Enforce max width
            minWidth: 300, // Enforce min width
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              header, // Display the header widget
              const SizedBox(height: 32),
              phoneNoField, // Phone number field
              const SizedBox(height: 16),
              passwordField, // Password field
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: resetPasswordAction,
              ), // Forget password field
              const SizedBox(height: 32),
              actions, // Login and register buttons
            ],
          ),
        ),
      );
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
          "Login",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

