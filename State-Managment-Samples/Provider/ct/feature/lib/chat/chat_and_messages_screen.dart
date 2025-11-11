import 'package:auth/conversation/conversion_screen.dart';
import 'package:flutter/material.dart';
import '../conversation/model.dart';
import 'core.dart';

class ChatAndMessagesScreen extends StatelessWidget {
  const ChatAndMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatScreenXX(
      model:dummyConversations[0] ,
    );
  }
}

class ChatScreenXX extends StatelessWidget {
  final ConversationModel model;
  const ChatScreenXX({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CoreChatScreenWithPermission(
      subTitle: '',
      moreAction:  _MoreOptionsWidget(onViewProfileRequest: (){
        if(model.peer is ConversationPersonalPeerEntity){
         // Navigation.goToViewProfile(context, model.peer as ConversationPersonalPeerEntity);
        }
      }),
      model: model,
    );
  }
}

class _MoreOptionsWidget extends StatefulWidget {
  final VoidCallback onViewProfileRequest;
  const _MoreOptionsWidget({Key? key, required this.onViewProfileRequest}) : super(key: key);


  @override
  _MoreOptionsWidgetState createState() => _MoreOptionsWidgetState();
}

class _MoreOptionsWidgetState extends State<_MoreOptionsWidget> {
  OverlayEntry? _popupEntry;

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
                onViewProfileSelected: () {
                  _removePopupMenu();
                  widget.onViewProfileRequest();
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
  final VoidCallback onViewProfileSelected;

  const _PopupMenu({
    Key? key,
    required this.onViewProfileSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            label: 'View Profile',
            onTap: onViewProfileSelected,
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
                  const TextStyle(fontSize: 16.0, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
