
import 'package:features/core/core_presentation_logic.dart';
import '../domain/model/break_down_model.dart';
import '../domain/model/spend_model.dart';

abstract class Controller implements CoreController {
  Stream<List<BreakdownModel>> get breakdowns;
  Stream<SpendModel?> get spendData;

  ///read both recent spend and breakdown source
  void read();

}