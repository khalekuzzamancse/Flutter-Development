// Singleton factory class


import 'ContainerBuilder.dart';
import 'PaddingBuilder.dart';

class WidgetsBuilderFactory {
  WidgetsBuilderFactory._privateConstructor();

  static final WidgetsBuilderFactory _instance = WidgetsBuilderFactory._privateConstructor();

  static WidgetsBuilderFactory get instance => _instance;

  ContainerBuilderImpl containerBuilder() {
    return ContainerBuilderImpl();
  }
  PaddingBuilder paddingBuilder(){
    return PaddingBuilderImpl();
  }
}