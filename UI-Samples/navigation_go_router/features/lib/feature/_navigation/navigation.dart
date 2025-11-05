import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:features/core/ui/core_ui.dart';
import 'package:features/feature/gallery/gallery_screen.dart';
import 'package:features/feature/info/about_app_screen.dart';
import 'package:features/feature/info/about_us_screen.dart';
import 'package:features/feature/info/home_screen.dart';
import 'package:features/feature/info/manual_screen.dart';


import 'material_theme.dart';

//The concept  is from
// ->  https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/others/custom_stateful_shell_route.dart

final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'root');
final _manualScreenKey = GlobalKey<NavigatorState>(debugLabel: "manualScreen");
final _homeScreenKey = GlobalKey<NavigatorState>(debugLabel: "homeScreen");
final _aboutAppScreenKey = GlobalKey<NavigatorState>(
    debugLabel: "aboutAppScreen");
final _aboutUsScreenKey = GlobalKey<NavigatorState>(
    debugLabel: "aboutUsScreen");
final _galleryScreenKey = GlobalKey<NavigatorState>(
    debugLabel: "galleryScreen");

class RootNavigation extends StatelessWidget {
  RootNavigation({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: _NavGraph.pathHome,
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
      themeMode: ThemeMode.system,
      theme: ThemeData(colorScheme: MaterialTheme.lightScheme()),
      darkTheme: ThemeData(colorScheme: MaterialTheme.darkScheme()),
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


//@formatter:off
class _NavGraph {

  static const pathManual="/manual";
  static const pathHome="/home";
  static const pathAboutApp="/about_app";
  static const pathAboutUs="/about_us";
  static const pathGallery="/gallery";
  static const pathClassifier="/classifier";


  static List<StatefulShellBranch> createAllNavGraph()=>
      [createHomeGraph(),
        createManualGraph(),
        createAboutAppGraph(),
        createAboutUsGraph(),

      ];

  /// - Creating the issue list `Nav Graph`,not holding as static variable to avoid memory leak
  /// - Under the hood it delegate  to [StatefulShellBranch]
  /// - `return` a [StatefulShellBranch] that can be used with [StatefulShell]
  ///
  //TODO:Nav Graph section
  static StatefulShellBranch createManualGraph()=> StatefulShellBranch(
      navigatorKey: _manualScreenKey,
      routes: <RouteBase>[_manualScreen()]
  );
  static StatefulShellBranch createHomeGraph()=> StatefulShellBranch(
      navigatorKey: _homeScreenKey,
      routes: <RouteBase>[_homeScreen(),_galleryScreen()]
  );
  static StatefulShellBranch createAboutAppGraph()=> StatefulShellBranch(
      navigatorKey: _aboutAppScreenKey,
      routes: <RouteBase>[_aboutAppScreen()]
  );
  static StatefulShellBranch createAboutUsGraph()=> StatefulShellBranch(
      navigatorKey: _aboutUsScreenKey,
      routes: <RouteBase>[_aboutUsScreen()]
  );



  static GoRoute _manualScreen()=> GoRoute(
      path: pathManual,
      builder: (BuildContext context, GoRouterState state) =>  ManualScreen(),
      routes:noSubRoute
  );
  static GoRoute _homeScreen()=> GoRoute(
      path: pathHome,
      builder: (BuildContext context, GoRouterState state) =>  HomeScreen(
        onGalleryRequest: (){
          context._navigate(pathGallery);
        },
      ),
      routes:noSubRoute
  );
  static GoRoute _aboutAppScreen()=> GoRoute(
      path: pathAboutApp,
      builder: (BuildContext context, GoRouterState state) => AboutAppScreen(),
      routes:noSubRoute
  );
  static GoRoute _aboutUsScreen()=> GoRoute(
      path: pathAboutUs,
      builder: (BuildContext context, GoRouterState state) => AboutUsPage(),
      routes:noSubRoute
  );
  static GoRoute _galleryScreen()=> GoRoute(
      path: pathGallery,
      builder: (BuildContext context, GoRouterState state) => GalleryScreen(
        onProcessRequest: (_){},
      ),
      routes:noSubRoute
  );




  /// - Present empty route that might be helpful to make code more readable
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
        .addItem(label: 'Home', icon: Icons.home_outlined)
        .addItem(label: 'Manual', icon: Icons.book_outlined)
        .addItem(label: 'About App', icon: Icons.perm_device_info_outlined)
        .addItem(label: 'About Us', icon: Icons.person_outline)
        .body( AnimatedBranchContainer(currentIndex: currentIndex, children: children))
        .selectedIndex(currentIndex)
        .onItemClicked(onTap)
        .build(context);
      //  .modifier(Modifier().linearGradient([Color(0xFFF0F2F5), Color(0xFFFFFFFF)])); // Pass the BuildContext here
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