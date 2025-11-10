
import 'package:features/home/domain/models.dart';
import 'package:flutter/material.dart';

class HomeController {
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

  // List of bill payment items
  final List<BillPayment> billPayments = [
    BillPayment(title: 'Electricity Bill', icon: Icons.lightbulb_outline),
    BillPayment(title: 'Internet Recharge', icon: Icons.wifi_outlined),
    BillPayment(title: 'Cable Bill', icon: Icons.tv_outlined),
    BillPayment(title: 'Mobile Recharge', icon: Icons.smartphone_outlined),
  ];

  final activeLoanItems = [
    LoanModel(
      name: "Car EMI",
      imageLink:
      "https://img.freepik.com/premium-vector/red-city-car-vector-illustration_648968-44.jpg?w=740",
      price: "\$399",
      date: "15 Sept 2025",
      status: LoanStatus.due
    ),
    LoanModel(
      name: "Smart Phone EMI",
      imageLink:
      "https://auspost.com.au/shop/static/WFS/AusPost-Shop-Site/-/AusPost-Shop-auspost-B2CWebShop/en_AU/feat-cat/mobile-phones/category-carousel/MP_UnlockedPhones_3.jpg",
      price: "\$299",
      date: "20 OCT 2015",
      status: LoanStatus.pending
    ),
    LoanModel(
        name: "Home Loan",
        imageLink:
        "https://auspost.com.au/shop/static/WFS/AusPost-Shop-Site/-/AusPost-Shop-auspost-B2CWebShop/en_AU/feat-cat/mobile-phones/category-carousel/MP_UnlockedPhones_3.jpg",
        price: "\$299",
        date: "20 OCT 2015",
        status: LoanStatus.approved
    ),
    LoanModel(
        name: "Home Loan",
        imageLink:
        "https://auspost.com.au/shop/static/WFS/AusPost-Shop-Site/-/AusPost-Shop-auspost-B2CWebShop/en_AU/feat-cat/mobile-phones/category-carousel/MP_UnlockedPhones_3.jpg",
        price: "\$299",
        date: "20 OCT 2015",
        status: LoanStatus.approved
    ),
    LoanModel(
        name: "Home Loan",
        imageLink:
        "https://auspost.com.au/shop/static/WFS/AusPost-Shop-Site/-/AusPost-Shop-auspost-B2CWebShop/en_AU/feat-cat/mobile-phones/category-carousel/MP_UnlockedPhones_3.jpg",
        price: "\$299",
        date: "20 OCT 2015",
        status: LoanStatus.approved
    ),
  ];
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