
import 'package:core/ui/core_ui.dart';
import 'package:flutter/material.dart';
import '../_core/text_fields.dart';
import '../logic/di_container.dart';
import '../_core/resource_factory.dart';
import '../_core/button.dart';
import '../_core/misc.dart';
import 'navigation.dart';

//@formatter:off
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller =DiContainer.createLoginController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _LayoutStrategy(
              header: const _Header(),
              phoneNoField: AuthTextField(
                controller: _usernameController,
                label: 'Phone number or email',
                leadingIcon: Icons.person,
                keyboardType: TextInputType.number,
                errorText: error.userIdError,
                onDone: () {

                },),
              passwordField:AuthTextField(
                label: 'Password',
                controller: _passwordController,
                isPasswordField: true,
                leadingIcon:Icons.lock ,
                keyboardType: null,
                errorText:error.passwordError,
                onDone: () {

                },
              ),
              resetPasswordAction: CustomTextButton(
                label: "Forget Password ?",
                onPressed: () {
                  Navigation.navigateToResetPassword(context);
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
                        final success= await controller.login(_usernameController.text,_passwordController.text);
                        // if(user!=null){
                        //   if(!user.isVerified){
                        //     //Need to sent verification code so need registration controller
                        //     final  registerController = Get.put(RegisterController());
                        //     registerController.onMobileChanged(user.mobile);
                        //     registerController.sendVerificationWithMobileNo(user.mobile);
                        //   //  Navigation.gotoVerifyCode(context);
                        //   }
                        //   else{
                        //     //update token and userId
                        //    // Get.find<GlobalController>().updateAuthInfo(AuthInfo(token: user.token??'nullAtLoginScreen', currentUserId: user.id));
                        //
                        //     if(context.mounted){
                        //       Navigator.pop(context); //do not option to go back Login screen again
                        //      // Navigation.goToHome(context);
                        //     }
                        //
                        //   }
                        // }
                      }
                  ),
                  const SpacerVertical(16),
                  const Text('Or',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,color:AppColor.headingText)
                  ),
                    const SpacerVertical(16),
                  RoundedButton(
                      label: 'Create an account',
                      height: 48,
                      onPressed: () {
                        Navigation.navigateToRegister(context);
                      }
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

