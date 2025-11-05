import 'package:flutter/material.dart';

import 'WidgetBuilder.dart';


Widget columnBuilderDemo() {
  return ColumnBuilder()
      .append(child: const Text('Hello'))
      .append(child: const Icon(Icons.star))
      .append(child: Container(width: 80, height: 80, color: Colors.blue))
      .addVerticalArrangement(MainAxisAlignment.start)
      .horizontalAlignment(CrossAxisAlignment.center)
      .build();
}

class ColumnBuilder extends WidgetBuilderImpl {
  final List<Widget> _children = [];
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.start;
  MainAxisSize _mainAxisSize = MainAxisSize.max;
  CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.center;
  TextDirection? _textDirection;
  final VerticalDirection _verticalDirection = VerticalDirection.down;
  TextBaseline? _textBaseline;

  ColumnBuilder append(
      {required Widget child, Alignment align = Alignment.centerLeft}) {
    _children.add(Align(
      alignment: align,
      child: child,
    ));
    return this;
  }

  ColumnBuilder spacer(double height) {
    _children.add(SizedBox(height: height));
    return this;
  }

  ColumnBuilder addVerticalArrangement(MainAxisAlignment mainAxisAlignment) {
    _mainAxisAlignment = mainAxisAlignment;
    return this;
  }

  // Method to set horizontal alignment (CrossAxisAlignment)
  ColumnBuilder horizontalAlignment(CrossAxisAlignment crossAxisAlignment) {
    _crossAxisAlignment = crossAxisAlignment;
    return this;
  }

  // Add methods for other properties as needed...

  // Build method to construct the Column widget
  Widget build() {
    var content = Column(
      mainAxisAlignment: _mainAxisAlignment,
      mainAxisSize: _mainAxisSize,
      crossAxisAlignment: _crossAxisAlignment,
      textDirection: _textDirection,
      verticalDirection: _verticalDirection,
      textBaseline: _textBaseline,
      children: _children,
    );
    super.content(content);
    return super.build();
  }
}

// //
// class ColumnBuilder {
//   final List<Widget> _children = [];
//   MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.start;
//   MainAxisSize _mainAxisSize = MainAxisSize.max;
//   CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.center;
//   TextDirection? _textDirection;
//   final VerticalDirection _verticalDirection = VerticalDirection.down;
//   TextBaseline? _textBaseline;
//
//   //Generic property
//   EdgeInsets? _padding = null;
//   double? _maxWidth = null;
//   Color? _backgroundColor = null;
//
//   ColumnBuilder append(
//       {required Widget child, Alignment align = Alignment.centerLeft}) {
//     _children.add(Align(
//       alignment: align,
//       child: child,
//     ));
//     return this;
//   }
//
//   ColumnBuilder spacer(double height) {
//     _children.add(SizedBox(height: height));
//     return this;
//   }
//
//   ColumnBuilder addVerticalArrangement(MainAxisAlignment mainAxisAlignment) {
//     _mainAxisAlignment = mainAxisAlignment;
//     return this;
//   }
//
//   // Method to set horizontal alignment (CrossAxisAlignment)
//   ColumnBuilder horizontalAlignment(CrossAxisAlignment crossAxisAlignment) {
//     _crossAxisAlignment = crossAxisAlignment;
//     return this;
//   }
//
//   ColumnBuilder setHeight(MainAxisSize mainAxisSize) {
//     _mainAxisSize = mainAxisSize;
//     return this;
//   }
//
//   ColumnBuilder maxWidth(double width) {
//     _maxWidth = width;
//     return this;
//   }
//
//   ColumnBuilder wrapContentHeight() {
//     _mainAxisSize = MainAxisSize.min;
//     return this;
//   }
//
//   ColumnBuilder padding(
//       {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
//     //left,top,right,bottom
//     this._padding = EdgeInsets.fromLTRB(left, top, right, bottom);
//     return this;
//   }
//
//   ColumnBuilder paddingAll({required double padding}) {
//     //left,top,right,bottom
//     this._padding = EdgeInsets.all(padding);
//     return this;
//   }
//
//   ColumnBuilder background({required Color color}) {
//     _backgroundColor = color;
//     return this;
//   }
//
//   // Add methods for other properties as needed...
//
//   // Build method to construct the Column widget
//   Widget build() {
//     Widget rootLayout = Column(
//       mainAxisAlignment: _mainAxisAlignment,
//       mainAxisSize: _mainAxisSize,
//       crossAxisAlignment: _crossAxisAlignment,
//       textDirection: _textDirection,
//       verticalDirection: _verticalDirection,
//       textBaseline: _textBaseline,
//       children: _children,
//     );
//
//     if (_padding != null)
//       rootLayout = Padding(padding: _padding!, child: rootLayout);
//
//     //at end change the properly of root such as color,margin,...
//     if (_maxWidth != null && _backgroundColor != null) {
//       rootLayout = Stack(children: [
//         Container(
//             color: _backgroundColor,
//             constraints: BoxConstraints(minWidth: 0, maxWidth: _maxWidth!),
//             child: rootLayout)
//       ]);
//     }
//     if (_maxWidth == null && _backgroundColor != null) {
//       Container();
//
//       rootLayout = Stack(
//           children: [Container(color: _backgroundColor, child: rootLayout)]);
//     }
// //Need a Layout Widget in order to wrap it
//     if (_maxWidth != null && _backgroundColor == null)
//       rootLayout = Stack(children: [
//         Container(
//             constraints: BoxConstraints(minWidth: 0, maxWidth: _maxWidth!),
//             child: rootLayout)
//       ]);
//     return rootLayout;
//   }
// }
