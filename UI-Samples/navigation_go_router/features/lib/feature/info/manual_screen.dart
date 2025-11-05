import 'package:flutter/material.dart';
import 'package:features/feature/_core/core_feature.dart';

class ManualScreen extends StatelessWidget {
  const ManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenStrategy(
      title: "Usage Guide",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(height: 16),
          InstructionStep(
            stepNumber: 1,
            title: "Pick an Image",
            description:
                "You can select an image directly from your device’s camera or gallery.",
          ),
          SizedBox(height: 16),
          InstructionStep(
            stepNumber: 2,
            title: "AI Detection",
            description:
                "The AI will analyze the image and detect the type among these four classes:\n✔ Immature\n✔ Mature\n✔ Ripe\n✔ Over Ripe",
          ),
          SizedBox(height: 16),
          InstructionStep(
            stepNumber: 3,
            title: "Results & Information",
            description:
                "The app will display the detected type along with additional information about that class.",
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class InstructionStep extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;

  const InstructionStep({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextHeading3(text: "Step $stepNumber: $title"),
              const SizedBox(height: 2),
              TextDescription(text: description),
            ],
          ),
        ),
      ],
    );
  }
}
