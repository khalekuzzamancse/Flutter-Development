import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation_logic/term_and_condition_controller.dart';
import 'core.dart';

class TermsAndConditionScreen extends StatelessWidget {
  late final controller = TermAndConditionController();

  TermsAndConditionScreen({super.key}) {
    controller.read();
  }

  @override
  Widget build(BuildContext context) {
    return GenericScreen(
      title: 'Term and Condition',
      content: Obx(() {
        final model = controller.termAndCondition.value;
        final isLoading = controller.isLoading.value;
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
