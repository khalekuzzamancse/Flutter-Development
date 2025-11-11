import 'package:features/_feature_core/ui.dart';
import 'package:features/core/core_ui.dart';
import 'package:features/transaction/domain/transaction_repository.dart';
import 'package:flutter/material.dart';

import '../../transaction/presentation/transaction_list.dart';
import '../domain/models.dart';
import 'home_controller.dart';

part '_loans.dart';

part '_transactions.dart';

part '_paybill.dart';

//@formatter:off
class HomeScreen extends StatelessWidget {
  final HomeController controller = HomeController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg=Color(0xFF2F7167);
    const cornerRadius = 24.0;
    const background=Color(0xFFEEC626);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:bg, title: TextH1(text: 'Welcome, ${controller.user}'),
      ),
      backgroundColor: bg,
      body: Column(
        children: [
          _PayBillSection(items: controller.billPayments),
          SpacerVertical(16),
       Expanded(
         child: Container(
             decoration: BoxDecoration(
               color:background,
               borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(cornerRadius),
                 topRight: Radius.circular(cornerRadius),
               )
             ),
           child: Column(
             children: [
               SpacerVertical(32),
           _ActiveLoanSection(loanItems: controller.activeLoanItems),
               Expanded(child: _RecentTransaction(loanItems: controller.activeLoanItems)),
             ],
           ),
         ),
       )


        ],
      )
    );
  }
}



//@formatter:off
class Cards extends StatelessWidget {
  final List<CardInfo> cards;
  const Cards({required this.cards});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: cards.length,
        itemBuilder: (context,index){
          return Padding(padding: const EdgeInsets.all(8.0),
              child: _Card(cardInfo: cards[index]));
        }
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
        amount: Text(cardInfo.amount, style: labelMedium.copyWith(fontSize: 20)),
    )
    ;

  }
}


class _CardLayoutStrategy extends StatelessWidget {
  final Widget cardName,dueDate,amount,cardNo;
  final Modifier? modifier;
  const _CardLayoutStrategy({ required this.dueDate,
     required this.cardName, required this.amount, required this.cardNo, this.modifier});
  @override
  Widget build(BuildContext context) {
    return   (ColumnBuilder(arrangement: Arrangement.spaceBy(8))
        + (RowBuilder()+cardName.modifier(Modifier().weight(1))+cardNo).build()
        + SpacerVertical(24)
        + (RowBuilder()+dueDate.modifier(Modifier().align(Alignment.centerLeft).weight(1))).build()
        + (RowBuilder()+amount.modifier(Modifier().weight(1))).build())
        .build()
        .modifier(modifier??Modifier());

  }
}



