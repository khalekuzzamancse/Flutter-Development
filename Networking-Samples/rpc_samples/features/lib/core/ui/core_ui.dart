
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

extension ColorExtension on Color {
  Color get contentColor => computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
extension TextEditingControllerExtensions on TextEditingController{
  void setTextOrOriginal(String? text){
    this.text=text??this.text;
  }
}
extension SafeUpdateState on State {
  void safeSetState(void Function() updaterFunction) {
    void callSetState() {
      // Can only call setState if mounted
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(updaterFunction);
      }
    }


    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // Currently building, can't call setState --
      // need to add post-frame callback
      SchedulerBinding.instance.addPostFrameCallback((_) => callSetState());
    } else {
      callSetState();
    }
  }
}
extension ContextExtension on BuildContext{
  Future<T?> push<T extends Object?>(Widget route)async{
    return await Navigator.push(this, MaterialPageRoute(builder: (_)=>route));
  }
  void pop<T extends Object?>([ T? result ]){
    return Navigator.pop(this,result);
  }
  ///In case of async-gap the context may  be invalid so can use it anywhere
  ///to prevent crash
   void popSafelyOrSkip<T extends Object?>([ T? result ]){
    if(mounted){
      Navigator.pop(this,result);
    }
  }


}

extension NavigatorExtension on Navigator{

}
void showSnackBar(String? message,{String? tag})async {
}

class SpacerHorizontal extends StatelessWidget {
  final double width;
  const SpacerHorizontal(this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
class DividerVertical extends StatelessWidget {
  final Color? color;
  final double? thickness;
  const DividerVertical({super.key, this.color=Colors.grey, this.thickness=1});

  @override
  Widget build(BuildContext context) =>VerticalDivider(
    color:color,
    width: 0,
    thickness: thickness,
  );
}
class DividerHorizontal extends StatelessWidget {
  final Color? color;
  final double? thickness;
  const DividerHorizontal({super.key, this.color=Colors.grey, this.thickness=1});

  @override
  Widget build(BuildContext context) =>Divider(
    height: 0,
    color:color,
    thickness: thickness,
  );
}
class SpacerVertical extends StatelessWidget {
  final double height;

  const SpacerVertical(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class LoadingUI extends StatelessWidget {
  final double size;
  final  Color? color;
  const LoadingUI({super.key,this.size=64, this.color});

  @override
  Widget build(BuildContext context) {
    return   Center(child: SizedBox(width:size,height:size,child:  CircularProgressIndicator(color: color,)));
  }
}
class ImageButton extends StatelessWidget {
  final Color color;
  final String iconPath;
  final VoidCallback? onPressed;
  final double size;

  const ImageButton({
    Key? key,
    required this.color,
    required this.iconPath,
    this.onPressed,
    this.size=35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color:  color,
      child: IconButton(
        onPressed:onPressed,
        icon: RenderSvg(path: iconPath),
      ),
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
    return SizedBox.shrink();
  }
}