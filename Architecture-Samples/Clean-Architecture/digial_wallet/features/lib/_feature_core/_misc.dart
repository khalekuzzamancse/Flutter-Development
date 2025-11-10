part of 'ui.dart';

class CardView extends StatelessWidget {
  final Widget child;

  const CardView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(AppConst.cardBorder)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
