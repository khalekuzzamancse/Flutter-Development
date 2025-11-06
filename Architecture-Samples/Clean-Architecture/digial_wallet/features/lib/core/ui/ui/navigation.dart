part of '../../core_ui.dart';

// Custom NavigationItem class to hold label, icon, and optional selected icon.
class NavigationItem {
  final String label;
  final Icon icon;
  final Icon? selectedIcon;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });
}


// Implementation of the builder
class NavigationBuilder  {
  final List<NavigationItem> _navigationItems = [];
  AppBar? _appBar;
  Widget? _body;
  FloatingActionButton? _fab;
  int? _selectedIndex;
  ValueChanged<int>? _onItemClicked;
  Color? _iconColor;

  /// Typically, the size and other properties of the navigation item need to be customized.
  /// Therefore, we use an `Icon` instead of `IconData` to reduce the need for additional wrapping
  /// in the consumer code.
  ///
  /// Furthermore, the color of the navigation items should be consistent across all items,
  /// using either the primary or secondary color,because it is clickable. To achieve this, you can pass the color
  /// through different parameters or edit the code here.
  ///
  /// Since this code is used in different projects, and an app usually has only one navigation decorator,
  /// it is acceptable to edit the source code per project to avoid unnecessary methods and lengthy code.
  NavigationBuilder addItems(List<NavigationItem> items) {
    _navigationItems.addAll(items);
    return this;
  }


  NavigationBuilder addNavigationItem(NavigationItem item) {
    _navigationItems.add(item);
    return this;
  }


  NavigationBuilder addItem({
    required String label,
    required IconData icon,
    IconData? selectedIcon,
  }) {
    _navigationItems.add(NavigationItem(
      label: label,
      icon: Icon(icon),
      selectedIcon: Icon(selectedIcon),
    ));
    return this;
  }


  NavigationBuilder iconColor(Color color) {
    _iconColor = color;
    return this;
  }


  NavigationBuilder appBar(AppBar? appBar) {
    _appBar = appBar;
    return this;
  }


  NavigationBuilder body(Widget body) {
    _body = body;
    return this;
  }


  NavigationBuilder floatingActionButton(FloatingActionButton? fab) {
    _fab = fab;
    return this;
  }


  NavigationBuilder selectedIndex(int index) {
    _selectedIndex = index;
    return this;
  }


  NavigationBuilder onItemClicked(ValueChanged<int> callback) {
    _onItemClicked = callback;
    return this;
  }


