import 'package:features/core/data_source/data_source.dart';
import 'package:features/home/domain/models.dart';
import 'package:features/home/domain/repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  late final AccountApi _accountApi = ApiFactory.create().accountApi;

  @override
  Future<List<LoanModel>> readLoansOrThrow() async {
    final entity = await _accountApi.readActiveLoansOrThrow();
    return entity
        .map((e) => LoanModel(
            name: e.model,
            imageLink: e.imageLink,
            price: e.price,
            date: e.date, status:LoanStatus.none))
        .toList();
  }

  @override
  Future<List<CardModel>> readOrThrow() async{
    final entity = await _accountApi.readCardsOrThrow();
    return entity.map((e) => CardModel(
      cardName: e.cardName,
      cardNo: e.cardNo,
      dueDate: e.dueDate,
      amount: e.amount,
      type: e.type,
    )).toList();
  }
}
//TODO
