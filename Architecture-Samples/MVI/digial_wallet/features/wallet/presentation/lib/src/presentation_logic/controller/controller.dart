import 'package:core_ui/core_ui_api.dart';
import 'package:wallet_domain/domain_api.dart';


abstract class Controller implements CoreController {
  Stream<List<BreakdownItemData>> get breakdowns;
  Stream<SpendData?> get spendData;

  ///read both recent spend and breakdown data
  void read();

}