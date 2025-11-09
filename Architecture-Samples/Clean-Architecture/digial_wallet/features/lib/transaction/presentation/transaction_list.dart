import 'package:features/transaction/domain/transaction_repository.dart';
import 'package:flutter/material.dart';


class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Transaction>> groupedTransactions = {
      '28 August': [
        Transaction(
          iconPath: 'assets/citi.png',
          title: 'Money transfer',
          subtitle: 'Bank transfer',
          amount: '- €10,480.00',
          isPositive: false,
          date: '3:00 PM',
        ),
        Transaction(
          iconPath: 'assets/bank_of_america.png',
          title: 'Cash withdrawal',
          subtitle: 'Cash',
          amount: '- €201.50',
          isPositive: false,
          date: '2:15 AM',
        ),
        Transaction(
          iconPath: 'assets/amazon.png',
          title: 'Amazon.com',
          subtitle: 'Online payment',
          amount: '- €184.00',
          isPositive: false,
          date: '5:40 PM',
        ),
        Transaction(
          iconPath: 'assets/iofinance.png',
          title: 'IOfinance UI kit',
          subtitle: 'Online payment',
          amount: '- €28.00',
          isPositive: false,
          date: '4:20 AM',
        ),
      ],
      '24 August': [
        Transaction(
          iconPath: 'assets/socgen.png',
          title: 'Income payment',
          subtitle: 'Bank transfer',
          amount: '+ €3,000.00',
          isPositive: true,
          date: '6:20 PM',
        ),
        Transaction(
          iconPath: 'assets/airbnb.png',
          title: 'Monthly home rent',
          subtitle: 'Bank transfer',
          amount: '- €400.00',
          isPositive: false,
          date: '1:00 AM',
        ),
      ]
    };

    return ListView(
      children: groupedTransactions.entries.map((entry) {
        return TransactionGroup(
          date: entry.key,
          transactions: entry.value,
        );
      }).toList(),
    );
  }
}

// ------------------------------------------------------------
// SMALL WIDGETS
// ------------------------------------------------------------

// Search bar
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Type to search',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// Transaction group (date + items)
class TransactionGroup extends StatelessWidget {
  final String date;
  final List<Transaction> transactions;

  const TransactionGroup({
    super.key,
    required this.date,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: transactions
              .map((tx) => TransactionTile(transaction: tx))
              .toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

// Single transaction card
class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon
            // Container(
            //   height: 44,
            //   width: 44,
            //   decoration: BoxDecoration(
            //     color: const Color(0xFFF2F3F5),
            //     borderRadius: BorderRadius.circular(50),
            //   ),
            //   child: Center(
            //     child: Image.asset(
            //       transaction.iconPath,
            //       height: 24,
            //       width: 24,
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    transaction.subtitle,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    transaction.date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              transaction.amount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction.isPositive
                    ? Colors.green[700]
                    : Colors.red[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
