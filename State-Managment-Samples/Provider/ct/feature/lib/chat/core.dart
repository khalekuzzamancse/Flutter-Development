import 'dart:io';
import 'package:auth/chat/viewer.dart';
import 'package:core/ui/core_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popover/popover.dart';
import '../_core/permission.dart';
import '../_core/time_formatter.dart';
import '../_core/ui.dart';
import '../conversation/model.dart';
import 'app_color.dart';
import 'bottom_sheet.dart';
import 'message_controller.dart';
import 'model.dart';
class CoreChatScreenWithPermission extends StatefulWidget {
  final ConversationModel model;
  final String? subTitle;
  final Widget moreAction;

  const CoreChatScreenWithPermission(
      {super.key,
      required this.model,
      this.subTitle,
      required this.moreAction});

  @override
  _State createState() => _State();
}

class _State extends State<CoreChatScreenWithPermission> {
  final permissionController = MediaPermissionController(permission:MediaPermissionController.mediaPermission,
      reason: MediaPermissionController.mediaPermissionReason);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasPermission = permissionController.hasPermission.value;

      return CoreChatScreen(
          hasMediaPickPermission: hasPermission,
          onMediaPickRequest: () async {
            final notGranted = !(await permissionController.hasAllGranted());
            if (notGranted && context.mounted) {
              context.push(MediaPermissionScreen(controller: permissionController));
            }
          },
          model: widget.model,
          subTitle: widget.subTitle,
          moreAction: widget.moreAction);
    });
  }
}

class CoreChatScreen extends StatelessWidget {
  final ConversationModel model;
  final String? subTitle;
  final Widget moreAction;
  late final MessageController controller;
  final VoidCallback onMediaPickRequest;
  final bool hasMediaPickPermission;

