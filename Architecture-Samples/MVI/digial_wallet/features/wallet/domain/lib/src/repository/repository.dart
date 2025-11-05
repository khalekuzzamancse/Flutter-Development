import '../../domain_api.dart';
abstract class Repository{
  Future<List<BreakdownItemData>> readBreakDownData();
  Future<SpendData> readSpendData();

}