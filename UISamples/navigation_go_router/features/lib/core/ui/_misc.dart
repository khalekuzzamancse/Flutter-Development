part of 'core_ui.dart';

extension ColorExtension on Color {
  Color contentColor() {
    // compute luminance and return white if > 0.6, else black
    return computeLuminance() > 0.6 ? Colors.white : Colors.black;
  }
}

class ImageView extends StatelessWidget {
  final String assetPath;
  final String contentDescription;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const ImageView({
    Key? key,
    required this.assetPath,
    this.contentDescription = '',
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
