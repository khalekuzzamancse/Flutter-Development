part of 'core_feature.dart';
class ScreenStrategy extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget? fab;
  const ScreenStrategy({super.key, required this.title, required this.content, this.fab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextHeading1(text: title),
      ),
      floatingActionButton: fab,
      body: PaddingScreenHorizontal(child: content),

    );
  }
}
