import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/core/network/socket/web_socket.dart';
import 'package:snowchat_ios/core/ui/loading_overlay.dart';
import 'package:snowchat_ios/feature/chat/domain/model/message_model.dart';
import 'package:snowchat_ios/feature/chat/presentation/presentationLogic/picked_media_model.dart';
import 'package:snowchat_ios/feature/di/global_controller.dart';
import 'package:snowchat_ios/feature/misc/presentation/ui/core.dart';
import '../../../../core/misc/time_formatter.dart';
import '../../../../core/ui/app_color.dart';
import '../../../../core/ui/misc.dart';
import '../../data/entity/message_entity.dart';
import '../../domain/model/conversation_model.dart';
import '../presentationLogic/conversation_controller.dart';
import '../presentationLogic/message_controller.dart';


class ShareScreen extends StatefulWidget {
  final String msg;
  final PickedMediaModel? media;
  const ShareScreen({super.key,  this.msg='',  this.media});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  late final conversationsController =ConversationController();
  late MessageController messageController;
   List<ConversationModel> conversations =List.empty();

  @override
  void initState() {
    super.initState();
    conversationsController.read();
  }

  @override
  Widget build(BuildContext context) {
    return
    Obx((){
      final conversations=conversationsController.conversations;
      final isLoading=conversationsController.isLoading.value;
      return LoadingOverlay(isLoading: isLoading, content: GenericScreen(
          title: 'Share',
          content: _ConversationList(
            maxWidth: 500,
            conversations: conversations,
            onSendRequest: (conversation) {
              //TODO:Should move to controller
              final conversationId = conversation.id;
              messageController=MessageController(conversationId);

              try {
                messageController.sendMsg(widget.msg,widget.media==null?[]:[widget.media!]);
                Get.find<GlobalController>().showSnackBar('Sent');
              } catch (e) {
                Get.find<GlobalController>().showSnackBar('Failed to sent');
              }
            },
          )));

    });

  }
}


class ForwardMessageScreen extends StatelessWidget {
  final MessageModel message;

  //Since conversationScreen appear before the message/chat so conversation controller is created already
  //use that
  final conversationsController = Get.find<ConversationController>();

  ForwardMessageScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GenericScreen(
        title: 'Forward',
        content: _ConversationList(
          maxWidth: 500,
          conversations: conversationsController.conversations,
          onSendRequest: (conversation) {
            //TODO:Should move to controller
            final conversationId = conversation.id;
            final msg = message.message;
            final attachments = message.attachments
                .map((e) => e.id)
                .where((id) => id != null)
                .cast<int>()
                .toList();
            try {
              WebSocketService()
                  .sendMsgOrThrow(conversationId, msg, attachments);
              Get.find<GlobalController>().showSnackBar('Sent');
            } catch (e) {
              Get.find<GlobalController>().showSnackBar('Failed to sent');
            }
          },
        ));
  }
}

//@formatter:off
class _ConversationList extends StatelessWidget {
  final double maxWidth;
  final List<ConversationModel> conversations;
  final Function(ConversationModel) onSendRequest;

  const _ConversationList({
    Key? key,
    required this.maxWidth,
    required this.conversations,
    required this.onSendRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _ConversationItem(
                conversation: conversation,
              onSend: (){
                  onSendRequest(conversation);
              },
            ),
          );
        },
      ),
    );
  }
}

class _ConversationItem extends StatefulWidget {
  final ConversationModel conversation;
  final VoidCallback onSend;

  const _ConversationItem({
    Key? key,
    required this.conversation,
    required this.onSend,
  }) : super(key: key);

  @override
  State<_ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<_ConversationItem> {
  bool isSent = false;

  void handleSend() {
    widget.onSend();
    setState(() {
      isSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lastMessage = widget.conversation.lastMessage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: _ChatLayoutStrategy(
        avatar: AvatarWithStatus(
          avatarUrl: widget.conversation.peer.image ?? '',
          onOnline: widget.conversation.peer.isOnline ?? false,
        ),
        name: Text(
          widget.conversation.peer.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: AppColor.headingText,
          ),
        ),
        time: lastMessage == null
            ? null
            : Text(
          TimeFormatter.formatTimestamp(lastMessage.time),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.0,
          ),
        ),
        status: const SizedBox.shrink(),
        send: isSent
            ? const Text(
          'Sent',
          style: TextStyle(color: Colors.grey),
        )
            : ElevatedButton(
          onPressed: handleSend,
          child: const Text('Send'),
        ),
      ),
    );
  }
}


class _ChatLayoutStrategy extends StatelessWidget {
  final Widget avatar;
  final Widget name;
  final Widget? send; //last message may not exit
  final Widget? status; //last message may not exit
  final Widget? time; //last message may not exit

  const _ChatLayoutStrategy({
    Key? key,
    required this.avatar,
    required this.name,
    required this.time,
    required this.status,
    required this.send,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        avatar,
        const SizedBox(width: 8.0), // Spacing between avatar and column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              name,
              const SizedBox(height: 4.0), // Spacing between name and row
                Row(
                  children: [
                    time!=null?Expanded(child: time!):Spacer(),
                    // Last message takes up remaining space
                    const SizedBox(width: 8.0),
                    if(status!=null)
                      status!,
                    const SizedBox(width: 8.0),
                    if(send!=null)
                      send!,
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
