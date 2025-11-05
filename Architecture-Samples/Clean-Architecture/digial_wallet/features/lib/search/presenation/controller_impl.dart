import 'dart:async';

import 'package:features/search/presenation/time_period_model.dart';

import '../../core/ui/presentation_logic/core_controller.dart';
import '../../core/ui/presentation_logic/state_flow.dart';
import '../../di_container.dart';
import '../domain/model/chart_data_model.dart';
import '../domain/model/product_model.dart';
import 'axis_data_model.dart';
import 'controller.dart';

//TODO: Implement to dispose the stream
class ControllerImpl with CoreControllerMixin implements Controller {
  final _products = MutableStateFlow<List<Product>>(List.empty());
  final _graphData = MutableStateFlow<ChartData?>(null);
  final _tabs = MutableStateFlow<TabModel?>();
  final _axisData=MutableStateFlow<AxisData?>(null);

  var _selected='1W';
  ChartData? _data=null;

  @override
  Stream<ChartData?> get graphData => _graphData.asStateFlow();

  @override
  Stream<List<Product>> get products => _products.asStateFlow();

  @override
  Stream<TabModel?> get tabs => _tabs.asStateFlow();
  @override
  Stream<AxisData?> get axisData => _axisData.asStateFlow();

  @override
  void onSelected(String value) async{
    _selected=value;
    _updateState();
  }

  @override
  void read() async {
    startLoading();
    try {
      final graphData = await DiContainer.readCharData().execute();
      _data=graphData;
      _graphData.update(graphData);
      _updateState();
      final products = await DiContainer.readProducts().execute();
      _products.update(products);
    } catch (e) {
    } finally {
      stopLoading();
    }
  }
  void _updateState(){
    _tabs.update(TabModel(_data?.timePeriods??[], _selected));
    _axisData.update(AxisData(_data?.data[_selected]?.xAxisData??[], _data?.data[_selected]?.yAxisData??[]));
  }



}
