part of '../../core_ui.dart';
/// Modifier class to chain widget modifications
class Modifier {
  final List<Widget Function(Widget)> _modifiers;

  Modifier._(this._modifiers);

  /// Starting point for the Modifier chain
  factory Modifier() {
    return Modifier._([]);
  }

  /// Wrap the widget into  an [Expanded] Widget
  /// [fraction] the optional parameter,default=1
  Modifier weight(int fraction) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return Expanded(
          flex: fraction,
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [SizedBox] Widget
  ///
  /// Sets both width and height to the given size
  Modifier size(double size) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return SizedBox(
          width: size,
          height: size,
          child: widget,
        );
      }
    ]);
  }

  /**
   * - Wrap the widget into an [IntrinsicHeight] widget.
   *
   * This modifier ensures that the child widget will expand vertically to match the height of the tallest widget
   * in a row or layout, maintaining uniform height among the children.
   *
   * # Example
   * ```dart
   * Icon(icon, color: iconColor)
   *   .modifier(Modifier()
   *   .paddingAll(16)//To make the Box Wider
   *  .shadow(blurRadius: 6, backgroundColor: bgColor, shadowColor:shadowColor)
   *  .heightIntrinsic())
   * ```
   */
  Modifier intrinsicHeight() {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return IntrinsicHeight(
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [Align] Widget with given [alignment]
  Modifier align(Alignment alignment) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return Align(
          alignment: alignment,
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [SingleChildScrollView] Widget
  Modifier verticalScrollable() {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return SingleChildScrollView(
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [Padding] Widget with given paddings
  Modifier padding(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return Padding(
          padding: EdgeInsets.fromLTRB(left, top, right, bottom),
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [Padding] Widget with given padding
  Modifier paddingAll(double value) {
    return padding(left: value, top: value, right: value, bottom: value);
  }

  /// Wrap the widget into  an [Container] Widget
  ///
  /// Apply the color to the container [Container]
  Modifier background(Color color) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return Container(
          color: color,
          child: widget,
        );
      }
    ]);
  }

  /// Wraps the widget into a [Container] with a linear gradient background.
  Modifier linearGradient(List<Color> colors) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: widget,
        );
      }
    ]);
  }

  /**
   * - Wrap the widget into a [Container] with shadow properties.
   * - Use when need rectangle shadow, either with rounder corner or not
   * - If pure circle shadow need use [shadowCircular]
   *
   * # Example
   * ```dart
   * Modifier()
   *  .shadow(maxWidth: 280, blurRadius: 6, backgroundColor: bgColor, shadowColor: shadowColor)
   * ```
   *
   * # Caution
   * - When using this modifier inside a horizontally scrollable widget, ensure that you specify a `maxWidth`.
   *   This is because horizontal scrollable widgets have unbounded constraints by default, which can cause
   *   rendering issues as the container will attempt to take up as much space as possible if no constraint is provided.
   */
  Modifier shadow(
      {double maxWidth = double.infinity,
        double maxHeight = double.infinity,
        double minWidth = 0,
        double minHeight = 0,
        double? height=null,
        double? width=null,
        Color backgroundColor = Colors.white,
        Color shadowColor = Colors.black,
        double blurRadius = 6.0,
        Offset offset = const Offset(0, 3),
        double radius = 8.0,
        BorderRadiusGeometry? borderRadius = null,
        double padding = 8.0,
        BoxShape shape = BoxShape.rectangle}) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return Container(
          height:height,
          width: width,
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            minWidth: minWidth,
            minHeight: minHeight,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.1), // Adjust opacity as needed
                blurRadius: blurRadius,
                offset: offset,
              ),
            ],
            borderRadius: borderRadius??BorderRadius.circular(radius),
          ),
          padding: EdgeInsets.all(padding),
          child: widget,
        );
      }
    ]);
  }

  /**
   * - Wrap the widget into a [Container] with shadow properties.
   *
   * # Example
   * ```dart
   *   Text(
   *   percentage,
   *  style: TextStyle(color: percentageTextColor.withOpacity(_calculateOpacity()), fontSize: 18, fontWeight: FontWeight.w500))
   *  .modifier(Modifier()
   *  .paddingAll(8)
   *  .shadowShaped(offset: Offset(0, 1),blurRadius: 8,backgroundColor: Colors.white,shadowColor:Colors.black.withOpacity(0.1))
   * .intrinsicHeight())
   * ```
   *
   * # Caution
   * - When using this modifier inside a horizontally scrollable widget, ensure that you specify a `maxWidth`.
   *   This is because horizontal scrollable widgets have unbounded constraints by default, which can cause
   *   rendering issues as the container will attempt to take up as much space as possible if no constraint is provided.
   */
  Modifier shadowShaped(
      {double maxWidth = double.infinity,
        double maxHeight = double.infinity,
        double minWidth = 0,
        double minHeight = 0,
        Color backgroundColor = Colors.white,
        Color shadowColor = Colors.black,
        double blurRadius = 6.0,
        Offset offset = const Offset(0, 3),
        double padding = 8.0,
        BoxShape shape = BoxShape.circle}) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            minWidth: minWidth,
            minHeight: minHeight,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: shape,
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.1), // Adjust opacity as needed
                blurRadius: blurRadius,
                offset: offset,
              ),
            ],
          ),
          padding: EdgeInsets.all(padding),
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [SizedBox] Widget
  ///
  /// Recommended to use when need to set the height and width
  /// If you use [Modifier.width] or [Modifier.height] separately then it will unnecessary add extra [SizedBox]
  /// wrapping.

  Modifier widthHeight(double width, double height) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return SizedBox(
          width: width,
          height: height,
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into a [Container] with width and height constraints
  ///
  /// Use this modifier to set both the width and height constraints of the widget.
  ///   /// #Exaxmple
  //   /// ```dart
  //   /// _LayoutStrategy(
  //   ///       modifier: Modifier().sizeIn(maxWidth: 400),
  //   ///       labelAccount: Text('Account Number:', style: labelTextStyle),
  //   ///       labelPassword: Text('Password:', style: labelTextStyle),
  //   ///       expireDate: Text('Expire Date: $expiryDate', style: labelTextStyle),
  //   ///       ccv: Text('CCV: $ccv', style: labelTextStyle))
  //   ///
  //   /// ```
  Modifier sizeIn({
    double minWidth = 0,
    double maxWidth = double.infinity,
    double minHeight = 0,
    double maxHeight = double.infinity,
  }) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return Container(
          constraints: BoxConstraints(
            minWidth: minWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            maxHeight: maxHeight,
          ),
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into a [Container] with width constraints only
  ///
  /// Use this modifier to set the minimum and maximum width of the widget.
  /// #Exaxmple
  /// ```dart
  /// _LayoutStrategy(
  ///       modifier: Modifier().widthIn(maxWidth: 400),
  ///       labelAccount: Text('Account Number:', style: labelTextStyle),
  ///       labelPassword: Text('Password:', style: labelTextStyle),
  ///       expireDate: Text('Expire Date: $expiryDate', style: labelTextStyle),
  ///       ccv: Text('CCV: $ccv', style: labelTextStyle))
  ///
  /// ```

  Modifier widthIn({
    double minWidth = 0,
    double maxWidth = double.infinity,
  }) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return Container(
          constraints: BoxConstraints(
            minWidth: minWidth,
            maxWidth: maxWidth,
          ),
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [SizedBox] Widget
  ///
  /// Apply the width to the [Container]
  /// If your purpose is the height of also then recommended to use [Modifier.widthHeight]
  Modifier width(double width) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return SizedBox(
          width: width,
          child: widget,
        );
      }
    ]);
  }

  /**
   * It ensure it override the width(relax constraint_)) by wrapping it to a [IntrinsicWidth]
   */
  Modifier wrapContentWidth() {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return IntrinsicWidth(
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [SizedBox] Widget
  ///
  /// Apply the height to the [Container]
  /// If your purpose is the width of also then recommended to use [Modifier.widthHeight]
  Modifier height(double height) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return SizedBox(
          height: height,
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [SizedBox] Widget
  ///
  /// force the  the [SizedBox] to fillMaxWidth
  Modifier fillMaxWidth() {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return SizedBox(
          width: double.infinity,
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [SizedBox] Widget
  ///
  /// force the  the [SizedBox] to fillMaxHeight
  Modifier fillMaxHeight() {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return SizedBox(
          height: double.infinity,
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [GestureDetector] Widget
  Modifier clickable(VoidCallback onClick) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return GestureDetector(
          onTap: onClick,
          child: widget,
        );
      }
    ]);
  }

  /// Wrap the widget into  an [ClipOval]
  ///
  /// Then wrap this [SizedBox] into clip oval
  /// Intended to use for any Widget
  /// But if need to clip [Image] that aspect ratio may not the same use the [Modifier.clipCircular] instead
  Modifier clipCircle() {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return ClipOval(child: widget);
      }
    ]);
  }

  /// 3 Level Wrapping
  ///
  /// Wrap the widget into  an [FittedBox] Widget to make sure aspect ratio is same
  /// Then wrap this into a [SizedBox]
  /// Then wrap this [SizedBox] into clip oval
  /// Intended to use for the [Image] that aspect ratio may not the same
  /// If you click a widget rather a [Image] use the [Modifier.clipCircle] to avoid unnecessary wrapping
  ///
  Modifier clipCircular(double size) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return ClipOval(
          child: SizedBox(
            width: size,
            height: size,
            child: FittedBox(
              fit: BoxFit.cover,
              child: widget,
            ),
          ),
        );
      }
    ]);
  }

  /// Wrap the widget into a [ClipRRect] with a rounded rectangle shape
  /// using the specified [radius] for the border radius.
  Modifier roundedCornerShape(double radius) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: widget,
        );
      }
    ]);
  }

  /// Adds a decoration to the widget (e.g., border, shadow)
  Modifier decoration(BoxDecoration decoration) {
    return Modifier._([
      ..._modifiers,
          (widget) {
        return Container(
          decoration: decoration,
          child: widget,
        );
      }
    ]);
  }

  /// Applies all modifiers to the given widget
  Widget apply(Widget widget) {
    return _modifiers.fold<Widget>(widget, (prev, modifier) => modifier(prev));
  }
}

/// Extension method to apply a Modifier to any widget
extension ModifierExtension on Widget {
  Widget modifier(Modifier modifier) {
    return modifier.apply(this);
  }
}
