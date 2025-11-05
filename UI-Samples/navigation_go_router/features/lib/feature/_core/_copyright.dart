part of 'core_feature.dart';
class CopyrightNotice extends StatelessWidget {
  const CopyrightNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: SizedBox.shrink(),
        ),
        const SizedBox(height: 8),
        Text(
          "© 2025, Jashore University of Science and Technology (JUST) and ICT Division, Bangladesh",
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onBackground,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "Guava Maturity Detector App",
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onBackground,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          "Developed in the Department of Computer Science and Engineering (CSE)",
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}