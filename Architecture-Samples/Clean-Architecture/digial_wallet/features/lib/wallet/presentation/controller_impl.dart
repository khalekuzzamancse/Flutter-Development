import 'dart:async';
import 'package:features/core/core_presentation_logic.dart';
import '../../di_container.dart';
import '../domain/model/break_down_model.dart';
import '../domain/model/spend_model.dart';
import 'controller.dart';


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