  CoreChatScreen(
      {Key? key,
      this.subTitle,
      required this.moreAction,
      required this.model,
      required this.onMediaPickRequest,
      required this.hasMediaPickPermission})
      : super(key: key) {
    controller = MessageController(model.id);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final models = controller.messages;
      return LoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          appBar: _TopBar(
            imageLink: model.peer.image ?? '',
            title: parseWithEmojiOrOriginal(model.peer.name),
            //group name may contain emoji
            subTitle: _getActiveStatus(model.peer),
            moreAction: moreAction,
            onBackArrowClick: () {
              controller.onExit();
              Navigator.pop(context);
            },
          ),
          body: Column(
            children: [
              Expanded(
                child: MessageList(
                  onBeginning: controller.onBeggingOfMessageList,
                  onEnd: controller.onEndOfMessageList,
                  conversations: models,
                  isGroupMessage: model.isGroupChat,
                  onDelete: (msg) {
                    controller.deleteMessage(msg.id);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _ChatInputField(
                  hasMediaPickPermission: hasMediaPickPermission,
                  onMediaPickRequest: onMediaPickRequest,
                  onSend: (text, pickedImagePath) {
                    controller.sendMsg(text, pickedImagePath);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

String _getActiveStatus(ConversationPeerEntity peer) {
  final isOnline = peer.isOnline ?? false;
  if (isOnline) {
    return 'Online';
  }
  if (peer.lastSeen != null) {
    return 'Last seen at ${TimeFormatter.formatTimestamp(peer.lastSeen!)}';
  }
  return '';
}

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  ///Name for Peer chat, Group name for Group chat
  final String title;
  final String imageLink;

  /// last seen for Peer chat, some of members name for Group chat
  final String? subTitle;
  final Widget moreAction;

  final VoidCallback onBackArrowClick;

  const _TopBar({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onBackArrowClick,
    required this.moreAction,
    required this.imageLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:  Colors.green,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackArrowClick,
      ),
      title: Row(
        children: [
          InkWell(
            onTap: () {
           //   Navigation.push(context, PhotoViewer(url:imageLink));
             // openLinkInDevice(imageLink);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageLink),
              radius: 24.0,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (subTitle != null)
                Text(
                  subTitle!,
                  style: const TextStyle(
                    fontSize: 8.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        moreAction,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MessageList extends StatefulWidget {
  final Function(MessageModel) onDelete;
  final List<MessageModel> conversations;
  final bool isGroupMessage;
  final VoidCallback onBeginning; // Callback for when reaching the beginning
  final VoidCallback onEnd; // Callback for when reaching the end

  const MessageList({
    Key? key,
    required this.conversations,
    required this.isGroupMessage,
    required this.onBeginning,
    required this.onEnd,
    required this.onDelete,
  }) : super(key: key);

  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
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
          widget.onBeginning();
        } else {
          // Reached the bottom
          widget.onEnd();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      // Attach the controller
      itemCount: widget.conversations.length,
      reverse: true,
      // To reverse the list for chat-like experience
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      itemBuilder: (context, index) {
        final conversation = widget.conversations[index];
        return Align(
          alignment: conversation.isAmSender
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Column(
            children: [
              GestureDetector(
                  onTapDown: (details) {
                    final Offset tapPosition = details.globalPosition;
                    final position=RelativeRect.fromLTRB(
                      tapPosition.dx, // Left
                      tapPosition.dy, // Top
                      MediaQuery.of(context).size.width - tapPosition.dx, // Right
                      MediaQuery.of(context).size.height - tapPosition.dy, // Bottom
                    );
                    //TODO:Do not use onTap , because for image onTap the image go to view mode, so will not appear the pop up menu
                    _showPopupMenu(context, conversation,position, widget.onDelete);
                  },
                  child: MessageBubble(
                      model: conversation,
                      isGroupMessage: widget.isGroupMessage)),
              const SizedBox(height: 8), // Bottom padding
            ],
          ),
        );
      },
    );
  }
}

void _showPopupMenu(BuildContext context, MessageModel msg,RelativeRect position, Function(MessageModel) onDelete) async {
  final List<PopupMenuItem<int>> menuItems = [
    const PopupMenuItem<int>(
      value: 0,
      child: Text("Delete"),
    ),
    if (msg.message.isNotEmpty)
      const PopupMenuItem<int>(
        value: 1,
        child: Text("Copy"),
      )
    else if (msg.attachments.isNotEmpty)
      const PopupMenuItem<int>(
        value: 1,
        child: Text("Download"),
      ),
    PopupMenuItem<int>(
      value: 2,
      child: const Text("Forward"),
      onTap: () {
   //     Navigation.goToForwardMessageScreen(context, msg);
      },
    ),
  ];

  final result = await showMenu<int>(
    context: context,
    position: position,
    items: menuItems,
  );

  switch (result) {
    //Delete
    case 0: //Delete
      onDelete(msg);
      break;

    case 1: //CopyOrDownload
      if (msg.message.isNotEmpty) {
        await Clipboard.setData(ClipboardData(text: msg.message));
      } else if (msg.attachments.isNotEmpty) {
        //Download
        for (final attachment in msg.attachments) {
          // final fileDownloader = FileDownloader();
          // if (context.mounted) {
          //   fileDownloader.downloadFileWithDialog(context, attachment.url);
          // }
        }
      }
      break;
    case 2:
      break;
    default:
  }
}

//@formatter:off
class MessageBubble extends StatelessWidget {
  final MessageModel model; final bool isGroupMessage;
  const MessageBubble({Key? key, required this.model, required this.isGroupMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onlyAttachment=model.message.isEmpty&&model.attachments.isNotEmpty;
    final time=TimeFormatter.formatTimestamp(model.time);
    final status=model.status;
    if(onlyAttachment){
      return  Align(
        alignment:model.isAmSender ?Alignment.centerRight : Alignment.centerLeft,
          child: _AttachmentViewer(attachments: model.attachments,time: time,status: status)
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
       color: _getBubbleColor(model),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12.0),
          topRight: const Radius.circular(12.0),
          bottomLeft: model.isAmSender ? const Radius.circular(12.0) : const Radius.circular(0),
          bottomRight: model.isAmSender ? const Radius.circular(0) : const Radius.circular(12.0),
        ),
        border: Border.all(
          color: _getBorderColor(model),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: model.isAmSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (isGroupMessage && !model.isAmSender)_SenderName(sender: model.senderName),
          const SpacerVertical(4),
          _MessageText(message: model.message),
          const SpacerVertical(4),
          _AttachmentViewer(attachments: model.attachments),//Need not to show the time and status on attachment because footer is showing that
          const SpacerVertical(4),
          IntrinsicWidth(
            child: Align(
              alignment: Alignment.centerRight,
              child: MessageFooter(
                time: time,
                isAmSender: model.isAmSender,
                status:model.status,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 Color _getBubbleColor(MessageModel model){
  if(model.message.isNotEmpty)
    {
    final color=model.isAmSender ? Colors.blue[100] : Colors.grey[200];
     return color??Colors.transparent;
    }
  //Msg is empty so there may be document so should not shaded background
  return Colors.transparent;

 }
Color _getBorderColor(MessageModel model){
  if(model.message.isNotEmpty)
  {
    return Colors.transparent;
  }
  if(model.attachments.isNotEmpty){
    return  Colors.green;
  }
  //Fallback
return Colors.transparent;


}
//@formatter:off
class _MessageText extends StatelessWidget {
  final String message;
  const _MessageText({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(parseWithEmojiOrOriginal(message), style: const TextStyle(fontSize: 15.0));

}
class _SenderName extends StatelessWidget {
  final String? sender;
  const _SenderName({Key? key, required this.sender}) : super(key: key);
  @override
  Widget build(BuildContext context) => Text(sender ?? 'Anonymous', style: const TextStyle(fontSize: 14, color: AppColor.primary));
}

class _AttachmentViewer extends StatelessWidget {
  final int? status;
  final String? time;
  final List<AttachmentEntity> attachments;
  const _AttachmentViewer({Key? key, required this.attachments,  this.status,  this.time}) : super(key: key);
  @override
  Widget build(BuildContext context){
    final timeAndStatus=(time!=null&&status!=null)?TimeAndStatus(time: time!, status: status!):null;
    return Column(
      children: attachments.map((attachment) {
        if (attachment.isImage) {
          return ImageViewer(url: attachment.url,timeAndStatus:timeAndStatus );
        } else if (attachment.isVideo) {
          return VideoViewer(url:attachment.url,timeAndStatus: timeAndStatus);
        } else if(attachment.isOtherType) {
         return FileViewer(url: attachment.url,timeAndStatus: timeAndStatus);
        }
        else {
          // Fallback sucha as Error or For unsupported attachment types
          return   const SizedBox.shrink();
        }
      }).toList(),

    );
  }
}

class MessageFooter extends StatelessWidget {
  final String time;
  final bool isAmSender;
  /// 0 sent, 1 received by peer , 2 seen by peer
  final int  status;

  const MessageFooter({
    Key? key,
    required this.time,
    required this.isAmSender,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 13.0, color: Colors.green),
        ),
        if (isAmSender)
          Row(
            children: [
              const SizedBox(width: 4),
              MessageStatusIcon(status: status)
            ],
          ),
      ],
    );
  }
}

//@formatter:off
///Right now support for sending a single attachment
class _ChatInputField extends StatefulWidget {

  ///Right now support for sending a single attachment that is why there is a single parameter for attachment
  final Function(String msg,List<PickedMediaModel> attachment) onSend;
  //Need to check for permission
  final VoidCallback onMediaPickRequest;
  final bool hasMediaPickPermission;
  const _ChatInputField({Key? key, required this.onSend, required this.onMediaPickRequest, required this.hasMediaPickPermission}) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<_ChatInputField> {
  final TextEditingController _textController = TextEditingController();
  bool _isTextNotEmpty = false;
  bool _isEmojiPickerVisible = false;



  void _handleTextChanged(String value) {
    setState(() {
      _isTextNotEmpty = value.trim().isNotEmpty;
    });
  }

  void _handleSend() async{
    if (_isTextNotEmpty)  {

      //It possible that attachment is updated to double to avoid empty message
      if (_isTextNotEmpty){
        ///TODO: Send text and file as separate method
        final text=encodeWithEmojiOrOriginal(_textController.text.trim());
        if(text.isNotEmpty){
          widget.onSend(text,[]);
        }
        _textController.clear();
        _handleTextChanged('');
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  minLines: 1,
                  maxLines: 4,
                  controller: _textController,
                  onChanged: _handleTextChanged,
                  onTap: () {
                    if (_isEmojiPickerVisible) {
                      setState(() {
                        _isEmojiPickerVisible = false;
                        _isTextNotEmpty=_textController.text.trim().isNotEmpty;
                      });
                    }
                  },
                  // textAlign: TextAlign.center,
                  // textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Message',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.attach_file, color:  Colors.green,),
                onPressed: () {
                  if(!widget.hasMediaPickPermission){
                    widget.onMediaPickRequest();
                  }
                  else{
                    showPopover(
                      context: context,
                      bodyBuilder: (context) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AttachmentPickerPopUp(
                          onAudioPicked: () async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['mp3', 'wav', 'm4a', 'aac'], // Restrict to audio formats
                          );
                          // FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            if(context.mounted){
                              Navigator.pop(context); //dismiss the pop up
                            }

                              File file = File(result.files.single.path!);
                              final fileName=extractFileName(file.path);
                              //Get.find<GlobalController>().updateErrorMessage("File:$fileName");
                              widget.onSend('',[PickedMediaModel(type: MediaType.otherFile, path: file.path,name:fileName)]);
                          } else {
                            // User canceled the picker
                          }

                        },
                          onDocumentSelected: ()async{
                            FilePickerResult? result = await FilePicker.platform.pickFiles();
                            // FilePickerResult? result = await FilePicker.platform.pickFiles();
                            if (result != null) {
                              if(context.mounted){
                                Navigator.pop(context); //dismiss the pop up
                              }

                              File file = File(result.files.single.path!);
                              final fileName=extractFileName(file.path);
                              //Get.find<GlobalController>().updateErrorMessage("File:$fileName");
                              widget.onSend('',[PickedMediaModel(type: MediaType.otherFile, path: file.path,name:fileName)]);
                            } else {
                              // User canceled the picker
                            }
                          },
                          onVideoSelected: () async {
                            final picker = ImagePicker();
                            final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
                            if(video!=null){
                              if(context.mounted){
                                Navigator.pop(context); //dismiss the pop up
                              }
                              final fileName=extractFileName(video.path);
                              widget.onSend('',[PickedMediaModel(type: MediaType.video, path: video.path,name:fileName)]);

                              // setState(() {

                              //   _attachments.add(PickedMediaModel(type: MediaType.video, path: video.path,name:fileName));
                              //   Get.find<GlobalController>().updateErrorMessage("Video:$fileName");
                              // });


                            }
                          },
                        ),
                      ),
                      onPop: () {},
                      direction: PopoverDirection.bottom,
                      arrowHeight: 0,
                      arrowWidth: 0,
                    );
                  }

                },
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined,
                    color:  Colors.green,),
                onPressed: () {
                  widget.onMediaPickRequest();
                  if(widget.hasMediaPickPermission){
                    showModalBottomSheet(
                      shape:getSheetShape(),
                      context: context,
                      builder: (BuildContext context) {
                        return ImageChooserSheet(
                          onImagePicked: ( path,name) {
                              final fileName=extractFileName(path);
                            widget.onSend('',[PickedMediaModel(type: MediaType.image, path:path,name:fileName)]);

                          },
                        );
                      },
                    );
                  }

                },
              ),
              IconButton(
                icon: Icon(Icons.send, color: (_isTextNotEmpty)  ? Colors.blue : Colors.grey),
                onPressed: (_isTextNotEmpty) ? _handleSend : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}





class AttachmentPickerPopUp extends StatelessWidget {
  final VoidCallback onAudioPicked,onVideoSelected,onDocumentSelected;

  const AttachmentPickerPopUp({
    Key? key,
    required this.onAudioPicked,
    required this.onVideoSelected,
    required this.onDocumentSelected
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _AttachmentItem(
              icon: Icons.audio_file_outlined,
              label: 'Audio',
              color: Colors.orange,
              onTap: onAudioPicked,
            ),
            const SizedBox(width: 12.0),
            _AttachmentItem(
              icon: Icons.videocam,
              label: 'Video',
              color: Colors.purple,
              onTap: onVideoSelected,
            ),
            const SizedBox(width: 12.0),
            _AttachmentItem(
              icon: Icons.description_outlined,
              label: 'Document',
              color: Colors.green,
              onTap: onDocumentSelected,
            ),

          ],
        ),
      ),
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor: color,
              child: Icon(
                icon,
                size: 28.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
