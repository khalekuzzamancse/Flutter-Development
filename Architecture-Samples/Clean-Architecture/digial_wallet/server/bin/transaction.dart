import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'core.dart';

class TransactionController {
  // Directly returns a list of transactions as JSON
  Future<Response> getTransactions(Request request) async {
    final transactionsJson = [
      {
        "image": "assets/citi.png",
        "title": "Money transfer",
        "subtitle": "Bank transfer",
        "amount": "-10,480.00",
        "date": "3:00 PM"
      },
      {
        "image": "assets/bank_of_america.png",
        "title": "Cash withdrawal",
        "subtitle": "Cash",
        "amount": "-201.50",
        "date": "2:15 AM"
      },
      {
        "image": "assets/amazon.png",
        "title": "Amazon.com",
        "subtitle": "Online payment",
        "amount": "-184.00",
        "date": "5:40 PM"
      },
      {
        "image": "assets/iofinance.png",
        "title": "IOfinance UI kit",
        "subtitle": "Online payment",
        "amount": "-28.00",
        "date": "4:20 AM"
      },
      {
        "image": "assets/socgen.png",
        "title": "Income payment",
        "subtitle": "Bank transfer",
        "amount": "+3,000.00",
        "date": "6:20 PM"
      },
      {
        "image": "assets/airbnb.png",
        "title": "Monthly home rent",
        "subtitle": "Bank transfer",
        "amount": "-400.00",
        "date": "1:00 AM"
      }
    ];
    await delay(3000);
    return Response.ok(jsonEncode(transactionsJson), headers: {'Content-Type': 'application/json'});
  }
}
