import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/feature/group_chat/presentation/presentationLogic/group_chat_controller.dart';

import '../../../../core/misc/logger.dart';
import '../../../../core/ui/app_color.dart';
import '../../../navigation/routes.dart';
import '../../domain/model/conversation_model.dart';
import 'core.dart';

class GroupChatScreen extends StatefulWidget {
  final ConversationModel conversation;

  const GroupChatScreen({Key? key, required this.conversation})
      : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late final GroupChatController controller;

  @override
  void initState() {
    super.initState();
    controller = GroupChatController(widget.conversation.id);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isAdmin = controller.isAdmin.value;
      Logger.debug('GroupChatScreen::build', '$isAdmin');
      return CoreChatScreenWithPermission(
        model: widget.conversation,
        moreAction: _MoreOptionsWidget(
          conversationId: widget.conversation.id,
          isAdmin: isAdmin,
          controller:controller,
        ),
      );
    });
  }
}

class _MoreOptionsWidget extends StatefulWidget {
  final int conversationId;
  final bool isAdmin;
  final GroupChatController controller;

  const _MoreOptionsWidget(
      {Key? key,
      required this.isAdmin,
      required this.conversationId,
      required this.controller})
      : super(key: key);

  @override
  _MoreOptionsWidgetState createState() => _MoreOptionsWidgetState();
}

class _MoreOptionsWidgetState extends State<_MoreOptionsWidget> {
  OverlayEntry? _popupEntry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _showPopupMenu(BuildContext context) {
    if (_popupEntry != null) {
      _removePopupMenu();
      return;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _popupEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _removePopupMenu,
          ),
          Positioned(
            right: 8.0,
            top: offset.dy + size.height + 4.0,
            child: Material(
              color: Colors.transparent,
              child: _PopupMenu(
                isAdmin: widget.isAdmin,
                onMemberListRequest: () {
                  _removePopupMenu();
                  Navigation.goToGroupMembersScreen(
                      widget.conversationId, context);
                },
                onLeaveGroup: () async {
                    await widget.controller.leaveGroup(widget.conversationId);
                    Future.delayed(const Duration(seconds: 1));
                  _removePopupMenu();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                },
                onAddMemberSelected: () {
                  _removePopupMenu();
                  Navigation.goToAddNewMemberToGroupScreen(
                      widget.conversationId, context);
                },
                onRemoveMemberSelected: () {
                  _removePopupMenu();
                  Navigation.goToRemoveMemberToGroupScreen(
                      widget.conversationId, context);
                },
                onAdminListRequest: () {
                  Navigation.goToGroupAdminsScreen(
                      widget.conversationId, context);
                  _removePopupMenu();
                },
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_popupEntry!);
  }

  void _removePopupMenu() {
    _popupEntry?.remove();
    _popupEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onPressed: () => _showPopupMenu(context),
    );
  }
}

class _PopupMenu extends StatelessWidget {
  final VoidCallback onMemberListRequest;
  final VoidCallback onAddMemberSelected;
  final VoidCallback onRemoveMemberSelected;
  final VoidCallback onAdminListRequest;
  final VoidCallback onLeaveGroup;
  final bool isAdmin;

  const _PopupMenu({
    Key? key,
    required this.isAdmin,
    required this.onMemberListRequest,
    required this.onAddMemberSelected,
    required this.onRemoveMemberSelected,
    required this.onAdminListRequest,
    required this.onLeaveGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.debug("_PopupMenu", '$isAdmin');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PopupMenuItem(
            icon: Icons.person_outline,
            label: 'Member List',
            onTap: onMemberListRequest,
          ),
          if (isAdmin)
            PopupMenuItem(
              icon: Icons.person_add_outlined,
              label: 'Add new Member',
              onTap: onAddMemberSelected,
            ),
          if (isAdmin)
            PopupMenuItem(
              icon: Icons.person_remove_outlined,
              label: 'Remove member',
              onTap: onRemoveMemberSelected,
            ),
          PopupMenuItem(
            icon: Icons.admin_panel_settings_outlined,
            label: 'Admins',
            onTap: onAdminListRequest,
          ),
          PopupMenuItem(
            icon: Icons.logout,
            label: 'Leave Group',
            onTap: onLeaveGroup,
          ),
        ],
      ),
    );
  }
}

class PopupMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const PopupMenuItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 24.0, color: Colors.black),
            const SizedBox(width: 16.0),
            Text(
              label,
              style:
                  const TextStyle(fontSize: 16.0, color: AppColor.headingText),
            ),
          ],
        ),
      ),
    );
  }
}
