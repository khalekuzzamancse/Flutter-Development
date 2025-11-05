import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/core/ui/app_color.dart';
import 'package:snowchat_ios/core/ui/buttons.dart';
import 'package:snowchat_ios/core/ui/loading_overlay.dart';
import 'package:snowchat_ios/core/ui/misc.dart';
import 'package:snowchat_ios/core/ui/spacer.dart';

import '../../../../core/ui/bottom_sheet.dart';
import '../presentation_logic/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      final isLoading = controller.isLoading.value;
      final model = controller.userModel.value;

      return LoadingOverlay(
          isLoading: isLoading,
          content: model == null
              ? const SizedBox(width: 100, height: 100)
              : Scaffold(
                  body: SingleChildScrollView(

                    child: Column(
                      children: [
                        _Header(
                            onNameChanged: controller.onNameChanged,
                            onBackPressed: () {
                              Navigator.pop(context);
                            },
                            image: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage( model.imageUrl),
                            ),
                            name: '${model.firstName} ${model.lastName}'),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: _ProfilePictureButton(onClick: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ImageChooserSheet(
                                          onImagePicked: (path, name) {
                                            controller.uploadProfileImage(path);
                                          },
                                        );
                                      },
                                    );
                                  }),
                                ),
                                Container(
                                  color: const Color(0xFFEBEBEB),
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    _EditItem(
                                      icon: Icons.phone_outlined,
                                      label: "Phone",
                                      enableEdit: false,
                                      value: model.mobile,
                                    ),
                                    _EditItem(
                                      icon: Icons.email_outlined,
                                      enableEdit: false,
                                      label: "Email",
                                      value: model.email,
                                    ),
                                    _EditItem(
                                      icon: Icons.language_outlined,
                                      label: "Website",
                                      value: model.website ?? '',
                                      onValueChange: controller.onWedSiteChange,
                                    ),
                                    _EditItem(
                                      icon: Icons.description_outlined,
                                      label: "Bio",
                                      value: model.bio,
                                      onValueChange: controller.onBioChange,
                                    ),
                                    _EditItem(
                                      icon: Icons.location_on_outlined,
                                      label: "Address",
                                      value: model.address ?? '',
                                      onValueChange: controller.onAddressChange,
                                    ),
                                    const SpacerVertical(16),
                                    SizedBox(
                                        width: 200,
                                        child: RoundedButton(
                                            label: 'Save',
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .unfocus(); //Hide soft keyboard
                                              controller.updateProfile();
                                            }))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
    });
  }
}

class _Header extends StatelessWidget implements PreferredSizeWidget {
  final Widget image;
  final String name;
  final VoidCallback? onBackPressed;
  final Function(String) onNameChanged;

  const _Header({
    Key? key,
    required this.image,
    required this.name,
    this.onBackPressed,
    required this.onNameChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBackPressed,
            ),
            Center(
              child: _ImageAndName(
                image: image,
                name: name,
                onNameChanged: onNameChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140.0);
}

class _ImageAndName extends StatefulWidget {
  final Widget image;
  final String name;
  final Function(String) onNameChanged;

  const _ImageAndName({
    Key? key,
    required this.image,
    required this.name,
    required this.onNameChanged,
  }) : super(key: key);

  @override
  _ImageAndNameState createState() => _ImageAndNameState();
}

class _ImageAndNameState extends State<_ImageAndName> {
  late final TextEditingController controller;
  bool _isEditable = false; // Track the editable state

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.image,
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                cursorColor: Colors.transparent,
                onChanged: (value) {
                  widget.onNameChanged(value);
                },
                // Hide the cursor
                style: const TextStyle(color: Colors.white),
                // Set text color to white
                readOnly: !_isEditable,
                // Make the field read-only if _isEditable is false
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: !_isEditable
                      ? IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _isEditable = true; // Make the field editable
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }
}

class _ProfilePictureButton extends StatelessWidget {
  final VoidCallback onClick;

  const _ProfilePictureButton({Key? key, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.orange, // Background color
              shape: BoxShape.circle, // Circular shape
            ),
            padding: const EdgeInsets.all(12.0), // Padding inside the circle
            child: const Icon(
              Icons.camera_alt_outlined, // Camera icon
              color: Colors.white, // Icon color
              size: 24.0, // Icon size
            ),
          ),
          const SizedBox(width: 8.0), // Spacing between icon and text
          const Text(
            "Update Profile Picture",
            style: TextStyle(
              color: Colors.blue, // Text color
              fontSize: 16.0, // Font size
              fontWeight: FontWeight.w500, // Font weight
            ),
          ),
        ],
      ),
    );
  }
}

class EditableName extends StatefulWidget {
  final String initialName;
  final ValueChanged<String> onNameChanged;

  const EditableName({
    Key? key,
    required this.initialName,
    required this.onNameChanged,
  }) : super(key: key);

  @override
  _EditableNameState createState() => _EditableNameState();
}

class _EditableNameState extends State<EditableName> {
  late final TextEditingController _nameController =
      TextEditingController(text: 'akfak');
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (!_isEditing) {
      widget.onNameChanged(_nameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextField(
          controller: TextEditingController(text: 'sfsfds'),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        )
      ],
    );
  }
}

class _EditItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool enableEdit;
  final Function(String)? onValueChange;

  const _EditItem({
    Key? key,
    this.enableEdit = true,
    required this.icon,
    required this.label,
    required this.value,
    this.onValueChange,
  }) : super(key: key);

  @override
  __EditItemState createState() => __EditItemState();
}

class __EditItemState extends State<_EditItem> {
  late String _currentValue;
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _controller = TextEditingController(text: _currentValue);
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _onValueChanged(String newValue) {
    setState(() {
      _currentValue = newValue;
    });
    if (widget.onValueChange != null) {
      widget.onValueChange!(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = _currentValue.isNotEmpty;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColor.primary,
        child: Icon(widget.icon, color: Colors.white),
      ),
      title: Text(
        widget.label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: isEnabled ? AppColor.headingText : Colors.grey,
        ),
      ),
      subtitle: _isEditing
          ? TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
              ),
              autofocus: true,
              onChanged: _onValueChanged,
              onSubmitted: (_) => _toggleEditMode(),
            )
          : _currentValue.isNotEmpty
              ? Text(
                  _currentValue,
                  style: const TextStyle(fontSize: 14),
                )
              : null,
      trailing: widget.enableEdit && !_isEditing
          ? Container(
        decoration:  BoxDecoration(
          color: Colors.white, // White background for the circle
          shape: BoxShape.circle, // Circular shape
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2), // Optional: Adds slight shadow for elevation
            ),
          ],
        ),
            child: IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.black),
                onPressed: _toggleEditMode,
              ),
          )
          : null,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
    );
  }
}
