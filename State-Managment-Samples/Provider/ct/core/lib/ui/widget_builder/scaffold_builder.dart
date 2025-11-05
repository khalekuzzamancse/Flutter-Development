



import 'fab_builder.dart';
import 'package:flutter/material.dart';

Widget scaffoldBuilderDemo() {
  // var appbar = TopAppBarBuilder()
  //     // .addNavigationIcon(
  //     //     IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}))
  //     .addTitle(const Text("My Title"))
  //    // .addActions([IconButton(icon: const Icon(Icons.add), onPressed: () {})])
  //     //.addElevation(4.0)
  //     .build();

  var fab = FloatingActionButtonBuilder()
      .addIcon(const Icon(Icons.add))
      .addClickListener(() => {})
      .addBackground(const Color.fromARGB(255, 236, 243, 33))
      .build();

  var scaffold = ScaffoldBuilder()
      .addTopBar(AppBar())
      .addBody(body:  const Text("Hello"))
      .addFab(fab)
      .setFabPosition(FloatingActionButtonLocation.endFloat)
      .build();

  return scaffold;
}
class ScaffoldBuilder {
  PreferredSizeWidget? _topAppbar;
  Widget? _body;
  Widget? _fab;
  FloatingActionButtonLocation? _floatingActionButtonLocation;

  ScaffoldBuilder addTopBar(PreferredSizeWidget topAppbar) {
    _topAppbar = topAppbar;
    return this;
  }

  ScaffoldBuilder addBody({required body,Alignment alignment=Alignment.center}) {
    _body = Container(
      alignment: alignment,
      child: body,
    );
    return this;
  }

  ScaffoldBuilder addFab(Widget fab) {
    _fab = fab;
    return this;
  }

  ScaffoldBuilder setFabPosition(FloatingActionButtonLocation fabPosition) {
    _floatingActionButtonLocation = fabPosition;
    return this;
  }
  Scaffold build() {
    return Scaffold(
      appBar: _topAppbar,
      body: _body,
      floatingActionButton: _fab,
      floatingActionButtonLocation: _floatingActionButtonLocation,
    );
  }
}

