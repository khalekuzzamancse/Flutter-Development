import '../core/custom_layout_child_builder.dart';
import 'package:flutter/widgets.dart';

import '../core/child_placer.dart';
import '../core/measured_child.dart';
import '../core/non_measured_child.dart';
import '../core/placeable_child.dart';


Widget customLayoutDemo() {
  var children = CustomLayoutChildBuilder()
      .addChild(const Text("One"))
      .addChild(const Text("Two"))
      .children;
 return CustomColumnLayout(children: children);
}


class CustomColumnLayout extends StatelessWidget {
  final List<NonMeasuredChild> children;
  const CustomColumnLayout({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    var x = 0.0, y = 0.0;
    var placer = ChildPlacer(
        childrenId: children.map((e) => e.id).toList(),
        layoutCallback: (List<MeasuredChild> children) {
          List<PlaceAbleChild> placeables = [];
          for (var measurable in children) {
            var id = measurable.id, height = measurable.size.height;
            placeables.add(PlaceAbleChild(id: id, coordinate: Offset(x, y)));
            y = y + height;
          }
          return placeables;
        });
    return CustomMultiChildLayout(
        delegate: placer, children: children.map((e) => e.content).toList());
  }
}