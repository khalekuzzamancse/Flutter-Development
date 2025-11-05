import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snowchat_ios/core/ui/loading_overlay.dart';
import 'package:snowchat_ios/feature/navigation/routes.dart';
import 'package:snowchat_ios/feature/profile_management/presentation/presentation_logic/profile_controller.dart';

import 'core.dart';

class AccountSettingScreen extends StatelessWidget {
  final controller = ProfileController();

  AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericScreen(
      title: 'Account',
      content: Obx(() {
        final isLoading = controller.isLoading.value;
        return LoadingOverlay(
          isLoading: isLoading,
          content: Column(
            children: [
              GenericAction(
                icon: Icons.open_in_new,
                label: "Change Number",
                onClick: () {
                  Navigation.navigateToEditProfile(context);
                },
              ),
              GenericAction(
                icon: Icons.delete_outline,
                label: "Delete Account",
                onClick: () {
                  _showDeleteConfirmationDialog(context);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onConfirm: (confirmed) {
            if (confirmed == true) {
              controller.deleteProfile();
            } else {
            }
          },
        );
      },
    );
  }
}



class ConfirmationDialog extends StatelessWidget {
  final void Function(bool?) onConfirm;

  const ConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm(false);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm(true);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
