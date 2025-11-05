

import 'package:features/search/presenation/time_period_model.dart';

import '../../core/ui/presentation_logic/core_controller.dart';
import '../domain/model/chart_data_model.dart';
import '../domain/model/product_model.dart';
import 'axis_data_model.dart';

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