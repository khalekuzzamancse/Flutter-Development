import 'package:flutter/material.dart';

class DropDownFieldBuilder {
  List<String> _items = [];
  String? _selectedItem;
  double? _width;
  double? _height;
  BoxDecoration? _containerDecorator;
  EdgeInsets? _padding = EdgeInsets.all(0);
  Color? _iconColor;
  ValueChanged<String?>? _onItemSelected;
  bool _fillMaxWidth = false;
  IconData? _leadingIcon;
  Color? _leadingIconColor;

  DropDownFieldBuilder options(List<String> items) {
    _items = items;
    return this;
  }

  DropDownFieldBuilder selected(String selectedItem) {
    _selectedItem = selectedItem;
    return this;
  }

  DropDownFieldBuilder setSize({double? width, double? height}) {
    _width = width;
    _height = height;
    return this;
  }

  DropDownFieldBuilder width({double? width}) {
    _width = width;
    return this;
  }

  DropDownFieldBuilder height({double? height}) {
    _height = height;
    return this;
  }

  DropDownFieldBuilder padding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    _padding = EdgeInsets.fromLTRB(left, top, right, bottom);
    return this;
  }

  DropDownFieldBuilder paddingAll(double padding) {
    _padding = EdgeInsets.all(padding);
    return this;
  }

  DropDownFieldBuilder iconColor(Color color) {
    _iconColor = color;
    return this;
  }

  DropDownFieldBuilder leadingIcon({required IconData icon, Color? color}) {
    _leadingIcon = icon;
    _leadingIconColor = color;
    return this;
  }

  DropDownFieldBuilder onSelected(ValueChanged<String?> callback) {
    _onItemSelected = callback;
    return this;
  }

  DropDownFieldBuilder fillMaxWidth() {
    _fillMaxWidth = true;
    return this;
  }

  Widget build() {
    return _DropDownFieldBuilderWidget(
      items: _items,
      selectedItem: _selectedItem,
      width: _width,
      height: _height,
      containerDecorator: _containerDecorator,
      padding: _padding,
      iconColor: _iconColor,
      onItemSelected: _onItemSelected,
      fillMaxWidth: _fillMaxWidth,
      leadingIcon: _leadingIcon,
      leadingIconColor: _leadingIconColor,
    );
  }
}

class _DropDownFieldBuilderWidget extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final double? width;
  final double? height;
  final BoxDecoration? containerDecorator;
  final EdgeInsets? padding;
  final Color? iconColor;
  final ValueChanged<String?>? onItemSelected;
  final bool fillMaxWidth;
  final IconData? leadingIcon;
  final Color? leadingIconColor;

  _DropDownFieldBuilderWidget({
    required this.items,
    this.selectedItem,
    this.width,
    this.height,
    this.containerDecorator,
    this.padding,
    this.iconColor,
    this.onItemSelected,
    this.fillMaxWidth = false,
    this.leadingIcon,
    this.leadingIconColor,
  });

  @override
  _DropDownFieldBuilderWidgetState createState() =>
      _DropDownFieldBuilderWidgetState();
}

class _DropDownFieldBuilderWidgetState extends State<_DropDownFieldBuilderWidget> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem ??
        (widget.items.isNotEmpty ? widget.items[0] : null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.fillMaxWidth ? double.infinity : widget.width,
      height: widget.height,
      decoration: widget.containerDecorator,
      padding: widget.padding,
      child: DropdownButton<String>(
        value: _selectedItem,
        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Center(child: Text(item)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedItem = newValue;
          });
          if (widget.onItemSelected != null) {
            widget.onItemSelected!(newValue);
          }
        },
        iconEnabledColor: widget.iconColor,
        isExpanded: widget.fillMaxWidth,
        underline: Container(),
        selectedItemBuilder: (BuildContext context) {
          return widget.items.map<Widget>((String item) {
            return Row(
              children: [
                if (widget.leadingIcon != null) Icon(widget.leadingIcon, color: widget.leadingIconColor),
                SizedBox(width: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(item),
                ),
              ],
            );
          }).toList();
        },
      ),
    );
  }
}

class DropDownFieldBuilderDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropDownFieldBuilder()
        .options(['Item 1', 'Item 2', 'Item 3'])
        .selected('Item 1')
        .setSize(height: 60)
        .paddingAll(8.0)
        .iconColor(Colors.blue)
        .leadingIcon(icon: Icons.star, color: Colors.red)
        .onSelected((selectedItem) {
      print('Selected item: $selectedItem');
    })
        .fillMaxWidth()
        .build();
  }
}

void main() => runApp(MaterialApp(home: Scaffold(body: DropDownFieldBuilderDemo())));
