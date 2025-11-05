import 'package:flutter/material.dart';

Widget buttonBuilderDemo() {
  return ButtonBuilder()
      .label('Click Me')
      .setIcon(Icons.touch_app)
      .onClick(() => print('Button Pressed'))
      .style(ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ))
      .fillMaxWidth()
      .build();
}

class ButtonBuilder {
  String? _text;
  IconData? _icon;
  VoidCallback? _onPressed;
  ButtonStyle? _style;
  Color? _color;
  double? _height;
  double? _width;
  bool _fillMaxWidth = false;
  bool _wrapContentWidth = false;
  bool _asTextButton = false;

  ButtonBuilder label(String text) {
    _text = text;
    return this;
  }

  ButtonBuilder setIcon(IconData icon) {
    _icon = icon;
    return this;
  }

  ButtonBuilder onClick(VoidCallback onPressed) {
    _onPressed = onPressed;
    return this;
  }

  ButtonBuilder style(ButtonStyle style) {
    _style = style;
    return this;
  }

  ButtonBuilder setColor(Color color) {
    _color = color;
    return this;
  }

  ButtonBuilder width(double width) {
    _width = width;
    return this;
  }

  ButtonBuilder height(double height) {
    _height = height;
    return this;
  }

  ButtonBuilder fillMaxWidth() {
    _fillMaxWidth = true;
    return this;
  }

  ButtonBuilder wrapContentWidth() {
    _wrapContentWidth = true;
    return this;
  }

  ButtonBuilder asTextButton() {
    _asTextButton = true;
    return this;
  }

  Widget build() {
    if (_asTextButton) {
      return TextButton(onPressed: _onPressed, child: Text(_text ?? ""));
    }
    Widget root = ElevatedButton.icon(
      onPressed: _onPressed,
      icon: _icon != null ? Icon(_icon) : SizedBox.shrink(),
      label: Text(_text ?? ''),
      style: _style,
    );

    if (_fillMaxWidth) {
      root = Container(
        width: double.infinity,
        child: root,
      );
    } else if (_wrapContentWidth) {
      root = Container(
        child: root,
      );
    } else {
      if (_height != null) {
        root = Container(
          height: _height,
          child: root,
        );
      }
      if (_width != null) {
        root = Container(
          width: _width,
          child: root,
        );
      }
      if (_height != null && _width != null) {
        root = Container(
          width: _width,
          height: _height,
          child: root,
        );
      }
    }
    return root;
  }
}
