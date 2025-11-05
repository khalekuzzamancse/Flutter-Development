import 'package:flutter/material.dart';

import 'feature/_navigation/navigation.dart';



class FeatureModuleEntryPoint extends StatelessWidget {
  const FeatureModuleEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(child: SafeArea(child: RootNavigation()));
  }
}
