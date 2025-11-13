part of '../../core_ui.dart';
extension StreamStateExtension<T> on Stream<T> {
  void listenToStream(StateSetter setState, Function(T) onData,
      {Function? onError}) {
    this.listen(
          (value) {
        setState(() {
          onData(value);
        });
      },
    );
  }
}
class EmptyContentScreen extends StatelessWidget {
  final String? text;
  final IconData? icon;

  const EmptyContentScreen({
    Key? key,
    this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.info_outline, // Use the provided icon or a default info icon
              size: 80,
              color: theme.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              text ?? "No Content Found!",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LoadingUi extends StatelessWidget {
  const LoadingUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());

  }
}

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double height;

  const CustomTopBar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.backgroundColor = Colors.transparent, // Default to transparent
    this.height = kToolbarHeight, // Default height to AppBar height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          if (leading != null) leading!,
          if (title != null)
            Expanded(
              child:title!,
            ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
