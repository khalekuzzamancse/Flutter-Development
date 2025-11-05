import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:snowchat_ios/core/ui/loading_overlay.dart';
import '../presentation_logic/about_us_controller.dart';
import 'core.dart';

class AboutUsScreen extends StatelessWidget {
  final controller=AboutUsController();
   AboutUsScreen({super.key}){
     controller.read();
   }

  @override
  Widget build(BuildContext context) {
    return GenericScreen(
        title: 'About Us',
        content: Obx(() {
          final model=controller.aboutUsInfo.value;
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
        })
    );
  }
}
