import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:snowchat_ios/feature/group_chat/presentation/presentationLogic/group_admin_list_controller.dart';
import '../../../../core/ui/loading_overlay.dart';

import 'group_user_list_screen.dart';

class GroupAdminListScreen extends StatelessWidget {
  final int conversationId;
  late final GroupAdminListController controller;
   GroupAdminListScreen({super.key, required this.conversationId}){
    controller =GroupAdminListController(conversationId);
    controller.read();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final models=controller.admins;
      return LoadingOverlay(
          isLoading: isLoading,
          content: GroupUserListScreen(
            onEnd: controller.onEndOfList,
            title: 'Group Admins',
            contact: models,
          )
      );
    }
    );
  }
}



