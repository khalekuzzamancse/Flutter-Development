part of core_ui;

class CustomListView extends StatefulWidget {
  final bool showScrollbar;
  final List<Widget> children;
  final Color thumbColor, trackColor;
  ///If to hide the divider pass  null
  final Color? dividerColor,background;
  final ScrollbarOrientation scrollbarOrientation;
  final void Function()? onEnd;

  const CustomListView({
    Key? key,
    required this.children,
    this.onEnd,
    this.showScrollbar = true,
    this.thumbColor = Colors.blue,
    this.trackColor = const Color.fromRGBO(0, 84, 119, 1),
    this.dividerColor,
    this.background,
    this.scrollbarOrientation = ScrollbarOrientation.right,
  }) : super(key: key);

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.atEdge && controller.position.pixels != 0) {
        // Reached the bottom
        if (widget.onEnd != null) {
          widget.onEnd!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollbarThemeData scrollbarTheme = ScrollbarThemeData(
       thumbVisibility: WidgetStateProperty.all(true),
      trackVisibility: WidgetStateProperty.all(true),
      trackColor: WidgetStateProperty.all(widget.trackColor),
      thumbColor: WidgetStateProperty.all(widget.thumbColor),
      radius: const Radius.circular(5),
    );
    Widget listView=const SizedBox.shrink(); //just for initialize
    final dividerColor=widget.dividerColor;
    //show divider
    if(dividerColor!=null){
      listView= Container(
        color: widget.background,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => Divider(
            height: 2, color: dividerColor),
          controller: controller,
          shrinkWrap: true,
          itemCount: widget.children.length,
          itemBuilder: (context, index)=>widget.children[index]
        ),
      );
    }
    else{
      listView= Container(
        color: widget.background,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: controller,
            shrinkWrap: true,
            itemCount: widget.children.length,
            itemBuilder: (context, index)=>widget.children[index]
        ),
      );
    }


    if (widget.showScrollbar) {
      return ScrollDecorator(
          controller: controller,
          orientation: widget.scrollbarOrientation,
          theme: scrollbarTheme,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: listView,
          ));
    } else {
      return ScrollbarHider(child: listView);
    }
  }
}

class ScrollDecorator extends StatelessWidget {
  final Widget child;
  final ScrollController controller;
  final ScrollbarOrientation orientation;
  final ScrollbarThemeData theme;
  final double thickness;
  final EdgeInsets padding;


  const ScrollDecorator(
      {super.key,
      required this.child,
      required this.controller,
      required this.orientation,
        this.thickness=6,
        this.padding=const EdgeInsets.only(right: 16.0),
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(scrollbarTheme: theme),
      child: Scrollbar(
        //Adding a extra scrollbar keeping gap between the Grid,
        controller: controller,
        thickness: thickness,
        scrollbarOrientation:orientation,
        child: Padding(
          padding: padding,
          //Remove the Grid default internal temporary scrollbar to avoid cut off the content
          child: ScrollbarHider(child: child),
        ),
      ),
    );
  }
}

class ScrollbarHider extends StatelessWidget {
  final Widget child;
  const ScrollbarHider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: child);
  }
}

