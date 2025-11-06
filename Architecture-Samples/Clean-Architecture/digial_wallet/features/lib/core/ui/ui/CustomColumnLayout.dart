part of '../../core_ui.dart';
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
typedef ChildLayoutCallback = List<PlaceAbleChild> Function(
    List<MeasuredChild> children);

class CustomLayoutChildBuilder {
  int _currentId = 0;
  final List<NonMeasuredChild> children = [];

  CustomLayoutChildBuilder addChild(Widget widget) {
    children.add(NonMeasuredChild(id: _currentId.toString(), content: widget));
    _currentId++;
    return this;
  }
}

//

class ChildPlacer extends MultiChildLayoutDelegate {
  final List<String> childrenId;
  final ChildLayoutCallback layoutCallback;

  ChildPlacer(
      {super.relayout, required this.childrenId, required this.layoutCallback});

  @override
  void performLayout(Size size) {

    //measuring
    List<MeasuredChild> measuredChildren = [];
    for (var id in childrenId) {
      if (hasChild(id)) {
        var childSize =
        measureChild(id: id, constraints: relaxConstraints(maxSize: size));
        measuredChildren
            .add(MeasuredChild(id: id, size: childSize, parentSize: size));
      }
    }

    //placing
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

//source/Helper classes
class MeasuredChild {
  final String id;
  final Size size;
  final Size parentSize;

  MeasuredChild(
      {required this.id, required this.size, required this.parentSize});
}

//
class PlaceAbleChild {
  final String id;
  final Offset coordinate;

  PlaceAbleChild({required this.id, required this.coordinate});
}

class NonMeasuredChild {
  final String id;
  late final Widget content;

  NonMeasuredChild({required this.id, required Widget content}) {
    this.content = LayoutId(id: id, child: content);
  }
}
