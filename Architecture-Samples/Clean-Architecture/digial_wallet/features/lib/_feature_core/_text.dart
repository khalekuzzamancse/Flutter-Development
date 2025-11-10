part of 'ui.dart';

//@formatter:off
class TextH4 extends StatelessWidget {
  final String text;
  final Color? background;
  final Color? color;
  const TextH4({super.key,required this.text,this.background, this.color});

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeData.estimateBrightnessForColor(background??Colors.transparent)
        == Brightness.dark ? Colors.white : Colors.black;
    return Text(text, style:TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color??textColor));
  }
}
//@formatter:off
class TextH2 extends StatelessWidget {
  final String text;
  final Color? background;
  final Color? color;
  const TextH2({super.key,required this.text,this.background, this.color});

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeData.estimateBrightnessForColor(background??Colors.transparent)
        == Brightness.dark ? Colors.white : Colors.black;
    return Text(text, style:TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: color??textColor));
  }
}
//@formatter:off
class TextH1 extends StatelessWidget {
  final String text;
  final Color? background;
  final Color? color;
  const TextH1({super.key,required this.text,this.background, this.color});

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeData.estimateBrightnessForColor(background??Colors.transparent)
        == Brightness.dark ? Colors.white : Colors.black;
    return Text(text, style:TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: color??textColor));
  }
}
//@formatter:off
class TextLabel1 extends StatelessWidget {
  final String text;
  final Color? background;
  final Color? color;
  const TextLabel1({super.key,required this.text,this.background, this.color});

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeData.estimateBrightnessForColor(background??Colors.transparent)
        == Brightness.dark ? Colors.white : Colors.black;
    return Text(text, style:TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color??textColor));
  }
}
class TextLabel2 extends StatelessWidget {
  final String text;
  final Color? background;
  final Color? color;
  const TextLabel2({super.key,required this.text,this.background, this.color});

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeData.estimateBrightnessForColor(background??Colors.transparent)
        == Brightness.dark ? Colors.white : Colors.black;
    return Text(text, style:TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color??textColor));
  }
}