  Widget build(BuildContext context) {
    if (_navigationItems.isEmpty || _body == null || _selectedIndex == null) {
      throw Exception(
          "Navigation items, body, and selected index must be provided.");
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isCompactMode = screenWidth < 600;
    final bool isExpandedMode = screenWidth > 800;
    final bool isMediumMode = screenWidth >= 600 && screenWidth <= 800;

    final colors = _getNavigationColors(context);

    return Scaffold(
      appBar: _appBar,
      body: Row(
        children: [
          if (isExpandedMode)
            _Drawer(
              navigationItems: _navigationItems,
              selectedIndex: _selectedIndex!,
              onItemClicked: _onItemClicked!,
              colors: colors,
            ),
          if (isMediumMode)
            _NavigationRail(
              navigationItems: _navigationItems,
              selectedIndex: _selectedIndex!,
              onItemClicked: _onItemClicked!,
              colors: colors,
            ),
          Expanded(
            child: _body!,
          ),
        ],
      ),
      bottomNavigationBar: isCompactMode
          ? _NavigationBar(
              navigationItems: _navigationItems,
              selectedIndex: _selectedIndex!,
              onItemClicked: _onItemClicked!,
              colors: colors,
            )
          : null,
      floatingActionButton: _fab,
    );
  }

  // Function to get navigation-related colors
  _NavigationColors _getNavigationColors(BuildContext context) {
    return _NavigationColors(
      selectedColor: Theme.of(context).colorScheme.primary,
      unselectedIconColor:
          _iconColor ?? Theme.of(context).unselectedWidgetColor,
      unselectedTextColor: Theme.of(context).textTheme.bodyMedium?.color,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }
}

/**
 *  Using drawer instead of nav rail because NavRail will place the label+icon in a column and I do not want that
 * and there is no way to pass a custom navigation widget item to the nav rail that is why using drawer but the drawer has  a draw back,
 * it need hardcoded width to avoid default width because not allowed to change the content width dynamic as jetpack compose do
 */
class _Drawer extends StatelessWidget {
  final List<NavigationItem> navigationItems;
  final int selectedIndex;
  final ValueChanged<int> onItemClicked;
  final _NavigationColors colors;

  const _Drawer({
    Key? key,
    required this.navigationItems,
    required this.selectedIndex,
    required this.onItemClicked,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200 ,//According this app the top most destination label+icon I set a width, change it according to your project need,
      child: ListView(
        padding: EdgeInsets.zero,
        children: navigationItems.asMap().entries.map((entry) {
          int index = entry.key;
          NavigationItem item = entry.value;
          return _NavigationItem(
            index: index,
            item: item,
            selectedIndex: selectedIndex,
            onTap: onItemClicked,
            colors: colors,
          );
        }).toList(),
      ),
    );
  }
}

// Custom NavigationRail Widget
class _NavigationRail extends StatelessWidget {
  final List<NavigationItem> navigationItems;
  final int selectedIndex;
  final ValueChanged<int> onItemClicked;
  final _NavigationColors colors;

  const _NavigationRail({
    Key? key,
    required this.navigationItems,
    required this.selectedIndex,
    required this.onItemClicked,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemClicked,
      labelType: NavigationRailLabelType.selected,
      destinations: navigationItems.map((item) {
        return NavigationRailDestination(
          icon: Icon(item.icon.icon, color: colors.unselectedIconColor),
          selectedIcon:
              Icon(item.selectedIcon?.icon, color: colors.selectedColor),
          label: Text(item.label),
        );
      }).toList(),
    );
  }
}

// Custom NavigationBar Widget
class _NavigationBar extends StatelessWidget {
  final List<NavigationItem> navigationItems;
  final int selectedIndex;
  final ValueChanged<int> onItemClicked;
  final _NavigationColors colors;

  const _NavigationBar({
    Key? key,
    required this.navigationItems,
    required this.selectedIndex,
    required this.onItemClicked,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemClicked,
      destinations: navigationItems.map((item) {
        return NavigationDestination(
          icon: Icon(item.icon.icon, color: colors.unselectedIconColor),
          selectedIcon:
              Icon(item.selectedIcon?.icon, color: colors.selectedColor),
          label: item.label,
        );
      }).toList(),
    );
  }
}

// Reusable Custom NavigationItem Widget
class _NavigationItem extends StatelessWidget {
  final int index;
  final NavigationItem item;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final _NavigationColors colors;

  const _NavigationItem({
    Key? key,
    required this.index,
    required this.item,
    required this.selectedIndex,
    required this.onTap,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        item.icon.icon,
        color: selectedIndex == index
            ? colors.selectedColor
            : colors.unselectedIconColor,
      ),
      title: Text(
        item.label,
        style: TextStyle(
          color: selectedIndex == index
              ? colors.selectedColor
              : colors.unselectedTextColor,
        ),
      ),
      selected: selectedIndex == index,
      selectedTileColor: colors.selectedTileColor,
      onTap: () => onTap(index),
    );
  }
}

// Color settings used by all navigation widgets
class _NavigationColors {
  final Color selectedColor;
  final Color unselectedIconColor;
  final Color? unselectedTextColor;
  final Color selectedTileColor;

  _NavigationColors({
    required this.selectedColor,
    required this.unselectedIconColor,
    this.unselectedTextColor,
    required this.selectedTileColor,
  });
}
