import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../core/ui/loading_overlay.dart';
import '../presentationLogic/group_member_list_controller.dart';
import 'group_user_list_screen.dart';

class GroupMembersListScreen extends StatelessWidget {
  final int conversationId;
  late final GroupMemberListController controller;

  GroupMembersListScreen({super.key, required this.conversationId}) {
    controller = GroupMemberListController(conversationId);
    controller.read();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final models = controller.members;
      return LoadingOverlay(
          isLoading: isLoading,
          content: GroupUserListScreen(
            onEnd: controller.onEndOfList,
            title: 'Group Members',
            contact: models,
          ));
    });
  }
}
