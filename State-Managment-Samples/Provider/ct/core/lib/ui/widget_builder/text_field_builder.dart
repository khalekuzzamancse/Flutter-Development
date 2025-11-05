
import 'package:flutter/material.dart';

Widget textFieldBuilderDemo() {
  return TextFieldBuilder()
      .controller(TextEditingController())
      .setSize(width: 200, height: 200)
      .setBorder()
      .build();
}

class TextFieldBuilder {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  InputDecoration? _decoration = const InputDecoration();
  TextInputType? _keyboardType;
  final TextCapitalization _textCapitalization = TextCapitalization.none;
  final TextAlign _textAlign = TextAlign.start;
  TextAlignVertical? _textAlignVertical;
  final bool _readOnly = false;
  final bool _obscureText = false;
  int _maxLines = 1;
  int? _minLines;
  double? _width;
  double? _height;
  EdgeInsets? _padding = null;

  //
  IconData? _leadingIcon = null;
  Color? _leadingIconColor=null;
  // Trailing icon properties
  IconData? _trailingIcon;
  VoidCallback? _onTrailingIconTap;


  BoxDecoration? _containerDecorator;

  TextFieldBuilder controller(TextEditingController controller) {
    _controller = controller;
    return this;
  }

  TextFieldBuilder setKeyboardType(TextInputType keyboardType) {
    _keyboardType = keyboardType;
    return this;
  }

  TextFieldBuilder setBorder({double width = 1.0, Color color = Colors.black}) {
    _containerDecorator =
        BoxDecoration(border: Border.all(color: color, width: width));
    _decoration = null;
    return this;
  }

  TextFieldBuilder setSize({double? width, double? height}) {
    _width = width;
    _height = height;
    return this;
  }

  TextFieldBuilder maxLine({required int lines}) {
    this._maxLines = lines;
    return this;
  }

  TextFieldBuilder padding(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    //left,top,right,bottom
    this._padding = EdgeInsets.fromLTRB(left, top, right, bottom);
    return this;
  }

  TextFieldBuilder paddingAll({required double padding}) {
    //left,top,right,bottom
    this._padding = EdgeInsets.all(padding);
    return this;
  }
  TextFieldBuilder leadingIcon({required IconData icon,Color? color=null}) {
    this._leadingIcon =icon;
    this._leadingIconColor=color;
    return this;
  }

  TextFieldBuilder trailingIcon({required IconData icon, VoidCallback? onClick}) {
    _trailingIcon = icon;
    _onTrailingIconTap = onClick;
    return this;
  }



  Widget build() {
    if (_leadingIcon != null) {
      _decoration = InputDecoration(
          prefixIcon: Icon(_leadingIcon!));
    }
    if (_leadingIcon != null&&_leadingIconColor!=null) {
      _decoration = InputDecoration(
          prefixIcon: Icon(_leadingIcon!,color: _leadingIconColor));
    }
    if(_trailingIcon!=null){
      _decoration=_decoration?.copyWith(
          suffixIcon: GestureDetector(
            child:Icon(_trailingIcon!) ,
            onTap: _onTrailingIconTap,
          )
      );

    }

    var textField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: _decoration,
      keyboardType: _keyboardType,
      textCapitalization: _textCapitalization,
      textAlign: _textAlign,
      textAlignVertical: _textAlignVertical,
      readOnly: _readOnly,
      obscureText: _obscureText,
      maxLines: _maxLines,
      minLines: _minLines,
    );


    Widget root = Container(
        width: _width,
        height: _height,
        decoration: _containerDecorator,
        child: textField);
    if (_padding != null) {
      root = Container(
          width: _width,
          height: _height,
          decoration: _containerDecorator,
          child: Padding(
            padding: _padding!,
            child: textField,
          ));
    }
    return root;
  }
}
