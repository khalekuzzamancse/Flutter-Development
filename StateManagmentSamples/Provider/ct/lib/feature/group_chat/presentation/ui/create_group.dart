import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snowchat_ios/core/misc/time_formatter.dart';
import 'package:snowchat_ios/core/ui/loading_overlay.dart';
import 'package:snowchat_ios/core/ui/misc.dart';
import 'package:snowchat_ios/feature/di/global_controller.dart';
import 'package:snowchat_ios/feature/group_chat/presentation/ui/contact_selection_screen.dart';
import 'package:snowchat_ios/feature/group_chat/presentation/presentationLogic/create_group_controller.dart';
import 'package:snowchat_ios/feature/navigation/routes.dart';
import '../../../../core/ui/app_color.dart';
import '../../../../core/ui/bottom_sheet.dart';
import '../../../../core/ui/permission.dart';
import '../../../../core/ui/spacer.dart';
import '../../../contact_list/domain/model/contact_model.dart';

class NewGroupMember extends StatefulWidget {
  const NewGroupMember({super.key});

  @override
  NewGroupMemberState createState() => NewGroupMemberState();
}

class NewGroupMemberState extends State<NewGroupMember> {
  final controller = CreateGroupController();

  NewGroupMemberState() {
    controller.loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final contacts = controller.contacts;
      if (!isLoading) {
        return ContactSelectionScreen(
          onEnd: () {},
          title: 'New Group',
          subtitle: 'Add members',
          initialContacts: contacts,
          onNextClick: (contacts) {
            // Handle the onNextClick logic
            if (contacts.isEmpty) {
              Get.find<GlobalController>().showSnackBar('Select some members');
            } else {
              Navigation.gotoCreateGroup(context, contacts);
            }
          },
        );
      } else {
        return const Scaffold(
            body: Center(
                child: SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator())));
      }
    });
  }
}

class CreateGroupScreen extends StatefulWidget {
  final List<ContactModel> selectedContacts;

  const CreateGroupScreen({super.key, required this.selectedContacts});

  @override
  State<StatefulWidget> createState() => CreateGroupScreenState();
}

class CreateGroupScreenState extends State<CreateGroupScreen> {
  final permissionController = MediaPermissionController(
      permission: MediaPermissionController.mediaPermission,
      reason: MediaPermissionController.mediaPermissionReason);
  String? _pickedImagePath;
  bool showEmojiPicker = false;
  final editingController = TextEditingController();
  final controller = CreateGroupController();

  @override
  void initState() {
    super.initState();
    controller.groupCreationObserver = () async {
      try {
        //TODO:Fix later we are waiting because of we in that phase the widget may be rebuild phase.
        //TODO:Refactor it later with a better solution
        Future.delayed(const Duration(seconds: 2));

        //TODO:Currently popping causes exception such as during rebuild the set state is called
        //because of GetX and Obs(), in the home screen, to avoid that just go back right now
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
        // Navigation.popUntilHome(context);
      } catch (_) {}
    };
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasPermission = permissionController.hasPermission.value;
      final isLoading = controller.isLoading.value;
      return LoadingOverlay(
          isLoading: isLoading,
          content: Scaffold(
            appBar: _TopBar(
              onBackPressed: () {
                Navigator.pop(context);
              },
            ),
            body: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 90,
                      child: _GroupInfoInput(
                        isEmojiPickerVisible: showEmojiPicker,
                        textController: editingController,
                        onEmojiPickRequest: () {
                          try {
                            FocusScope.of(context)
                                .unfocus(); //Hide soft keyboard
                            setState(() {
                              showEmojiPicker = !showEmojiPicker;
                            });
                            if (showEmojiPicker) {
                              FocusScope.of(context).unfocus();
                            } else {
                              FocusScope.of(context).requestFocus();
                            }
                          } catch (_) {}
                        },
                        onTap: () {
                          setState(() {
                            showEmojiPicker = false;
                          });
                        },
                        hasMediaPickPermission: hasPermission,
                        groupNameChanged: (_) {},
                        pickedImagePath: _pickedImagePath,
                        onImagePicked: (path) {
                          setState(() {
                            _pickedImagePath = path;
                          });
                        },
                        onMediaPickedRequest: () async {
                          final notGranted =
                              !(await permissionController.hasAllGranted());
                          if (notGranted && context.mounted) {
                            Navigation.push(
                                context,
                                MediaPermissionScreen(
                                    controller: permissionController));
                          }
                        },
                      ),
                    ),
                    const Divider(),
                    const Text('Selected Members'),
                    const SpacerVertical8(),
                    _SelectedContact(
                      models: widget.selectedContacts,
                    ),
                    if (showEmojiPicker)
                      Expanded(
                        child: _EmojiPicker(
                            textEditingController: editingController,
                            onEmojiSelected: (_, __) {
                              setState(() {
                                showEmojiPicker = false;
                              });
                            }),
                      ),
                  ],
                ),
              ),
            ),
            floatingActionButton: _DoneButton(onClick: () async {
              FocusScope.of(context).unfocus(); //Hide soft keyboard
              //capture state or closer of the mutable variable to avoid hidden bug or crash
              final image = _pickedImagePath;
              final name = encodeWithEmojiOrOriginal(editingController.text);
              final members =
                  widget.selectedContacts.map((contact) => contact.id).toList();
              if (image == null) {
                Get.find<GlobalController>().showSnackBar('Must pick an image');
              }
              if (name.isEmpty) {
                Get.find<GlobalController>().showSnackBar('Must pick a name');
              }
              if (image != null && name.isNotEmpty) {
                await controller.createGroup(image, name, members);
              }
            }),
          ));
    });
  }
}

