part of 'home_screen.dart';

//@formater:off
class _ActiveLoanSection extends StatelessWidget {
  final List<LoanModel> loanItems;

  const _ActiveLoanSection({required this.loanItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(children: [
            TextH2(text: "Loans", color: Colors.black,),
            Spacer(),
            Text("See all ",
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black))
          ]),
        ),
        SpacerVertical(4),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: loanItems
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key; // Index of the current item
                var e = entry.value; // The current item

                return SizedBox(
                  width: 330,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: _LoanItem(
                        data: e), // Your custom widget for each loan item
                  ),
                );
              }).toList(),
            ),
        ),
      ],
    );
  }
}

//@formatter:off
class _LoanItem extends StatelessWidget {
  final LoanModel data;
  const _LoanItem({required this.data});
  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.white;
    var statusColor=Colors.transparent;
    if(data.status==LoanStatus.due){
      statusColor=Colors.red;
    }
    if(data.status==LoanStatus.approved){
      statusColor=Colors.green;
    }
    if(data.status==LoanStatus.pending){
      statusColor=Colors.orange;
    }
    return _LoanItemLayoutStrategy(
        image: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: BoxBorder.all(color: Colors.grey),
            ),
            child: Image.network(data.imageLink, fit: BoxFit.cover,height: 40,)
        ),
        title:TextH4(text: data.name,background: bgColor),
        price:TextLabel2(text: data.price,background: bgColor),
        status:TextH4(text: data.status.label,color: statusColor),
        date:TextLabel1(text: data.date,color: Colors.black54),
    );
  }
}

//@formatter:off
class _LoanItemLayoutStrategy extends StatelessWidget {
  final Widget title, price,status, date, image;
  const _LoanItemLayoutStrategy({
    required this.title,
    required this.price,
    required this.date,
    required this.image,
    required this.status
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            image,
            HSpacer(8),
            Expanded(
              child: Column(
                children: [
                  Row(children: [title,Spacer(),status]),
                  Row(children: [price, Spacer(),date]),
                ]
              )
            ),
          ],
        ),
      ),
    );

  }
}