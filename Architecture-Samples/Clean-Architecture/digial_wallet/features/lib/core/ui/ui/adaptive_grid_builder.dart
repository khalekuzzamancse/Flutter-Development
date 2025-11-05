import 'package:flutter/material.dart';

Widget adaptiveGridDemo() {
  _AdaptiveGrid grid = AdaptiveGridBuilderImpl()
      .setMinWidth(150)
      //.setItemHeight(150)
      .addSpacing(10)
      .addChildren(List.generate(
          100, (index) => Card(child: Center(child: Text('Item $index')))))
      .build();
  return grid;
}

abstract class AdaptiveGridBuilder {
  AdaptiveGridBuilder addChildren(List<Widget> children);

  AdaptiveGridBuilder addSpacing(double spacing);
}

class AdaptiveGridBuilderImpl extends AdaptiveGridBuilder {
  double? _minItemWidth;
  double? _itemHeight;
  List<Widget>? _children;
  double _spacing = 10.0; // Default value

  // Method to set the minimum item width
  AdaptiveGridBuilderImpl setMinWidth(double minItemWidth) {
    _minItemWidth = minItemWidth;
    return this;
  }

  // Method to set the item height
  AdaptiveGridBuilderImpl setItemHeight(double itemHeight) {
    _itemHeight = itemHeight;
    return this;
  }

  // Method to set the children widgets
  @override
  AdaptiveGridBuilderImpl addChildren(List<Widget> children) {
    _children = children;
    return this;
  }

  // Method to set the spacing between items
  @override
  AdaptiveGridBuilderImpl addSpacing(double spacing) {
    _spacing = spacing;
    return this;
  }

  // Build method to construct the AdaptiveGrid
  // ignore: library_private_types_in_public_api
  _AdaptiveGrid build() {
    // Validate required properties
    if (_minItemWidth == null) {
      throw Exception(
          'Minimum item width (minItemWidth) is required for AdaptiveGrid');
    }
    if (_itemHeight == null) {
      throw Exception('Item height (itemHeight) is required for AdaptiveGrid');
    }
    if (_children == null) {
      throw Exception('Children (children) are required for AdaptiveGrid');
    }

    return _AdaptiveGrid(
      minItemWidth: _minItemWidth!,
      itemHeight: _itemHeight!,
      spacing: _spacing,
      children: _children!,
    );
  }
}

class _AdaptiveGrid extends StatelessWidget {
  final double minItemWidth;
  final double itemHeight;
  final List<Widget> children;
  final double spacing;

  const _AdaptiveGrid({
    required this.minItemWidth,
    required this.itemHeight,
    required this.children,
    this.spacing = 10.0, // Default spacing between grid items
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate the number of columns based on the constraints of the parent widget
        int columns = (constraints.maxWidth / minItemWidth).floor();

        // Ensure there is at least one column
        columns = columns > 0 ? columns : 1;

        return GridView.builder(
          itemCount: children.length,
          padding: EdgeInsets.all(spacing),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: minItemWidth / itemHeight,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemBuilder: (context, index) {
            return children[index];
          },
        );
      },
    );
  }
}
