import 'package:core/ui/_render_img.dart';
import 'package:flutter/material.dart';

import 'resource_factory.dart';



///To change it size need to
class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return  const RenderImg(
      path: Images.logo,
      height: 70,
      width: 100,
    );
  }
}
