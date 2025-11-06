import 'package:features/home/domain/models.dart';

abstract interface class HomeRepository{
  Future<List<CardModel>> readOrThrow();
  Future<List<LoanModel>> readLoansOrThrow();
}