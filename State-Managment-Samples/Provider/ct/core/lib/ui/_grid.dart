part of core_ui;
///# Caution
/// - The scrollbar will only appear when the item is overflowed otherwise it will not appear
class CustomGridView extends StatefulWidget {
  final List<Widget> children;
  final double minWidth,horizontalGap,verticalGap;
  final bool showScrollbar;
  final ScrollbarThemeData? scrollbarTheme;
  final void Function()? onListEnd;

  const CustomGridView({
    Key? key,
    required this.children,
    this.minWidth = 120,
    this.showScrollbar = true,
    this.scrollbarTheme,
    this.onListEnd,  this.horizontalGap=12,  this.verticalGap=12,
  }) : super(key: key);

  @override
  State<CustomGridView> createState() => CustomGridViewState();
}

class CustomGridViewState extends State<CustomGridView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
        if (widget.onListEnd != null) {
          widget.onListEnd!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = constraints.maxWidth;
        final minWidth = widget.minWidth;
        int crossAxisCount = (maxWidth ~/ minWidth);

        // Create the GridView
        Widget gridView = GridView.builder(
            controller: scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: widget.verticalGap,
              crossAxisSpacing: widget.horizontalGap,
            ),
            itemCount: widget.children.length,
            itemBuilder: (context, index) {
              return widget.children[index];

            });


        if (widget.showScrollbar && widget.scrollbarTheme != null) {
          return  Theme(
            data: Theme.of(context).copyWith(scrollbarTheme: widget.scrollbarTheme),

            child: Scrollbar(//Adding a extra scrollbar keeping gap between the Grid
              controller:scrollController ,
              thickness: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 32.0),
                //Remove the Grid default internal temporary scrollbar to avoid cut off the content
                child: ScrollbarHider(child: gridView),
              ),
            ),
          );
        } else if (widget.showScrollbar) {
          return Scrollbar(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: gridView,
            ),
          );
        } else {
          return ScrollbarHider(child: gridView);
        }
      },
    );
  }
}