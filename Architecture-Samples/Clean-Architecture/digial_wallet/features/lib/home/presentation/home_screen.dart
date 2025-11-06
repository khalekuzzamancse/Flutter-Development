import 'package:features/core/core_ui.dart';
import 'package:flutter/material.dart';

import '../domain/models.dart';

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
      model: "Model X",
      imageLink:
      "https://img.freepik.com/premium-vector/red-city-car-vector-illustration_648968-44.jpg?w=740",
      price: "\$399/M",
      date: "5th OCT",
      rating: 48,
      ratingMax: 60,
    ),
    LoanModel(
      model: "Nokia Y",
      imageLink:
      "https://auspost.com.au/shop/static/WFS/AusPost-Shop-Site/-/AusPost-Shop-auspost-B2CWebShop/en_AU/feat-cat/mobile-phones/category-carousel/MP_UnlockedPhones_3.jpg",
      price: "\$299/M",
      date: "20 OCT",
      rating: 36,
      ratingMax: 50,
    ),
  ];
}

//@formatter:off
class HomeScreen extends StatelessWidget {
  final HomeController controller = HomeController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('✌️ Hey ${controller.user}!', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.notifications_none_outlined).modifier(Modifier().paddingAll(8)),
            onPressed: () {},
          ),
        ],
      ),
      body:
      (ColumnBuilder(
          arrangement: Arrangement.spaceBy(16),
          modifier:Modifier().paddingAll(12).verticalScrollable())
          + _Cards(cards: controller.cards)
          + _PayBillSection(items: controller.billPayments)
          + _ActiveLoanSection(loanItems: controller.activeLoanItems)
      ).build(),
    );
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
//@formatter:off
class _Cards extends StatelessWidget {
  final List<CardInfo> cards;
  const _Cards({required this.cards});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NestedHorizontalScroller(
            showIndicator: true,
            children:cards.map((item) =>
                Padding(padding: const EdgeInsets.all(8.0), child: _Card(cardInfo: item))).toList()),
      ],
    );
  }
}


//@formatter:off
class _Card extends StatelessWidget {
  final CardInfo cardInfo; final Color buttonColor=Colors.white;
  _Card({required this.cardInfo});

  @override
  Widget build(BuildContext context) {
    final textColor = cardInfo.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final  Color buttonTextColor = buttonColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final labelSmall = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: textColor);
    final labelMedium = TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.w500);
    final shadowColor=Colors.black.withOpacity(0.1); // spreadRadius: 1
    final bgColor=cardInfo.color;

    return   _CardLayoutStrategy(
        modifier: Modifier()
            .shadow(
            maxWidth:300,blurRadius: 5,radius: 12,offset: Offset(0, 4),
            backgroundColor: bgColor, shadowColor:shadowColor,padding: 16),

        cardName: Text(cardInfo.cardName, style: labelMedium.copyWith(fontStyle: FontStyle.italic)),
        cardNo: Text(cardInfo.cardNo, style: labelMedium),

        dueDate: (RowBuilder(arrangement: Arrangement.spaceBy(8))
            + Text('Due date', style: labelSmall.copyWith(fontWeight: FontWeight.w300))
            + Text(cardInfo.dueDate, style: labelSmall))
            .build(),

        labelEarly: Text('EARLY', style: labelSmall),
        amount: Text(cardInfo.amount, style: labelMedium.copyWith(fontSize: 20)),

        action: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text("PAY", style: TextStyle(color: buttonTextColor)),
        ))
    ;

  }
}


class _CardLayoutStrategy extends StatelessWidget {
  final Widget cardName,dueDate,amount,action,cardNo,labelEarly;
  final Modifier? modifier;
  const _CardLayoutStrategy({ required this.dueDate,
    required this.action, required this.cardName, required this.amount, required this.cardNo, required this.labelEarly, this.modifier});
  @override
  Widget build(BuildContext context) {
    return   (ColumnBuilder(arrangement: Arrangement.spaceBy(8))
        + (RowBuilder()+cardName.modifier(Modifier().weight(1))+cardNo).build()
        + VSpacer(24)
        + (RowBuilder()+dueDate.modifier(Modifier().align(Alignment.centerLeft).weight(1))+labelEarly).build()
        + (RowBuilder()+amount.modifier(Modifier().weight(1))+action).build())
        .build()
        .modifier(modifier??Modifier());

  }
}

