import 'package:flutter/material.dart';
import 'package:features/core/ui/core_ui.dart';
import 'package:features/feature/_core/core_feature.dart';

class HomeScreen extends StatelessWidget {
  VoidCallback onGalleryRequest;

   HomeScreen({super.key,required this.onGalleryRequest});

  @override
  Widget build(BuildContext context) {
    return ScreenStrategy(
      title: "Guava Maturity Classifier",
      fab: CustomButtonView(
        label: "Classify",
        icon: Icons.camera_enhance_outlined,
        onClick:onGalleryRequest,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpacerVertical(16),
          TextDescription(
            text:
                "Detect Guava with ease! Our AI model identifies four different Guava classes accurately.",
          ),
          const SpacerVertical(16),
          const SpacerVertical(24),
          const FeatureList(),
          const SpacerVertical(16),
          const Spacer(),
          const Divider(),
          const SpacerVertical(16),
          const Align(
            alignment: Alignment.centerLeft,
            child: ThanksToICT(),
          ),
          const SpacerVertical(64),
        ],
      ),
    );
  }
}

class FeatureList extends StatelessWidget {
  const FeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        FeaturesSection(
          title: "Supported Features",
          features: [
            "Detects 4 Guava classes: Immature, Mature, Ripe, Over Ripe",
            "Capture images directly from the camera",
            "Select images from your device's gallery",
            "Use images from the app’s integrated gallery",
          ],
        ),
      ],
    );
  }
}

class FeaturesSection extends StatelessWidget {
  final String title;
  final List<String> features;

  const FeaturesSection({
    super.key,
    required this.title,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextHeading2(text: title),
        SpacerVertical(16),
        ...features.map(
          (feature) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TextPoint(text: feature),
          ),
        ),
      ],
    );
  }
}
