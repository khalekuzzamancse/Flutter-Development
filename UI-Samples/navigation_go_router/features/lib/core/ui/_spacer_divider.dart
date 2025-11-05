
part of 'core_ui.dart';

class PaddingScreenHorizontal extends StatelessWidget {
  final Widget child;
  const PaddingScreenHorizontal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: 16
        ),
      child:child,
    );
  }
}

class SpacerVertical extends StatelessWidget {
  final double height;

  const SpacerVertical(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

// -------------------- Horizontal Spacer --------------------
class SpacerHorizontal extends StatelessWidget {
  final double width;

  const SpacerHorizontal(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

// -------------------- Fill available space in a Row --------------------
class SpacerFillAvailable extends StatelessWidget {
  const SpacerFillAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: SizedBox());
  }
}

// -------------------- Horizontal Divider --------------------
class DividerHorizontal extends StatelessWidget {
  final double thickness;
  final Color color;
  final EdgeInsetsGeometry? margin;

  const DividerHorizontal({
    Key? key,
    this.thickness = 1.0,
    this.color = Colors.grey,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: thickness,
      color: color,
      margin: margin,
    );
  }
}
