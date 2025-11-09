import 'dart:async';

import 'package:features/core/core_language.dart';
import 'package:features/core/core_presentation_logic.dart';
import 'package:features/search/presenation/time_period_model.dart';
import 'package:features/wallet/domain/model/spend_model.dart';
import '../../di_container.dart';
import '../domain/model/chart_data_model.dart';
import '../domain/model/product_model.dart';
import 'axis_data_model.dart';
import 'controller.dart';

//TODO: Implement to dispose the stream
class ControllerImpl with CoreControllerMixin implements Controller {
  final _products = MutableStateFlow<List<ProductModel>>(List.empty());
  final _graphData = MutableStateFlow<SpendSummaryModel?>(null);
  final _tabs = MutableStateFlow<TabModel?>();
  final _axisData=MutableStateFlow<AxisData?>(null);
  final _spendData = MutableStateFlow<SpendModel?>(null);

  var _selected='1W';
  SpendSummaryModel? _data=null;

  @override
  Stream<SpendSummaryModel?> get graphData => _graphData.asStateFlow();
  @override
  Stream<SpendModel?> get spendData => _spendData.asStateFlow();
  @override
  Stream<List<ProductModel>> get products => _products.asStateFlow();

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
      print("readProducts:$products");
      Logger.on("readProducts", "$products");
      _products.update(products);
      final spendData = await DiContainer.spendDataUseCase().execute();
      _spendData.update(spendData);
    } catch (e) {
      print("readProducts:$e");
    } finally {
      stopLoading();
    }
  }
  void _updateState(){
    _tabs.update(TabModel(_data?.timePeriods??[], _selected));
    _axisData.update(AxisData(_data?.data[_selected]?.xAxisData??[], _data?.data[_selected]?.yAxisData??[]));
  }



}
