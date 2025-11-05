import '../../library.dart';

import 'package:flutter/material.dart';

abstract class ContainerBuilder {
  ContainerBuilder content(Widget child);

  ContainerBuilder width(double? width);

  ContainerBuilder height(double? height);

  ContainerBuilder widthIn(double? min, double? max);

  ContainerBuilder heightIn(double? min, double? max);

  ContainerBuilder background(Color? color);

  ContainerBuilder padding(EdgeInsetsGeometry? padding);

  Widget buildOrReturnOriginal();
}

/**
 * Wrap the child in Container is any of the property is available otherwise return the original to make
 * sure avoid unnecessary Wrapping
 */

class ContainerBuilderImpl implements ContainerBuilder {
  late Widget _child;
  double? _width;
  double? _height;
  RangeValues? _widthRange;
  RangeValues? _heightRange;
  Color? _backgroundColor;
  EdgeInsetsGeometry? _padding;

  @override
  ContainerBuilderImpl content(Widget child) {
    _child = child;
    return this;
  }

  @override
  ContainerBuilderImpl width(double? width) {
    _width = width;
    return this;
  }

  @override
  ContainerBuilderImpl height(double? height) {
    _height = height;
    return this;
  }

  @override
  ContainerBuilderImpl widthIn(double? min, double? max) {
    if (min != null && max != null) {
      _widthRange = RangeValues(min, max);
    } else {
      _widthRange = null;
    }
    return this;
  }

  @override
  ContainerBuilderImpl heightIn(double? min, double? max) {
    if (min != null && max != null) {
      _heightRange = RangeValues(min, max);
    } else {
      _heightRange = null;
    }
    return this;
  }

  @override
  ContainerBuilderImpl background(Color? color) {
    _backgroundColor = color;
    return this;
  }

  @override
  ContainerBuilderImpl padding(EdgeInsetsGeometry? padding) {
    _padding = padding;
    return this;
  }

  @override
  Widget buildOrReturnOriginal() {
    //TODO:Use conditional adding to avoid unnecessary set default value that proper is not specified to avoid hided BUG
    if (_width != null ||
        _height != null ||
        _backgroundColor != null ||
        _widthRange != null ||
        _heightRange != null ||
        _padding != null) {
      return Container(
        child: _child,
        width: _width,
        height: _height,
        decoration: _backgroundColor != null
            ? BoxDecoration(color: _backgroundColor)
            : null,
        padding: _padding,
        constraints: BoxConstraints(
          minWidth: _widthRange?.start ?? 0,
          maxWidth: _widthRange?.end ?? double.infinity,
          minHeight: _heightRange?.start ?? 0,
          maxHeight: _heightRange?.end ?? double.infinity,
        ),
      );
    }
    return _child;
  }
}
