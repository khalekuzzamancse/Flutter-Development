import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/ui/loading_overlay.dart';
import '../presentation_logic/privacy_policy_controller.dart';
import 'core.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final controller=PrivacyPolicyController();
   PrivacyPolicyScreen({super.key}){
     controller.read();
   }

  @override
  Widget build(BuildContext context) {
    return  GenericScreen(
      title: 'Privacy Policy',
      content: Obx(() {
        final model=controller.privacyInfo.value;
        final isLoading=controller.isLoading.value;
        if (isLoading) {
          return const Center(
              child: SizedBox(
                  width: 64, height: 64, child: CircularProgressIndicator()));
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: model != null ? Text(model.desc) : const SizedBox.shrink(),
            ),
          );
        }
      }),
    );
  }
}
