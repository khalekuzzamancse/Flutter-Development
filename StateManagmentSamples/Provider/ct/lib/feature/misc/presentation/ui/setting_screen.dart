
import 'package:flutter/material.dart';
import '../../../navigation/routes.dart';
import 'core.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericScreen(
      title: 'Settings',
      content: Column(
        children: [
          Column(
            children: [
              GenericAction(
                icon: Icons.manage_accounts_outlined,
                label: "Account",
                onClick: (){
                  Navigation.navigateToAccountSetting(context);
                },
              ),
               GenericAction(
                icon: Icons.notification_important_outlined,
                label: "Notifications",
                 onClick: (){
                   Navigation.navigateToNotificationSetting(context);
                 },
              ),
               GenericAction(
                icon: Icons.live_help_outlined,
                label: "Help",
                onClick: (){
                  Navigation.navigateToHelp(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
