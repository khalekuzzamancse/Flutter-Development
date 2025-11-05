import 'package:flutter/material.dart';

class FloatingActionButtonBuilder {
  Key? _key;
  Widget? _child;
  String? _tooltip;
  Color? _foregroundColor;
  Color? _backgroundColor;
  Color? _focusColor;
  Color? _hoverColor;
  Color? _splashColor;
  double? _elevation;
  double? _focusElevation;
  double? _hoverElevation;
  double? _highlightElevation;
  double? _disabledElevation;
  VoidCallback? _onPressed;
  MouseCursor? _mouseCursor;
  bool _mini = false;
  ShapeBorder? _shape;
  final Clip _clipBehavior = Clip.none;
  FocusNode? _focusNode;
  final bool _autoicous = false;
  MaterialTapTargetSize? _materialTapTargetSize;
  final bool _isExtended = false;
  bool? _enableFeedback;

  // Methods to set each property
  FloatingActionButtonBuilder key(Key key) {
    _key = key;
    return this;
  }

  FloatingActionButtonBuilder addIcon(Widget child) {
    _child = child;
    return this;
  }

  FloatingActionButtonBuilder addClickListener(VoidCallback onPressed) {
    _onPressed = onPressed;
    return this;
  }

  FloatingActionButtonBuilder tooltip(String tooltip) {
    _tooltip = tooltip;
    return this;
  }

  FloatingActionButtonBuilder addBackground(Color color) {
    _backgroundColor = color;
    return this;
  }

  // Continue adding methods for other properties...

  FloatingActionButtonBuilder mini(bool mini) {
    _mini = mini;
    return this;
  }

  FloatingActionButtonBuilder shape(ShapeBorder shape) {
    _shape = shape;
    return this;
  }

  // Build method to construct the FloatingActionButton
  FloatingActionButton build() {
    return FloatingActionButton(
      key: _key,
      tooltip: _tooltip,
      foregroundColor: _foregroundColor,
      backgroundColor: _backgroundColor,
      focusColor: _focusColor,
      hoverColor: _hoverColor,
      splashColor: _splashColor,
      elevation: _elevation,
      focusElevation: _focusElevation,
      hoverElevation: _hoverElevation,
      highlightElevation: _highlightElevation,
      disabledElevation: _disabledElevation,
      onPressed: _onPressed,
      mouseCursor: _mouseCursor,
      mini: _mini,
      shape: _shape,
      clipBehavior: _clipBehavior,
      focusNode: _focusNode,
      autofocus: _autoicous,
      materialTapTargetSize: _materialTapTargetSize,
      isExtended: _isExtended,
      enableFeedback: _enableFeedback,
      child: _child,
    );
  }
}
