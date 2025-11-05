
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../classifier/classifier_screen.dart';

class GalleryScreen extends StatelessWidget {
  final Function(Uint8List byteArray) onProcessRequest;
  GalleryScreen({super.key, required this.onProcessRequest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery', style: TextStyle(fontSize: 28)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomSheetItem(
                  label: 'From Gallery',
                  icon: Icons.photo,
                  onClick: () async {

                  },
                ),
                BottomSheetItem(
                  label: 'From Camera',
                  icon: Icons.camera_alt,
                  onClick: () async {

                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Pick from dataset',
              style: TextStyle(fontSize: 16, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            // Use Wrap for better image layout and to maintain uniform sizing
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: SavedImageProvider.getImages().map((imagePath) {
                  return ImageItem(
                    imagePath: imagePath,
                    onImageClick: (_)async{

                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedImageProvider {
  static List<String> getImages() {
    return [
      'assets/images/immature_original_1.png',
      'assets/images/class_mature.png',
      'assets/images/immature_original_02.png',
      'assets/images/ripe_original_01.png',
      'assets/images/class_overripe_3.png',
    ];
  }
}


class ImageItem extends StatelessWidget {
  final String imagePath;
  final Function(File) onImageClick;

  const ImageItem({super.key, required this.imagePath, required this.onImageClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onImageClick(File(imagePath));
      },
      child: Container(
        width: 150, // Set a fixed width for each image
        height: 150, // Set a fixed height for each image
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12), // Clip the image inside the container
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity, // Ensure the image covers the full space
          ),
        ),
      ),
    );
  }
}


class BottomSheetItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onClick;

  const BottomSheetItem({super.key, required this.label, required this.icon, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(8),
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: onClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
