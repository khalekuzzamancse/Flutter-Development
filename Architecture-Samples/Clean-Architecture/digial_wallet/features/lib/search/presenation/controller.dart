

import 'package:features/core/core_presentation_logic.dart';
import 'package:features/search/presenation/time_period_model.dart';
import 'package:features/wallet/domain/model/spend_model.dart';
import '../domain/model/chart_data_model.dart';
import '../domain/model/product_model.dart';
import 'axis_data_model.dart';

abstract class Controller implements CoreController {
  Stream<List<ProductModel>> get products;
  Stream<SpendSummaryModel?> get graphData;
  Stream<AxisData?> get axisData;
  //selected time period
  Stream<TabModel?> get tabs;
  Stream<SpendModel?> get spendData;
  void onSelected(String value);
  ///read both recent product and chart source
  void read();

}