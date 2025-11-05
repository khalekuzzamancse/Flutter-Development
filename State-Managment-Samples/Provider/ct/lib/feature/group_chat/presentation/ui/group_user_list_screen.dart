import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/core/ui/loading_overlay.dart';
import 'package:snowchat_ios/feature/contact_list/domain/model/contact_model.dart';
import 'package:snowchat_ios/feature/group_chat/presentation/presentationLogic/group_chat_controller.dart';

import '../../../../core/ui/app_color.dart';
import '../../../../core/ui/misc.dart';
import '../../../misc/presentation/ui/core.dart';
import '../../../navigation/routes.dart';


class GroupUserListScreen extends StatefulWidget {
  final String title;
  final VoidCallback onEnd;
  final List<ContactModel> contact;

  const GroupUserListScreen({super.key, required this.contact, required this.title, required this.onEnd});


  @override
  State<GroupUserListScreen> createState() => _GroupUserListScreenState();
}

class _GroupUserListScreenState extends State<GroupUserListScreen> {
  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    // Add listener to detect when scrolled to top or bottom
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0) {
          // Reached the top
        } else {
          // Reached the bottom
          widget.onEnd();
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return GenericScreen(
        title: widget.title,
        content: ListView.builder(
          controller: _controller,
          itemCount: widget.contact.length,
          itemBuilder: (context, index) {
            final chat = widget.contact[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () => {
                  Logger.debug('_GroupUserListScreenState', '${chat.profile}'),
                  if(chat.profile!=null){
                    Navigation.goToViewProfile(context,chat.profile!)
                  }

                },
                child: _UserItem(model: chat),
              ),
            );
          },
        ));
  }
}


class _UserItem extends StatelessWidget {
  final ContactModel model;

  const _UserItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: _UserLayoutStrategy(
        avatar: AvatarStrategy(
          status: const SizedBox.shrink(),
          avatarUrl: model.avatarUrl ?? '',
        ),
        name: Text(
          model.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: AppColor.headingText),
        ),
      ),
    );
  }
}

class _UserLayoutStrategy extends StatelessWidget {
  final Widget avatar;
  final Widget name;

  const _UserLayoutStrategy({
    Key? key,
    required this.avatar,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        avatar,
        const SizedBox(width: 8.0), // Spacing between avatar and column
        Expanded(
          child: name,
        ),
      ],
    );
  }
}
