import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class RenderSvg extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  const RenderSvg(
      {super.key, required this.path, this.height, this.width, this.color, this.fit});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'images/svg/$path.svg',
      height: height,
      width: width,
      color: color,
      fit: fit == null ? BoxFit.contain : fit!,
    );
  }
}
