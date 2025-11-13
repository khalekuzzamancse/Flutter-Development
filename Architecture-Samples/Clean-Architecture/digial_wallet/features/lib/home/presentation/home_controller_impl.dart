
import 'package:features/core/core_language.dart';
import 'package:features/core/core_presentation_logic.dart';
import 'package:features/home/data/repository_impl.dart';
import 'package:features/home/domain/models.dart';
import 'package:features/home/domain/repository.dart';
import 'package:features/home/presentation/home_controller.dart';
import 'package:features/transaction/domain/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomeControllerImpl implements HomeController{
  final List<LoanModel> activeLoanItems = [];
  final _isLoading=BehaviorSubject<bool>.seeded(false);
  final _loans=BehaviorSubject<List<LoanModel>>.seeded([]);
  final _transactions=BehaviorSubject<List<TransactionModel>>.seeded([]);
  final _statusMessage=BehaviorSubject<MessageToUi?>.seeded(null);


  @override
  Stream<bool> get isLoading =>_isLoading.stream;
  @override
  Stream<List<LoanModel>> get loans =>_loans.stream;
  @override
  Stream<List<TransactionModel>> get transactions =>_transactions.stream;

  final user = 'George';
  final cards = [
    CardInfo(
        cardName: 'VISA',
        cardNo: '* * * 3854',
        dueDate: '10 OCT',
        amount: '\$5001.86',
        color: Colors.black),
    CardInfo(
        cardName: 'VISA',
        cardNo: '* * * 3854',
        dueDate: '10 OCT',
        amount: '\$5001.86',
        color: Colors.blue),
  ];
  final HomeRepository repository =HomeRepositoryImpl() ;

  final List<BillPayment> billPayments = [
    BillPayment(title: 'Electricity Bill', icon: Icons.lightbulb_outline),
    BillPayment(title: 'Internet Recharge', icon: Icons.wifi_outlined),
    BillPayment(title: 'Cable Bill', icon: Icons.tv_outlined),
    BillPayment(title: 'Mobile Recharge', icon: Icons.smartphone_outlined),
  ];


  @override
  void read() async{
    try{
      _isLoading.add(true);
      final loans=await repository.readLoansOrThrow();
      _loans.add(loans);
      final transactions=await repository.readTransactionsOrThrow();
      Logger.on("HomeController::", "transactions=${transactions.length}");
      _transactions.add(transactions);
    } catch (e) {
      Logger.on("HomeController::", "error=${e}");
    }
    finally{
      _isLoading.add(false);
    }
  }

  @override
  Stream<MessageToUi?> get statusMessage => _statusMessage.stream;
  @override
  void dispose() {
    _isLoading.close();
    _loans.close();
    _transactions.close();
    _statusMessage.close();
  }
}

//@formatter:off
class CardInfo {
  final String cardName,cardNo,dueDate,amount;
  final Color color;//TODO:Controller belongs to `Presentation` Logic layer that is UI framework independent
  //so should not keep the color reference at controller, instead card type or metadata should be kept based on
  //these source ui will determine the color,but for testing purpose storing color here
  //How ever since color code is just text, so color code can be kept...

  CardInfo( {required this.color, required this.cardName, required this.cardNo, required this.dueDate, required this.amount});
}
class BillPayment {
  final String title;
  final IconData icon;

  BillPayment({
    required this.title,
    required this.icon,
  });
}