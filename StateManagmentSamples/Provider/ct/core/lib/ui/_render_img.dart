import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'core_ui.dart';

class SvgAsIcon extends StatelessWidget {
  final String path;
  final double size;
  const SvgAsIcon({super.key, required this.path, this.size=ThemeInfo.headerButtonIconSize});

  @override
  Widget build(BuildContext context)=> SizedBox(
    height: size,
    width: size,
    child:SvgPicture.asset(path,height: size,width: size),
  );

}

class RenderImg extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  const RenderImg(
      {super.key, required this.path, this.fit, this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }
}

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