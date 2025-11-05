import 'package:ComposableWidget/composable_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:search_presentation/search_apis.dart';
import 'package:wallet_presentation/wallet_apis.dart';

import 'home_screen.dart';
import 'material_theme.dart';

//The concept  is from
// ->  https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/others/custom_stateful_shell_route.dart

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final _searchKey = GlobalKey<NavigatorState>(debugLabel: "searchIssueKey");
final _homeScreenKey = GlobalKey<NavigatorState>(debugLabel: "homeScreenKey");
final _walletScreenKey =
    GlobalKey<NavigatorState>(debugLabel: "walletScreen");

class RootNavigation extends StatelessWidget {
  RootNavigation({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: _NavGraph.PATH_HOME,
    routes: <RouteBase>[
      StatefulShellRoute(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return navigationShell; //It is stateful widget
        },
        navigatorContainerBuilder: _navHost,
        branches: _NavGraph.createAllNavGraph(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      // themeMode: ThemeMode.system,
      // theme: ThemeData(colorScheme: MaterialTheme.lightScheme()),
      // darkTheme: ThemeData(colorScheme: MaterialTheme.darkScheme()),
      debugShowCheckedModeBanner: false,
    );
  }
}

/**
 * - This is equivalent to `Jetpack Compose` `NavHost`
 * - [navigationShell] is [StatefulNavigationShell] that is similar to `NavHostController`
 * - It follow the format of  [navigatorContainerBuilder]  which is typedef [ShellNavigationContainerBuilder] which is
 * function  that takes 3 argument and return [Widget]
 */

Widget _navHost(BuildContext context, StatefulNavigationShell navigationShell,
    List<Widget> children) {
  return _ScaffoldWithNavBar(
      currentIndex: navigationShell.currentIndex,
      onTap: (index) {
        //use goBranch() instead of go or push so that because need to manage separate back stack and restore the state
        navigationShell.goBranch(
          index,
          //initial location is the root of this branch,so if an active icon is double click then it will go to this
          //initial location,so it is optional to use
          initialLocation: (index == navigationShell.currentIndex),
        );
      },
      children: children);
}

/**
 * - This is equivalent to jetpack compose nav graph
 * - Under the hood it uses [StatefulShellBranch] to define the branches
 * - The branch is equivalent to jetpack compose separate nav graph that has a separate nav controller,
 * in the context of flutter nav controller is known as navigator, so here each branch require a separate navigator
 * - Providing the separate navigator is easy here just give a unique `navigatorKey`, you can think of this `navigatorKey`
 *  is a route of the nav graph or id of nav graph that should be unique
 *  - Then we have to define the actual list  route/screens using `GoRoute`
 *  - `GoRoute` is equivalent to jetpack compose `composable` function
 *  - We know the `composable` function takes `route` and `nav argument` and etc, same here here `GoRoute` takes
 *   `path`(equivalent to `composable`'s `route`) , and it has a builder function that used to define the route so this
 *   so must return a `Widget` from this function this `Widget` will be screen, so the `builder` method is similar to
 *   `composable`'s lambda parameter `block` where we define the screen
 *   - `GoRoute` can have it own set of nested screen , analogy ; think as it `composable` has it own list of `composable` that is
 *   represent the nested screen ,so these nested screen are replaced within the parent container(nav host) and maintain separate
 *   nav graph with nav controller(navigator)
 *   - We know in jetpack compose the NavHost content is replaced while navigating, that is why in case of bottom bar we
 *   make the bottom bar as direct child of NavHost so that is takes some space from the NavHost because we want to always show the
 *   bottom bar, unfortunately `Flutter` has not built in concept like NavHost, however go route provide this kind of
 *   facility to do that wrap the nav graph(branch) inside the `StatefulShellBranch` ,then you can use these branch
 *   with `StatefulShell` and this will give you the same facilities as the `Jetpack compose NavHost` give.
 *
 */
//@formatter:off
class _NavGraph {

  static const PATH_SEARCH="/search";
  static const PATH_HOME="/home";
  static const PATH_WALLET="/wallet";


  static List<StatefulShellBranch> createAllNavGraph()=>
      [createHomeGraph(),createSearchGraph(),createWalletGraph()];

  /**
   * - Creating the issue list `Nav Graph`,not holding as static variable to avoid memory leak
   * - Under the hood it delegate  to [StatefulShellBranch]
   * - `return` a [StatefulShellBranch] that can be used with [StatefulShell]
   **/
  //TODO:Nav Graph section
  static StatefulShellBranch createSearchGraph()=> StatefulShellBranch(
      navigatorKey: _searchKey,
      routes: <RouteBase>[_searchScreen()]
  );
  static StatefulShellBranch createHomeGraph()=> StatefulShellBranch(
      navigatorKey: _homeScreenKey,
      routes: <RouteBase>[_homeScreen()]
  );
  static StatefulShellBranch createWalletGraph()=> StatefulShellBranch(
      navigatorKey: _walletScreenKey,
      routes: <RouteBase>[_walletScreen()]
  );


  static GoRoute _searchScreen()=> GoRoute(
      path: PATH_SEARCH,
      builder: (BuildContext context, GoRouterState state) =>  SearchScreen(),
      routes:noSubRoute
  );
  static GoRoute _homeScreen()=> GoRoute(
      path: PATH_HOME,
      builder: (BuildContext context, GoRouterState state) =>  HomeScreen(),
      routes:noSubRoute
  );
  static GoRoute _walletScreen()=> GoRoute(
      path: PATH_WALLET,
      builder: (BuildContext context, GoRouterState state) => WalletScreen(),
      routes:noSubRoute
  );


  /**
   * - Present empty route that might be helpful to make code more readable
   */
  static final noSubRoute=List<RouteBase>.empty();
}

extension _GOStateExtensions on GoRouterState {
  String _getParam(String paramName) {
    final String userName = uri.queryParameters[paramName] ?? '';
    return userName;
  }

}

extension _BuildContextExtension on BuildContext{
  void  _navigate(String route)=>go(route);
}


//@formatter:off
class _ScaffoldWithNavBar extends StatelessWidget {
  // final StatefulNavigationShell navigationShell;
  final int currentIndex;
  final void Function(int) onTap;

  const _ScaffoldWithNavBar({
    // required this.navigationShell,
    required this.children,
    required this.onTap,
    Key? key,
    required this.currentIndex,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The children (branch Navigators) to display in a custom container
  /// ([AnimatedBranchContainer]).
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return  NavigationBuilder()
        .addItem(label: 'Home', icon: Icons.home, selectedIcon: Icons.home_filled)
        .addItem(label: 'Search', icon: Icons.search_rounded, selectedIcon: Icons.search)
        .addItem(label: 'Wallet', icon: Icons.wallet_outlined, selectedIcon: Icons.wallet)
        .body( AnimatedBranchContainer(currentIndex: currentIndex, children: children))
        .selectedIndex(currentIndex)
        .onItemClicked(onTap)
        .build(context)
        .modifier(Modifier().linearGradient([Color(0xFFF0F2F5), Color(0xFFFFFFFF)])); // Pass the BuildContext here
  }
}

/// Custom branch Navigator container that provides animated transitions
/// when switching branches.
class AnimatedBranchContainer extends StatelessWidget {
  /// Creates a AnimatedBranchContainer
  const AnimatedBranchContainer(
      {super.key, required this.currentIndex, required this.children});

  /// The index (in [children]) of the branch Navigator to display.
  final int currentIndex;

  /// The children (branch Navigators) to display in this container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: children.mapIndexed(
      (int index, Widget navigator) {
        return AnimatedScale(
          scale: index == currentIndex ? 1 : 1.5,
          duration: const Duration(milliseconds: 400),
          child: AnimatedOpacity(
            opacity: index == currentIndex ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: _branchNavigatorWrapper(index, navigator),
          ),
        );
      },
    ).toList());
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
      );
}

class _MiscScreen extends StatelessWidget {
  const _MiscScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Not Implemented yet", style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
