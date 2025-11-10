part of 'home_screen.dart';

//@formater:off
class _PayBillSection extends StatelessWidget {
  final List<BillPayment> items;

  const _PayBillSection({required this.items});

  @override
  Widget build(BuildContext context) {

    return  NestedHorizontalScroller(
        header:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextH2(text: "Pay Bill", color: Colors.white,),
        ),
        children: items.map((item) =>
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 4),
                child: _PayBillItem(label: item.title, icon: item.icon))).toList());
  }
}

//@formatter:off
class _PayBillItem extends StatelessWidget {
  final String label; final IconData icon;

  const _PayBillItem({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final bgColor = Color(0xFFF2F4F7); final shadowColor=Colors.black.withOpacity(0.1);
    final iconColor = bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return  (ColumnBuilder(arrangement: Arrangement.spaceBy(8))
        + Icon(icon, color: iconColor)
            .modifier(Modifier()
            .paddingAll(16) //To make the Box Wider
            .shadow(blurRadius: 6, backgroundColor: bgColor, shadowColor:shadowColor)
            .intrinsicHeight()) //Giving bounded constraint to avoid render issue in case of scrolling
        + Column(children: label.split(' ').map((word) =>
            Text(word, style: TextStyle(fontSize: 14,color: Colors.white), textAlign: TextAlign.center)).toList()))
        .build();

  }
}