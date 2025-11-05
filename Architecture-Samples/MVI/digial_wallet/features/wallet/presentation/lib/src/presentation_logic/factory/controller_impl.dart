import 'dart:async';
import 'package:core_ui/core_ui_api.dart';
import 'package:wallet_di/di_container.dart';
import 'package:wallet_domain/domain_api.dart';
import '../controller/controller.dart';

class ControllerImpl with CoreControllerMixin implements Controller {
  final _breakdowns= MutableStateFlow<List<BreakdownItemData>>(List.empty());
  final _spendData = MutableStateFlow<SpendData?>(null);

  @override
  Stream<List<BreakdownItemData>> get breakdowns =>_breakdowns.asStateFlow();
  @override
  Stream<SpendData?> get spendData => _spendData.asStateFlow();

  @override
  void read() async {
    startLoading();
    try {
      final spendData = await DiContainer.spendDataUseCase().execute();
      _spendData.update(spendData);
      final breakdowns=await DiContainer.breakdownCase().execute();
      _breakdowns.update(breakdowns);
    } catch (e) {
      onException(e);
    } finally {
      stopLoading();
    }
  }


}
