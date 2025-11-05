part of core_ui;

class SearchBarWidget extends StatefulWidget {
  final Function(String query) onQuery;
  final Widget? trailingIcon;
  final String hint;
  final Color backgroundColor;
  final double? width; // Optional width

  const SearchBarWidget({
    Key? key,
    required this.onQuery,
    this.trailingIcon,
    this.hint = "Search...",
    this.backgroundColor = Colors.white,
    this.width = 200, // Allow passing customer width
  }) : super(key: key);

  @override
  SearchBarWidgetState createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  Timer? _debounceTimer;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity, // Use customer width if provided
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(ThemeInfo.searchBarRadius),
        color: widget.backgroundColor,
      ),

      child: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.text,
              onSubmitted: (value){
                widget.onQuery(value);
              },
              onChanged: (query) {
                if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(seconds: 1), () {
                  widget.onQuery(query);
                });
              },
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isDense: true,
                hintText: widget.hint,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          if (widget.trailingIcon != null) Row(
            children: [
              widget.trailingIcon!,
            //  SpacerHorizontal(8),
            ],
          ),
        ],
      ),
    );
  }
}


class SearchIcon extends StatelessWidget {
  final Color? backgroundColor; // Optional background color
  final Color? iconColor; // Optional icon color
  final double? width; // Optional width

  const SearchIcon({
    Key? key,
    this.backgroundColor = ThemeInfo.searchIconColor,
    this.iconColor = Colors.white, // Default: black icon
    this.width = 40.0, // Default: 40 width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height:40 ,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.only(
          topRight: ThemeInfo.searchBarRadius,
          bottomRight:ThemeInfo.searchBarRadius,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.search,
          color: iconColor,
        ),
      ),
    );
  }
}
