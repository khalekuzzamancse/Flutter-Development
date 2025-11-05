import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget topAppBarDemo() {
  return TopAppBarBuilder()
      .addNavIcon(const Icon(Icons.menu))
      .addTitle(const Text('My App'))
      .addAction(action:  const Icon(Icons.search))
      .addAction(action:  const Icon(Icons.more_vert))
      .setElevation(4.0)
      .setColor(Colors.blue)
      .build();
}

class TopAppBarBuilder {
  final Key? _key = null;
  Widget? _leading;
  final bool _automaticallyImplyLeading = true;
  Widget? _title;
  final List<Widget> _actions = [];
  PreferredSizeWidget? _bottom;
  double? _elevation;
  Color? _backgroundColor;
  Color? _foregroundColor;
  bool? _centerTitle;
  double? _titleSpacing;
  final double _toolbarOpacity = 1.0;
  final double _bottomOpacity = 1.0;
  final double? _toolbarHeight = null;
  SystemUiOverlayStyle? _systemOverlayStyle;

  TopAppBarBuilder addNavIcon(Widget leadingIcon) {
    _leading = leadingIcon;
    return this;
  }

  TopAppBarBuilder addTitle(Widget title) {
    _title = title;
    return this;
  }

  TopAppBarBuilder addAction( {required Widget action, double spaceAfter = 4.0}) {
    _actions.add(action);
    _actions.add(SizedBox(width: spaceAfter));
    return this;
  }

  TopAppBarBuilder setElevation(double elevation) {
    _elevation = elevation;
    return this;
  }

  TopAppBarBuilder setColor(Color backgroundColor) {
    _backgroundColor = backgroundColor;
    return this;
  }

  AppBar build() {
    return AppBar(
      key: _key,
      leading: _leading,
      automaticallyImplyLeading: _automaticallyImplyLeading,
      title: _title,
      actions: _actions,
      bottom: _bottom,
      elevation: _elevation,
      backgroundColor: _backgroundColor,
      foregroundColor: _foregroundColor,
      centerTitle: _centerTitle,
      titleSpacing: _titleSpacing,
      toolbarOpacity: _toolbarOpacity,
      bottomOpacity: _bottomOpacity,
      toolbarHeight: _toolbarHeight,
      systemOverlayStyle: _systemOverlayStyle,
      leadingWidth: 8,
    );
  }
}
