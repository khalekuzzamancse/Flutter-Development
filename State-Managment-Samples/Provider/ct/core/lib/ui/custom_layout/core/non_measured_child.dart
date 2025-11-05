
import 'package:flutter/widgets.dart';

class NonMeasuredChild {
  final String id;
  late final Widget content;

  NonMeasuredChild({required this.id, required Widget content}) {
    this.content = LayoutId(id: id, child: content);
  }
}