
import '../../core/ui/presentation_logic/core_controller.dart';
import '../domain/model/break_down_model.dart';
import '../domain/model/spend_model.dart';

abstract class Controller implements CoreController {
  Stream<List<BreakdownItemData>> get breakdowns;
  Stream<SpendData?> get spendData;

  ///read both recent spend and breakdown data
  void read();

}