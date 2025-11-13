import 'package:features/home/domain/models.dart';
import 'package:features/transaction/domain/transaction_repository.dart';

abstract interface class HomeRepository{
  Future<List<CardModel>> readOrThrow();
  Future<List<LoanModel>> readLoansOrThrow();
  Future<List<TransactionModel>> readTransactionsOrThrow();
}