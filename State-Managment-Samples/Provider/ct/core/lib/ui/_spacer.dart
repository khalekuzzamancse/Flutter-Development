part of core_ui;
class SpacerVertical extends StatelessWidget {
  final double height;

  const SpacerVertical(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
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
