import 'package:flutter/material.dart';
import '../../../../core/misc/time_formatter.dart';
import '../../../../core/ui/app_color.dart';
import '../../../../core/ui/message_status_icon.dart';
import '../../../../core/ui/misc.dart';
import '../../domain/model/conversation_model.dart';
import '../../domain/model/last_message_model.dart';

//@formatter:off
class ConversationList extends StatefulWidget {
  final double maxWidth;
  final Function(ConversationModel) onDeleteRequest;
  final List<ConversationModel> conversations;
  final Function(ConversationModel) onChatClicked;
  /// Callback for when reaching the end
  final VoidCallback onEnd;

  const ConversationList({
    Key? key,
    required this.maxWidth,
    required this.conversations,
    required this.onChatClicked,
    required this.onDeleteRequest,
    required this.onEnd,
  }) : super(key: key);

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Add listener to detect when scrolled to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        // Reached the bottom
        widget.onEnd();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth,
      child: ListView.builder(
        controller: _scrollController, // Attach the scroll controller
        itemCount: widget.conversations.length,
        itemBuilder: (context, index) {
          final conversation = widget.conversations[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () => widget.onChatClicked(conversation),
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmationDialog(
                      onConfirm: () {
                        widget.onDeleteRequest(conversation);
                      },
                    );
                  },
                );
              },
              child: _ConversationItem(model: conversation),
            ),
          );
        },
      ),
    );
  }
}

//@formatter:off
// class ConversationList extends StatelessWidget {
//   final double maxWidth;
//   final Function(ConversationModel) onDeleteRequest;
//   final List<ConversationModel> conversations;
//   final Function(ConversationModel) onChatClicked;
//
//   const ConversationList({
//     Key? key,
//     required this.maxWidth,
//     required this.conversations,
//     required this.onChatClicked,
//     required this.onDeleteRequest,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: maxWidth,
//       child: ListView.builder(
//         itemCount: conversations.length,
//         itemBuilder: (context, index) {
//           final conversation = conversations[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: GestureDetector(
//               onTap: () => onChatClicked(conversation),
//               onLongPress: (){
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return ConfirmationDialog(
//                       onConfirm: () {
//                         onDeleteRequest(conversation);
//                       },
//                     );
//                   },
//                 );
//               },
//               child: _ChatItem(model: conversation),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


class ConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmationDialog({super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Are you sure you want to delete this message?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // Trigger the confirmation callback
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}

class _ConversationItem extends StatelessWidget {
  final ConversationModel model;

  const _ConversationItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastMessage = model.lastMessage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: _ChatLayoutStrategy(
        avatar: AvatarWithStatus(
          avatarUrl: model.peer.image??'',
          onOnline: model.peer.isOnline??false,
        ),
        name: Text(
            parseWithEmojiOrOriginal(model.peer.name) ,//may contain emoji,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: AppColor.headingText),
        ),
        lastMessage: lastMessage == null ? const _LastMsg(msg: 'Say something',
            color:   Colors.black):
            _LastMsg(msg: lastMessage.messageOrFileLabel, color:  _shouldHighlight(lastMessage) ? Colors.black : Colors.grey)
        ,
        status: lastMessage == null ? null:_LastMsgStatusIcon(lastMessage:lastMessage),
        time: lastMessage==null?null: Text(
          TimeFormatter.formatReadableTimestamp(lastMessage.time),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.0,
          ),
        )
      ),
    );
  }
}
class _LastMsg extends StatelessWidget {
  final String msg;
  final Color color;
  const _LastMsg({super.key, required this.msg, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      parseWithEmojiOrOriginal(msg)
      , //may contain emoji
      style: TextStyle(
        ////Assuming value are 0,1,2 , 1=received/open, 2=seen, considering ,0,1=not seen
        color:color,
        fontSize: 18.0,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

bool _shouldHighlight(LastMessageModel message){
  if(message.iAmSender??true)//if not decided then assuming I am sender
    {
      return false;
  }
  if(message.status==2){
    return false;
  }
  return true;
}

class _LastMsgStatusIcon extends StatelessWidget {
  final LastMessageModel? lastMessage;

  const _LastMsgStatusIcon({super.key, this.lastMessage});

  @override
  Widget build(BuildContext context) {
    if (lastMessage == null) {
      return const SizedBox.shrink();
    }
    final status=lastMessage!.status;
    return  MessageStatusIcon(status: status);
  }
}




class _ChatLayoutStrategy extends StatelessWidget {
  final Widget avatar;
  final Widget name;
  final Widget? lastMessage; //last message may not exit
  final Widget? status; //last message may not exit
  final Widget? time; //last message may not exit

  const _ChatLayoutStrategy({
    Key? key,
    required this.avatar,
    required this.name,
    required this.lastMessage,
    required this.status,
    required this.time,
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
              if(lastMessage!=null)
                Row(
                  children: [
                    Expanded(child: lastMessage!),
                    // Last message takes up remaining space
                    const SizedBox(width: 8.0),
                    if(status!=null)
                      status!,
                    const SizedBox(width: 8.0),
                    if(time!=null)
                      time!,
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
