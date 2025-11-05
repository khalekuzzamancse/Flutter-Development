
import '../model/break_down_model.dart';
import '../model/spend_model.dart';

abstract class Repository{
  Future<List<BreakdownItemData>> readBreakDownData();
  Future<SpendData> readSpendData();

}