
import 'placeable_child.dart';
import 'package:flutter/widgets.dart';
import 'measured_child.dart';

typedef ChildLayoutCallback = List<PlaceAbleChild> Function(List<MeasuredChild> children);

class ChildPlacer extends MultiChildLayoutDelegate {
  final List<String> childrenId;
  final ChildLayoutCallback layoutCallback;
  ChildPlacer({super.relayout, required this.childrenId, required this.layoutCallback});

  @override
  void performLayout(Size size) {
    List<MeasuredChild> measuredChildren = [];
    for (var id in childrenId) {
      if (hasChild(id)) {
        var childSize = measureChild(id: id, constraints: relaxConstraints(maxSize: size));
        measuredChildren.add(MeasuredChild(id: id, size: childSize, parentSize: size));
      }
    }

    List<PlaceAbleChild> positionedChildren = layoutCallback(measuredChildren);
    for (var placedChild in positionedChildren) {
      if (hasChild(placedChild.id)) {
        positionChild(placedChild.id, placedChild.coordinate);
      }
    }
  }

  Size measureChild({required Object id, required BoxConstraints constraints}) {
    return layoutChild(id, constraints);
  }

  BoxConstraints relaxConstraints({required Size maxSize}) {
    return BoxConstraints.loose(maxSize);
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
