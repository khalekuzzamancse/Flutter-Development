import 'package:flutter/material.dart';
import 'package:snowchat_ios/core/ui/app_color.dart';

class SearchDecorator extends StatefulWidget {
  final Widget content;
  final Icon leadingIcon;
  final Function(String query)? onQuery;
  final Function()? onBack;
  final String hint;
  final Color backgroundColor;
  final Color iconColor;
  final Color hintColor;

  const SearchDecorator({
    Key? key,
    required this.content,
    this.leadingIcon = const Icon(Icons.arrow_back),
    this.onQuery,
    this.onBack,
    this.hint = 'Search...',
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.iconColor = Colors.black,
    this.hintColor = Colors.grey,
  }) : super(key: key);

  @override
  SearchDecoratorState createState() => SearchDecoratorState();
}

class SearchDecoratorState extends State<SearchDecorator> {
  String _query = '';
  final TextEditingController _controller = TextEditingController();

  void _clearSearch() {
    setState(() {
      _query = '';
      _controller.clear();
      if (widget.onQuery != null) {
        widget.onQuery!('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(onQuery: widget.onQuery,onBack: widget.onBack),
      body: widget.content
    );
  }
}


class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String>? onQuery;
  final   Function()?  onBack;

  const TopBar({Key? key, this.onQuery, required this.onBack}) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Define the TopBar height
}

class _TopBarState extends State<TopBar> {
  String _query = '';
  final TextEditingController _controller = TextEditingController();

  void _clearSearch() {
    setState(() {
      _query = '';
      _controller.clear();
      if (widget.onQuery != null) {
        widget.onQuery!('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: widget.preferredSize.height + statusBarHeight,
      padding: EdgeInsets.only(top: statusBarHeight),
      color: AppColor.primary, // Background color of the TopBar
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed:widget.onBack,
          ),
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _query = value;
                  if (widget.onQuery != null) {
                    widget.onQuery!(value);
                  }
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              color: Colors.white,
              onPressed: _clearSearch,
            ),
        ],
      ),
    );
  }
}



