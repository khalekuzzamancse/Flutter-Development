class Transaction {
  final String iconPath;
  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;
  final String date;

  Transaction({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
    required this.date,
  });
}