part of core_ui;

///Used for customer table column info
class ColumnConfig {
  final String label;
  final int flex;
  final Alignment alignment;

  const ColumnConfig(
      {required this.label,
      this.flex = 1,
      this.alignment = Alignment.centerLeft});
}

class TableText extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool copyable;

  const TableText(
      this.text,
      this.fontSize, {
        this.copyable = false,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: fontSize),
    );

    if (!copyable) return textWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        textWidget,
        const SpacerHorizontal(6),
        InkWell(
          onTap: () {
            try {
              Clipboard.setData(ClipboardData(text: text));
              showSnackBar('Copied to clipboard');
            } catch (_) {}
          },
          child: const Icon(Icons.copy, size: 16, color: Colors.white70),
        ),
      ],
    );
  }
}


class SizeMeasurer {
  final double label, labelLarge, iconSize;

  const SizeMeasurer(
      {this.label = 14, this.labelLarge = 15, this.iconSize = 35});

  ///Safe to pass the Context, will not cause memory leak or Invalid context because it does not store it, just use it
  static SizeMeasurer build(BoxConstraints constraints, BuildContext context) {
    double widthInDp =
        constraints.maxWidth / MediaQuery.of(context).devicePixelRatio;
    Logger.off('SizeMeasurer', '$widthInDp');
    const labelFactor = 97; //for 1360  , font will be 14
    const labelLargeFactor = 75; //for 1360  , font will be 18
    const iconSizeFactor = 38; // for 1360 , size=35

    return SizeMeasurer(
        label: max(widthInDp / labelFactor, 12),
        labelLarge: max(widthInDp / labelLargeFactor, 14),
        iconSize: max(widthInDp / iconSizeFactor, 23));
  }
}
