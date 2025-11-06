
import '../model/break_down_model.dart';
import '../model/spend_model.dart';

abstract class Repository{
  Future<List<BreakdownModel>> readBreakDownData();
  Future<SpendModel> readSpendData();

}