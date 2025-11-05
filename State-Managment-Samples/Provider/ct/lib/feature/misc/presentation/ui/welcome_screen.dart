import 'package:flutter/material.dart';

import '../../../../core/ui/buttons.dart';
import '../../../di/auth_preserver.dart';
import '../../../navigation/routes.dart';

//@formatter:off
class WelcomeScreen extends StatelessWidget {

  const WelcomeScreen({ Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //mark as shown
    Preserver.welcomeScreenShown();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/welcome_logo.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 30),
                const Text(
                  "All You Need is Here",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your Secured and Fastest messaging application\n"
                  "It is powerful, fast and free!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 64),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: RoundedButton(
                      label: "Start Messaging",
                      onPressed: (){
                        Navigator.pop(context); //do not option to go back Welcome screen again
                        Navigation.gotoLogin(context);
                      },
                    height: 48,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
