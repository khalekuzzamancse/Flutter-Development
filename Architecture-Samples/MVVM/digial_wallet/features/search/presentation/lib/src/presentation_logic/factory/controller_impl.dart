import 'dart:async';
import 'package:core_ui/core_ui_api.dart';
import 'package:search_di/di_container.dart';
import 'package:search_domain/domain_api.dart';

import '../controller/controller.dart';
import '../model/axis_data_model.dart';
import '../model/time_period_model.dart';
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
