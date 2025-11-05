import 'package:flutter/cupertino.dart';

import 'non_measured_child.dart';

class CustomLayoutChildBuilder {
  int _currentId = 0;
  final List<NonMeasuredChild> children = [];
  CustomLayoutChildBuilder addChild(Widget widget) {
    children.add(NonMeasuredChild(id: _currentId.toString(), content: widget));
    _currentId++;
    return this;
  }
}
