import 'package:flutter/material.dart';
import 'package:features/core/ui/core_ui.dart';
import 'package:features/feature/_core/core_feature.dart';

// Main Page
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenStrategy(
      title: "About Us",
      content: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpacerVertical(16),
            const SectionHeading(),
            SpacerVertical(8),
            const SupervisorSection(),
            SpacerVertical(4),
            const Divider(),
            SpacerVertical(24),
            const AIDeveloperSection(),
            SpacerVertical(4),
            const Divider(),
            SpacerVertical(24),
            const DeveloperSection1(),
            SpacerVertical(24),
            const Divider(),
            SpacerVertical(4),
            const DataCollectionAndPreparation(),
            SpacerVertical(24),
            const ThanksToICT(),
            SpacerVertical(24),
            const Divider(),
            const CopyrightNotice(),
            SpacerVertical(16),
          ],
        ),
      ),
    );
  }
}

// ============ Section Heading ============
class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextHeading3(text: "Supervised by");
  }
}

// ============ Supervisor Section ============
class SupervisorSection extends StatelessWidget {
  const SupervisorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularImage(
          imagePath: 'assets/images/super_vicer.png',
          borderColor: colorScheme.primary,
        ),
        const SpacerVertical(8),
        const Text(
          "Dr. Syed Md. Galib",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "Professor",
          style: TextStyle(fontSize: 16, color: colorScheme.secondary),
        ),
        const DeptAndUniversity(),
      ],
    );
  }
}

// ============ AI Developer Section ============
class AIDeveloperSection extends StatelessWidget {
  const AIDeveloperSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const TextHeading3(text: "ML Developer"),
        const SpacerVertical(8),
        CircularImage(
          imagePath: 'assets/images/ai_developer.png',
          borderColor: colorScheme.primary,
        ),
        const SpacerVertical(8),
        const Text(
          "Moradul Siddque",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "Research Assistant",
          style: TextStyle(fontSize: 16, color: colorScheme.secondary),
        ),
      ],
    );
  }
}

// ============ Developer Section ============
class DeveloperSection1 extends StatelessWidget {
  const DeveloperSection1({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const TextHeading3(text: "App Development"),
        const SpacerVertical(8),
        CircularImage(
          imagePath: 'assets/images/developer.jpeg',
          borderColor: colorScheme.primary,
        ),
        const SpacerVertical(8),
        const Text(
          "Yeasir Arefin Tusher",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "Research Assistant",
          style: TextStyle(fontSize: 16, color: colorScheme.secondary),
        ),
        const SpacerVertical(16),
        CircularImage(
          imagePath: 'assets/images/khalekuzzaman.jpg',
          borderColor: colorScheme.primary,
        ),
        const SpacerVertical(8),
        const Text(
          "Md Khalekuzzman",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ============ Data Collection Section ============
class DataCollectionAndPreparation extends StatelessWidget {
  const DataCollectionAndPreparation({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const TextHeading3(text: "Data Collection and Preparation"),
        const SpacerVertical(8),
        CircularImage(
          imagePath: 'assets/images/tanvir_ah.jpg',
          borderColor: colorScheme.primary,
        ),
        const SpacerVertical(8),
        const Text(
          "Tanvir Ahamed",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SpacerVertical(16),
        CircularImage(
          imagePath: 'assets/images/suvo.png',
          borderColor: colorScheme.primary,
        ),
        const SpacerVertical(8),
        const Text(
          "S. M. Shadman Akber Shuvo",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SpacerVertical(16),
        CircularImage(
          imagePath: 'assets/images/nafi.jpeg',
          borderColor: colorScheme.primary,
        ),
        const SpacerVertical(8),
        const Text(
          "Md. Nafiur Rahman",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ============ Department & University ============
class DeptAndUniversity extends StatelessWidget {
  const DeptAndUniversity({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Department of CSE at Jashore University of Science and Technology (JUST)",
        style: TextStyle(fontSize: 14, color: colorScheme.onBackground),
      ),
    );
  }
}

// ============ Circular Image Widget ============
class CircularImage extends StatelessWidget {
  final String imagePath;
  final Color borderColor;

  const CircularImage({
    super.key,
    required this.imagePath,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100,width: 100,);
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}
