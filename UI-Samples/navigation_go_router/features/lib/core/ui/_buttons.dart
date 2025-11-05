part of 'core_ui.dart';

class ButtonView extends StatelessWidget {
  final Color background;
  final String label;
  final bool enabled;
  final TextStyle labelStyle;
  final VoidCallback onClick;

  const ButtonView({
    Key? key,
    this.background = Colors.transparent, // equivalent to Color.Unspecified
    required this.label,
    this.enabled = true,
    this.labelStyle = const TextStyle(),
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onClick : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
      ),
      child: Text(
        label,
        style: labelStyle,
      ),
    );
  }
}

