
class TransactionModel {
  final String image;
  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;
  final String date;

  TransactionModel({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
    required this.date,
  });
}