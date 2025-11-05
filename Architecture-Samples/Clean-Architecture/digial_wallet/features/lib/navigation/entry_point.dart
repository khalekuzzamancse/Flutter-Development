import 'package:flutter/material.dart';
import 'navigation.dart';
class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
   return SafeArea(child: RootNavigation());
  }
}



