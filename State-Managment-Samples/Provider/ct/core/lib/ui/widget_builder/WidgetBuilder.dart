// Define the interface


import '../../library.dart';

import 'package:flutter/material.dart';

import 'WidgetsBuilderFactory.dart';

abstract class WidgetBuilder {
  WidgetBuilder content(Widget content);
  WidgetBuilder width(double width);
  WidgetBuilder widthIn(double min, double max);
  WidgetBuilder height(double height);
  WidgetBuilder wrapContentHeight();
  WidgetBuilder wrapContentWidth();
  WidgetBuilder fillMaxWidth();
  WidgetBuilder fillMaxHeight();
  WidgetBuilder background(Color color);
  WidgetBuilder padding({double left, double top, double right, double bottom});
  WidgetBuilder paddingAll({required double padding});
  Widget build();
}



class WidgetBuilderImpl implements WidgetBuilder{
  late Widget _content;
  //Property related to Container widget
  double? _width;
  double? _minWidth;
  double? _maxWidth;
  double? _height;
  double? _minHeight;
  double? _maxHeight;
  Color? _backgroundColor;

  //Property related to Padding widget
  EdgeInsets? _padding;

@override
  WidgetBuilderImpl content(Widget content) {
    _content = content;
    return this;
  }

  @override
  WidgetBuilderImpl width(double width) {
    _width = width;
    return this;
  }

  @override
  WidgetBuilderImpl widthIn(double min, double max) {
    _minWidth = min;
    _maxWidth = max;
    return this;
  }
  @override
  WidgetBuilderImpl height(double height) {
    _height = height;
    return this;
  }

  @override
  WidgetBuilderImpl wrapContentHeight() {
    _minHeight = 0;
    _maxHeight = double.infinity;
    return this;
  }
  @override

  WidgetBuilderImpl wrapContentWidth() {
    _minWidth = 0;
    _maxWidth = double.infinity;
    return this;
  }

  @override
  WidgetBuilderImpl fillMaxWidth() {
    _width = double.infinity;
    return this;
  }

  @override
  WidgetBuilderImpl fillMaxHeight() {
    _height = double.infinity;
    return this;
  }

  @override
  WidgetBuilderImpl background(Color color) {
    _backgroundColor = color;
    return this;
  }

  @override
  WidgetBuilderImpl padding(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    _padding = EdgeInsets.fromLTRB(left, top, right, bottom);
    return this;
  }

  @override
  WidgetBuilderImpl paddingAll({required double padding}) {
    _padding = EdgeInsets.all(padding);
    return this;
  }

  @override
  Widget build() {
    /*Order of decoration:
      Container
      Padding

     */
    //Wrap the `Padding` Widget if needed otherwise ignore unnecessary wrapping
    Widget root = WidgetsBuilderFactory.instance
        .paddingBuilder()
        .content(_content)
        .padding(_padding)
        .buildOrReturnOriginal();

    //Wrap the `Container` Widget if needed otherwise Ignore unnecessary wrapping
    root = WidgetsBuilderFactory.instance
        .containerBuilder()
        .content(root)
        .height(_height)
        .width(_width)
        .widthIn(_minWidth, _maxWidth)
        .heightIn(_minHeight, _maxHeight)
        .background(_backgroundColor)
        .buildOrReturnOriginal();

    return root;
  }

}
