import 'package:ComposableWidget/composable_widget.dart';
import 'package:flutter/material.dart';
import 'label_model.dart';

//@formatter:off
class LabelList extends StatelessWidget {
  final List<LabelModel> labels;

  const LabelList({required this.labels});

  @override
  Widget build(BuildContext context) {
    return (FlowRowBuilder(horizontalSpace: 8, verticalSpace: 8)
        .childAlign(WrapAlignment.start)
        .children(labels.map((model) => Label(model: model)).toList()))
        .build();
  }
}

// @formatter:off
class Label extends StatelessWidget {
  final LabelModel model;

  Label({required this.model});

  @override
  Widget build(BuildContext context) {
    Color background = _hexToColor(model.hexCode);
    double luminance = background.computeLuminance();
   final textColor=  luminance < 0.5 ? Colors.white : Colors.black;

    return (BoxBuilder(
      modifier:Modifier()
          .background(_hexToColor(model.hexCode))
          .roundedCornerShape(8)
          .clickable((){_showDialog(context);}))
        +Text(model.name,style:TextStyle(color: textColor)).modifier(Modifier().paddingAll(4)))
        .build();
  }


  void _showDialog(BuildContext context){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title:  Text(model.name),
        content:  Text(model.description??"No description found"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }
}



Color _hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) {
    buffer.write('ff'); // Add the alpha value if not provided
  }
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
