part of 'home_screen.dart';

class _RecentTransaction extends StatelessWidget {
  final List<TransactionModel> items;

  const _RecentTransaction({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const cornerRadius = 24.0;
    const background=Color(0xFFEEC626);
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
        child: Column(
          children: [
            Row(children: [
              TextH2(
                text: "Recent Transaction",
                color: Colors.black,
              ),
              Spacer(),
              Text("See all ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              )
            ]),
            SpacerVertical(16),
            Expanded(
              child: RecentTransaction(transactions: items,),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentTransaction extends StatelessWidget {
  final List<TransactionModel> transactions;
  const RecentTransaction({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: transactions.length>0?2 * (transactions.length) - 1:0,
        itemBuilder: (context, index) {
          final even = index % 2 == 0;
          if (even) {
            return TransactionTile(
                transaction: transactions[(index / 2).toInt()]);
          } else {
            return Divider(
              height: 0,
            );
          }
        });
  }
}

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<TransactionModel>> groupedTransactions = {
      '28 August': [
        TransactionModel(
          image: 'assets/citi.png',
          title: 'Money transfer',
          subtitle: 'Bank transfer',
          amount: '- €10,480.00',
          isPositive: false,
          date: '3:00 PM',
        ),
        TransactionModel(
          image: 'assets/bank_of_america.png',
          title: 'Cash withdrawal',
          subtitle: 'Cash',
          amount: '- €201.50',
          isPositive: false,
          date: '2:15 AM',
        ),
        TransactionModel(
          image: 'assets/amazon.png',
          title: 'Amazon.com',
          subtitle: 'Online payment',
          amount: '- €184.00',
          isPositive: false,
          date: '5:40 PM',
        ),
        TransactionModel(
          image: 'assets/iofinance.png',
          title: 'IOfinance UI kit',
          subtitle: 'Online payment',
          amount: '- €28.00',
          isPositive: false,
          date: '4:20 AM',
        ),
      ],
      '24 August': [
        TransactionModel(
          image: 'assets/socgen.png',
          title: 'Income payment',
          subtitle: 'Bank transfer',
          amount: '+ €3,000.00',
          isPositive: true,
          date: '6:20 PM',
        ),
        TransactionModel(
          image: 'assets/airbnb.png',
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

// Transaction group (date + items)
class TransactionGroup extends StatelessWidget {
  final String date;
  final List<TransactionModel> transactions;

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
              .map((tx) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TransactionTile(transaction: tx),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

// Single transaction card
class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
