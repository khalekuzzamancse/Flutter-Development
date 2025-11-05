
import 'package:flutter/material.dart';


import '../../../navigation/routes.dart';
import 'core.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericScreen(
      title: 'Help',
      content:SingleChildScrollView(
        child: Column(
          children: [
            GenericAction(
              icon: Icons.help_center_outlined,
              label: "Help Center",
              onClick: (){
                Navigation.goToHelpCenter(context);
              },
            ),
             GenericAction(
              icon: Icons.contacts_outlined,
              label: "Contact Us",
              onClick: (){
                Navigation.gotoContactUs(context);
              },
            ),
             GenericAction(
              icon: Icons.privacy_tip_outlined,
              label: "Privacy Policy",
               onClick: (){
                 Navigation.gotoPrivacyPolicy(context);
               },
            ),

          ],
        ),
      )


    );
  }
}
