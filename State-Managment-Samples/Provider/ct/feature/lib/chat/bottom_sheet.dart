import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'app_color.dart';

ShapeBorder getSheetShape() {
  return const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        // bottomLeft: Radius.circular(32.0),
        // bottomRight: Radius.circular(32.0),
        ),
  );
}

class ImageChooserSheet extends StatelessWidget {
  final Function(String path, String name) onImagePicked;

  const ImageChooserSheet({Key? key, required this.onImagePicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upload Photo',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _CustomIconButton(
                  label: 'Upload From Device',
                  icon: Icons.image_outlined,
                  bgColor: AppColor.primary,
                  onClick: () async {
                    final picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (image?.path != null) {
                      onImagePicked(image!.path, image.name);
                    }
                    //Logger.log('ChatInputField,ImagePicker', '${image?.path}');
                    //Logger.log('ChatInputField,ImagePicker', '$bytes');
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(width: 32,),
                _CustomIconButton(
                  label: 'Upload From Camera',
                  icon: Icons.camera_alt_outlined,
                  bgColor: AppColor.primary,
                  onClick: () async {
                    final picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      onImagePicked(image.path, image.name);
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final Color bgColor;
  final IconData icon;
  final String label;
  final VoidCallback onClick;

  const _CustomIconButton({
    Key? key,
    required this.bgColor,
    required this.icon,
    required this.label,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 110),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(width:40,height:40,child: Icon(icon, color: Colors.white,size: 35)),
              ),
              const SizedBox(height: 8), // Space between button and label
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: AppColor.headingText),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip, // Allow text to wrap
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
