import 'package:core_ui/core_ui_api.dart';
import 'package:search_domain/domain_api.dart';

import '../model/axis_data_model.dart';
import '../model/time_period_model.dart';

abstract class Controller implements CoreController {
  Stream<List<Product>> get products;
  Stream<ChartData?> get graphData;
  Stream<AxisData?> get axisData;
  //selected time period
  Stream<TabModel?> get tabs;
  void onSelected(String value);
  ///read both recent product and chart data
  void read();

}