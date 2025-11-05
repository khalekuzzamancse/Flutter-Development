import 'package:flutter/material.dart';

import 'custom_chart.dart';


class FeatureModuleEntryPoint extends StatelessWidget {
  const FeatureModuleEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(child:  const GraphScreen());
  }
}
