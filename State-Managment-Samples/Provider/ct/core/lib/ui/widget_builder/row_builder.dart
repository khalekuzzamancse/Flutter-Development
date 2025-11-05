import 'package:flutter/material.dart';

Widget rowBuilderDemo() {
  return RowBuilder()
      .append(const Text('Hello'))
      .append(const Icon(Icons.star))
      .append(Container(width: 80, height: 50, color: Colors.blue))
      .addHorizontalArrangement(MainAxisAlignment.start)
      .addVerticalAlignment(CrossAxisAlignment.center)
      .build();
}

class RowBuilder {
  final List<Widget> _children = [];
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.start;
  MainAxisSize _mainAxisSize = MainAxisSize.max;
  CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.center;
  TextDirection? _textDirection;
  final VerticalDirection _verticalDirection = VerticalDirection.down;
  TextBaseline? _textBaseline;
  bool _fillMaxWidth = false;
  bool _wrapContentWidth = false;
  Color? _backgroundColor=null;

  // Method to add a child widget
  RowBuilder append(Widget child) {
    _children.add(child);
    return this;
  }

  // Method to set horizontal arrangement (MainAxisAlignment)
  RowBuilder addHorizontalArrangement(MainAxisAlignment mainAxisAlignment) {
    _mainAxisAlignment = mainAxisAlignment;
    return this;
  }

  // Method to set vertical alignment (CrossAxisAlignment)
  RowBuilder addVerticalAlignment(CrossAxisAlignment crossAxisAlignment) {
    _crossAxisAlignment = crossAxisAlignment;

    return this;
  }

  RowBuilder setWidth(MainAxisSize mainAxisSize) {
    _mainAxisSize = mainAxisSize;
    return this;
  }

  RowBuilder wrapContentWidth() {
    _mainAxisSize = MainAxisSize.min;
    return this;
  }

  RowBuilder addPaddedChild(Widget child, EdgeInsets padding) {
    _children.add(Padding(
      padding: padding,
      child: child,
    ));
    return this;
  }

  RowBuilder fillMaxWidth() {
    _fillMaxWidth = true;
    return this;
  }
  RowBuilder background({required Color color}) {
    _backgroundColor=color;
    return this;
  }

  // Add methods for other properties as needed...

  // Build method to construct the Row widget
  Widget build() {
    Widget root = Row(
      mainAxisAlignment: _mainAxisAlignment,
      mainAxisSize: _mainAxisSize,
      crossAxisAlignment: _crossAxisAlignment,
      textDirection: _textDirection,
      verticalDirection: _verticalDirection,
      textBaseline: _textBaseline,
      children: _children,
    );
    if (_fillMaxWidth) {
      root = Container(
        width: double.infinity,
        child: root,
      );
    }
   else  if (_fillMaxWidth&&_backgroundColor!=null) {
      root = Container(
        width: double.infinity,
        child: root,
        color:_backgroundColor ,
      );
    }
    else if (_fillMaxWidth==false&&_backgroundColor!=null) {
      root = Container(
        child: root,
        color:_backgroundColor ,
      );
    }



    return root;
  }
}