class BillPayment {
  final String title;
  final IconData icon;

  BillPayment({
    required this.title,
    required this.icon,
  });
}
/**
 *-  This has nested scrollable behaviour, use it carefully with the consumer widget
 */
//@formater:off
class _PayBillSection extends StatelessWidget {
  final List<BillPayment> items;

  const _PayBillSection({required this.items});

  @override
  Widget build(BuildContext context) {

    return  NestedHorizontalScroller(
        header:  Text("Bill Payments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            Text(word, style: TextStyle(fontSize: 14), textAlign: TextAlign.center)).toList()))
        .build();

  }
}

/**
 *-  This has nested scrollable behaviour, use it carefully with the consumer widget
 */
//@formater:off
class _ActiveLoanSection extends StatelessWidget {
  final List<LoanModel> loanItems;

  const _ActiveLoanSection({required this.loanItems});

  @override
  Widget build(BuildContext context) {

    return
      NestedHorizontalScroller(
        height: 300,
        header:  Row(children: [
          Text("Active Loans", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Spacer(),
          Text("See all ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))]),

        children: loanItems.map((item)=>
            _LoanItem(data: LoanModel(model: item.model, imageLink:item.imageLink,
                price:item.price, date: item.date,
                rating: item.rating, ratingMax: item.ratingMax))).toList(),

      );


  }
}





//@formatter:off
class _LoanItem extends StatelessWidget {
  final LoanModel data;

  const _LoanItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final bgColor = Color(0xFFECEFF1);
    final textColor = ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark ? Colors.white : Colors.black;
    final labelMedium = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor);
    final shadowColor= Colors.black.withOpacity(0.1);
    final progressColor = Colors.blueAccent;

    return _LoanItemLayoutStrategy(
        modifier: Modifier()
            .shadow(maxWidth: 280, blurRadius: 6, backgroundColor: bgColor, shadowColor:shadowColor)
            .padding(left: 8,right: 8),

        image: Container(width: 50, height: 50, color: Colors.white, alignment: Alignment.center,
            child: AsyncImage().link(data.imageLink).build().modifier(Modifier().height(40))),

        price: Text(data.price, style: labelMedium),

        model: Text(data.model, style: labelMedium.copyWith(fontWeight: FontWeight.w400)),

        date:(ColumnBuilder(horizontalAlignment: CrossAxisAlignment.start,arrangement: Arrangement.spaceBy(8))
            + Text('Next', style: labelMedium.copyWith(fontWeight: FontWeight.w400, fontSize: 18))
            + Text(data.date, style: labelMedium))
            .build(),

        rating: (RowBuilder()
            + Text(data.rating.toString(), style: labelMedium.copyWith(color: progressColor))
            + Text("/${data.ratingMax}", style: labelMedium))
            .build(),

        ratingBar: LinearProgressIndicator(
            value: data.rating / data.ratingMax,
            color: progressColor, backgroundColor: Colors.grey.shade300));
  }
}


/**
 * # Caution
 * - It uses that widget such as `Spacer` or `Modifier.weight()` or `Expanded` ,these widget  constraints are unbounded
 * that means they will take any available space, so if we are using this inside a horizontal scrollable widget that
 * these widget will not able to determine their size in that case it will cause Render issue
 * - If the consumer passes some widget that constraints are unbounded such as a `LinearProgressBar` or any other widget
 * in that case it will also cases the Render issue
 * - That is why the `Consumer` widget should provide a bounder constraints to this entire widget either a fix width or define max width
 * - So be careful when using it with horizontal scrollable widget
 *
 */
//@formatter:off
class _LoanItemLayoutStrategy extends StatelessWidget {
  final Widget price, model, date, rating, image, ratingBar;
  final Modifier? _modifier;

  const _LoanItemLayoutStrategy({ Modifier? modifier, required this.price, required this.model, required this.date,
    required this.rating, required this.image, required this.ratingBar}):_modifier=modifier;

  @override
  Widget build(BuildContext context) {

    return  (RowBuilder()
        + image
        + HSpacer(8)
        + Expanded(child:
        (ColumnBuilder(arrangement: Arrangement.spaceBy(8))
            + Row(children: [price,Spacer(),date])
            + Row(children: [model, Spacer(), rating])
            + ratingBar).build()))
        .build()
        .modifier(_modifier??Modifier());

  }
}