class _EmojiPicker extends StatelessWidget {
  final TextEditingController textEditingController;
  final void Function(dynamic, dynamic) onEmojiSelected;

  const _EmojiPicker({
    Key? key,
    required this.textEditingController,
    required this.onEmojiSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      textEditingController: textEditingController,
      onEmojiSelected: onEmojiSelected,
      config: const Config(height: 250),
    );
  }
}

class _DoneButton extends StatelessWidget {
  final VoidCallback onClick;

  const _DoneButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        backgroundColor: AppColor.primary,
        shape: const CircleBorder(),
        onPressed: onClick,
        child: const Icon(
          Icons.check,
          size: 24,
          color: Colors.white,
        ),
      );
}

class _GroupInfoInput extends StatefulWidget {
  final String? pickedImagePath;
  final Function(String) groupNameChanged;
  final Function(String path) onImagePicked;
  final VoidCallback onMediaPickedRequest, onEmojiPickRequest, onTap;
  final bool hasMediaPickPermission;
  final bool isEmojiPickerVisible;
  final TextEditingController textController;

  const _GroupInfoInput({
    Key? key,
    this.pickedImagePath,
    required this.onImagePicked,
    required this.groupNameChanged,
    required this.onMediaPickedRequest,
    required this.hasMediaPickPermission,
    required this.onEmojiPickRequest,
    required this.textController,
    required this.isEmojiPickerVisible,
    required this.onTap,
  }) : super(key: key);

  @override
  _GroupInfoInputState createState() => _GroupInfoInputState();
}

class _GroupInfoInputState extends State<_GroupInfoInput> {
  final FocusNode _textFocusNode = FocusNode();

  @override
  void dispose() {
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _GroupImage(
          path: widget.pickedImagePath,
          onClick: () {
            if (!widget.hasMediaPickPermission) {
              widget.onMediaPickedRequest();
            } else {
              showModalBottomSheet(
                shape: getSheetShape(),
                context: context,
                builder: (BuildContext context) {
                  return ImageChooserSheet(
                    onImagePicked: (path, name) {
                      widget.onImagePicked(path);
                      final picked = extractFileName(path);
                      Get.find<GlobalController>()
                          .showSnackBar('Picked: $picked');
                    },
                  );
                },
              );
            }
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TextField(
                focusNode: _textFocusNode,
                controller: widget.textController,
                onTap: widget.onTap,
                decoration: const InputDecoration(
                  hintText: "Type Group Name Here",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  counterText: "", // Removes the built-in counter display
                ),
                maxLength: 25,
              ),
              Container(
                height: 1,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
            onTap: () {
              widget.onEmojiPickRequest();
              // if (!_textFocusNode.hasFocus) {
              //   _textFocusNode.requestFocus(); // Bring up the keyboard
              // }
            },
            child: widget.isEmojiPickerVisible
                ? const Icon(
                    Icons.keyboard_outlined,
                    color: Colors.grey,
                  )
                : const Icon(Icons.emoji_emotions_outlined, color: Colors.grey)),
      ],
    );
  }
}

// //@formatter:off
// class _GroupInfoInput extends StatelessWidget {
//   final String? pickedImagePath;
//   final  Function(String) groupNameChanged;
//   final Function(String path) onImagePicked;
//   const _GroupInfoInput({Key? key, this.pickedImagePath, required this.onImagePicked, required this.groupNameChanged}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         _GroupImage(
//           path: pickedImagePath,
//           onClick: () {
//             showModalBottomSheet(
//               context: context,
//               builder: (BuildContext context) {
//                 return ImageChooserSheet(
//                   onImagePicked: (path, name) {
//                     onImagePicked(path);
//                     final picked=extractFileName(path);
//                     Get.find<GlobalController>().showSnackBar('Picked: $picked');
//                   },
//                 );
//               },
//             );
//           },
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Stack(
//             alignment: Alignment.bottomLeft,
//             children: [
//                TextField(
//                 onChanged:groupNameChanged,
//                 decoration: const InputDecoration(
//                   hintText: "Type Group Name Here",
//                   hintStyle: TextStyle(color: Colors.grey),
//                   border: InputBorder.none,
//                   counterText: "", // Removes the built-in counter display
//                 ),
//
//                 maxLength: 25,
//               ),
//               Container(
//                 height: 1,
//                 color: Colors.grey[400],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 8),
//         GestureDetector(
//           child: const Icon(
//             Icons.emoji_emotions_outlined,
//             size: 24,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }



class _GroupImage extends StatelessWidget {
  final String? path;
  final VoidCallback onClick;

  const _GroupImage({super.key, this.path, required this.onClick});

  @override
  Widget build(BuildContext context) {
    if (path != null) {
      return GestureDetector(
          onTap: onClick,
          child: ClipOval(
            child: Image.file(
              File(path!),
              width: 50,
              // Set width and height equal to maintain a circular shape
              height: 50,
              fit: BoxFit
                  .cover, // Ensures the image is cropped to fit the circle
            ),
          ));
    }
    return GestureDetector(
      onTap: onClick,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[300],
        child: const Icon(
          Icons.camera_alt_outlined,
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;

  const _TopBar({
    Key? key,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed,
      ),
      title: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Group",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            "Rename Group",
            style: TextStyle(
                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SelectedContact extends StatelessWidget {
  final List<ContactModel> models;

  const _SelectedContact({required this.models});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Row(
        children: models.map((model) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0), // Horizontal spacing between items
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AvatarStrategy(
                  avatarUrl: model.avatarUrl ?? '',
                  status: const SizedBox.shrink(),
                ),
                const SpacerVertical8(),
                Text(model.name),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

}
