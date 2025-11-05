import 'package:flutter/material.dart';


abstract class PaddingBuilder {
  PaddingBuilder padding(EdgeInsets? padding);

  PaddingBuilder content(Widget child);

  Widget buildOrReturnOriginal();
}


class PaddingBuilderImpl implements PaddingBuilder {
  late Widget _child;
  EdgeInsets? _padding;

  @override
  PaddingBuilderImpl padding(EdgeInsets? padding) {
    _padding = padding;
    return this;
  }

  @override
  PaddingBuilderImpl content(Widget child) {
    _child = child;
    return this;
  }

  @override
  Widget buildOrReturnOriginal() {
    if (_padding != null) {
      return Padding(
        padding: _padding!,
        child: _child,
      );
    }
    return _child;
  }
}
