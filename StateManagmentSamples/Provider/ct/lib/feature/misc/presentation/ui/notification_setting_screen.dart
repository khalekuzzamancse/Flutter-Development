
import 'package:flutter/material.dart';


import 'core.dart';

class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericScreen(
      title: 'Notifications',
      content: Column(
        children: [
          GenericAction(
            icon: Icons.notifications_outlined,
            label: "On",
          ),
          GenericAction(
            icon: Icons.notifications_off_outlined,
            label: "Off",
          ),
        ],
      )

    );
  }
}
