import 'package:features/core/core_presentation_logic.dart';
import 'package:features/home/domain/models.dart';
import 'package:features/transaction/domain/transaction_repository.dart';

abstract class HomeController  implements CoreController {
  Stream<List<LoanModel>> get loans;
  Stream<List<TransactionModel>> get transactions;
  void read();
  void dispose();
}