import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:features/core/ui/core_ui.dart';
import 'package:features/feature/_core/core_feature.dart';


class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenStrategy(
      title: "About App",
      content: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(height: 16),
            TextDescription(
              text:
              "This application is designed to detect various types of Guava using advanced AI models. The supported classes for detection are:",
            ),
            SizedBox(height: 8),
            SupportedClassesSection(),
            SizedBox(height: 12),
            TextHeading3(text: "Data Set"),
            GoogleDriveLink(),
            TextHeading3(text: "Technical Details"),
            SizedBox(height: 8),
            TextDescription(
              text:
              "Our model was trained using TensorFlow and PyTorch frameworks and later converted to TensorFlow Lite for seamless mobile integration. "
                  "TensorFlow Lite enables efficient inference on mobile devices, ensuring faster detection without compromising accuracy.",
            ),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 12),
            CopyrightNotice(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class SupportedClassesSection extends StatelessWidget {
  const SupportedClassesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextHeading3(text: "Supported Guava Classes"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            ClassItem(
              imagePath: 'assets/images/class_immature.png',
              className: 'Immature',
            ),
            ClassItem(
              imagePath: 'assets/images/class_mature.png',
              className: 'Mature',
            ),
            ClassItem(
              imagePath: 'assets/images/class_ripe.png',
              className: 'Ripe',
            ),
            ClassItem(
              imagePath: 'assets/images/class_overripe.png',
              className: 'Over Ripe',
            ),
          ],
        ),
      ],
    );
  }
}

class ClassItem extends StatelessWidget {
  final String imagePath;
  final String className;

  const ClassItem({
    super.key,
    required this.imagePath,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 140,
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.primary, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Container(
                color: Colors.white,
                child: SizedBox(height: 100,width: 100,),
              ),
            ),
          ),
          SpacerVertical(4),
          Text(
            className,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleDriveLink extends StatelessWidget {
  const GoogleDriveLink({super.key});

  final String url =
      "https://drive.google.com/drive/folders/1GPGf3qKlMLu1dn5T9EKhqLUfQfq-tX3L";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              // final uri = Uri.parse(url);
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri, mode: LaunchMode.externalApplication);
              // }
            },
            child: Text(
              "Click here to go to the data set",
              style: TextStyle(
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
                fontSize: 14,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.copy, color: colorScheme.onSurfaceVariant),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Link copied!")),
              );
            },
          ),
        ],
      ),
    );
  }
}


