part of core_ui;




class DropdownWidget extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String hints;
  ///added later to cover the use cases such as to set a initial item while editing
  final String? initial;
  final bool disable;
  final bool clearPresentation;

  const DropdownWidget({
    super.key,
    required this.options,
    this.initial,
    this.disable=false,
    this.hints='Select an option',
    this.clearPresentation=true,
    required this.onSelected,
  });

  @override
  DropdownWidgetState createState() => DropdownWidgetState();
}

class DropdownWidgetState extends State<DropdownWidget> {
  String? _selectedItem;
  late final tag=runtimeType.toString();
@override
  void initState() {
    super.initState();
    //accessing index catch the exception because list may be empty
    try{
      _selectedItem= widget.initial ?? widget.options[0];
       widget.onSelected(_selectedItem!);
    }
    catch(_){}

  }
  @override
  Widget build(BuildContext context) {
  final isSelected= widget.options.contains(_selectedItem);
  final disable=widget.disable;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        border: Border.all(color: HexColor("#1F7396")),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            style:ThemeInfo.textFieldStyle,
            //TODO:Important, otherwise will throw exception if the selected value is not present in the options
            value: isSelected?_selectedItem:null,
            hint: isSelected?null: Text(widget.hints),
            items: widget.options.map((option)=>
                DropdownMenuItem(value: option, child: Text(
                    widget.clearPresentation?option.cleanAndCapitalizeOrOriginal():option,
                ))
            ).toList(),
            onChanged:disable?null: updateState,
          ),
        ),
      ),
    );

  }
  void updateState(String? selected){
    if (selected != null) {
      setState(() {
        _selectedItem = selected;
      });
      widget.onSelected(selected);
    }
  }

}
class DropdownWidget2 extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String hints;
  ///added later to cover the use cases such as to set a initial item while editing
  final String? initial;
  final bool disable;
  final bool clearPresentation;

  const DropdownWidget2({
    super.key,
    required this.options,
    this.initial,
    this.disable=false,
    this.hints='Select an option',
    this.clearPresentation=true,
    required this.onSelected,
  });

  @override
  DropdownWidgetState createState() => DropdownWidgetState();
}

class DropdownWidgetState2 extends State<DropdownWidget2> {
  String? _selectedItem;
  late final tag=runtimeType.toString();
  @override
  void initState() {
    super.initState();
    //accessing index catch the exception because list may be empty
    try{
      Logger.on(tag,'initial=${widget.initial}');
      _selectedItem= widget.initial ?? widget.options[0];
      widget.onSelected(_selectedItem!);
    }
    catch(_){}

  }
  @override
  Widget build(BuildContext context) {
    final isSelected= widget.options.contains(_selectedItem);
    final disable=widget.disable;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        border: Border.all(color: HexColor("#1F7396")),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            style:ThemeInfo.textFieldStyle,
            //TODO:Important, otherwise will throw exception if the selected value is not present in the options
            value: isSelected?_selectedItem:null,
            hint: isSelected?null: Text(widget.hints),
            items: widget.options.map((option)=>
                DropdownMenuItem(value: option, child: Text(
                  widget.clearPresentation?option.cleanAndCapitalizeOrOriginal():option,
                ))
            ).toList(),
            onChanged:disable?null: updateState,
          ),
        ),
      ),
    );

  }
  void updateState(String? selected){
    if (selected != null) {
      setState(() {
        _selectedItem = selected;
      });
      widget.onSelected(selected);
    }
  }

}

