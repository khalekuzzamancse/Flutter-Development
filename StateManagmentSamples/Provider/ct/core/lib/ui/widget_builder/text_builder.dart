import 'package:flutter/material.dart';

Widget textBuilderDemo() {
  return TextBuilder()
      .text("Hello Flutter")
      .style(const TextStyle(fontSize: 20, color: Colors.black))
      .build();
}

class TextBuilder {
  Key? _key;
  String? _data;
  TextStyle? _style;
  StrutStyle? _strutStyle;
 

  TextBuilder text(String data) {
    _data = data;
    return this;
  }

  TextBuilder style(TextStyle style) {
    _style = style;
    return this;
  }

  Text build() {
    if (_data == null) {
      throw Exception('Text data is required');
    }
    return Text(
      _data!,
      key: _key,
      strutStyle: _strutStyle,
      style: _style,
    );
  }
}
