import 'package:ComposableWidget/composable_widget.dart';
import 'package:core_ui/core_ui_api.dart';
import 'package:flutter/material.dart';
import 'package:wallet_domain/domain_api.dart';
import '../presentation_logic/factory/factory.dart';

//@formatter:off
class WalletScreen extends StatelessWidget {
  final controller=PresentationFactory.createController();
  WalletScreen(){
    //TODO:Not good idea to fetch data within UI, refactor later
    controller.read();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        leading:IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}) ,
        title: Text('Wallet',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
        actions:  [IconButton(icon: Icon(Icons.account_circle), onPressed: () {}).modifier(Modifier().padding(right: 16))],
      ),
      body:(ColumnBuilder(arrangement: Arrangement.spaceBy(8),modifier: Modifier().verticalScrollable())
          + StreamBuilderStrategyWithSnackBar<SpendData?>(
              messageStream: controller.statusMessage,
              dataStream: controller.spendData,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null) return EmptyContentScreen();
                return   _Bars(period:data.period, typeOfCost: 'Spend Chart',
                    costs:data.spend.data.firstOrNull?.toCost()??[], currencyType:data.currency);
              })
          + StreamBuilderStrategyWithSnackBar<List<BreakdownItemData>>(
              messageStream: controller.statusMessage,
              dataStream: controller.breakdowns,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null) return EmptyContentScreen();
                return   _BreakDown(itemData:data);})
          + (ColumnBuilder(modifier:Modifier().linearGradient([Color(0xFFF8F8F8), Color(0xFFFFFFFF)]))
              + Card(color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),elevation: 1,
                  child: _AccountInfo(expiryDate: "12/24", ccv: "123",
                    onDeletePressed: () {}, onSkipPressed: () {}, onAccountNumberChanged: (value) {}, onPasswordChanged: (value) {},
                  ).modifier(Modifier().paddingAll(32)))).build())
          .build(),
    );
  }
}

//@formatter:off
class _Bars extends StatelessWidget {
  final String period,typeOfCost, currencyType; final List<double> costs;

  _Bars({required this.period, required this.typeOfCost, required this.costs, this.currencyType = '\$',});

  @override
  Widget build(BuildContext context) {
    final maxCost = costs.reduce((a, b) => a > b ? a : b);

    return  NestedHorizontalScroller(
        header: (ColumnBuilder()
            + Text('$period',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14,color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)))
            + Text('$typeOfCost',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9)),))
            .build(),
        childVerticalAlignment: CrossAxisAlignment.end,
        children:  costs.map((cost) {
          return _Bar(cost: cost, maxCost: maxCost, barColor: const Color(0xFF7F00FF), currencySymbol: currencyType)
              .modifier(Modifier().padding(left:4,right: 4));}).toList());

  }
}

//@formatter:off
class _Bar extends StatelessWidget {
  final double cost, maxCost;final Color barColor;final String currencySymbol;


  _Bar({required this.cost, required this.maxCost, this.barColor = const Color(0xFF7F00FF), this.currencySymbol = '\$'});

  @override
  Widget build(BuildContext context) {
    // Scale the height based on maxCost to fit within a fixed height (e.g., 200 pixels)
    final double barHeight = (150 * cost) / maxCost;

    return (ColumnBuilder(arrangement: Arrangement.spaceBy(8),modifier: Modifier().wrapContentWidth())
        + SizedBox(height: barHeight,width: double.infinity)//fillMaxWidth
            .modifier(Modifier()
            .shadow(backgroundColor: barColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),topRight: Radius.circular(8.0))))
        +  Text('$currencySymbol${cost.toStringAsFixed(2)}', style: TextStyle(fontSize: 12), textAlign: TextAlign.start)
            .modifier(Modifier().padding(right: 8)))//Increase the bar trailing width
        .build();

  }
}

/**
 *-  This has nested scrollable behaviour, use it carefully with the consumer widget
 */
//@formater:off
class _BreakDown extends StatelessWidget {
  final List<BreakdownItemData> itemData;

  const _BreakDown({required this.itemData});

  List<_BreakdownItem> get sortedItems {
    final items = itemData.map((data) {
      return _BreakdownItem(
          percentage: data.percentage, label: data.label,position: 0);// temporary placeholder for position, will be updated after sorting
    }).toList();

    items.sort((a, b) {
      final aPercentage = double.tryParse(a.percentage.replaceAll('%', '')) ?? 0.0;
      final bPercentage = double.tryParse(b.percentage.replaceAll('%', '')) ?? 0.0;
      return bPercentage.compareTo(aPercentage);
    });

    return items.asMap().entries.map((entry) {
      final index = entry.key; final item = entry.value;
      return _BreakdownItem(percentage: item.percentage, label: item.label, position: index);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return NestedHorizontalScroller(
        header:Text("Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)) ,
        children: sortedItems.map((item) =>
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),child: item)).toList());
  }
}

//@formater:off
class _BreakdownItem extends StatelessWidget {
  final String percentage, label;final Color circleColor, percentageTextColor, labelColor;
  final double labelOpacity;final int position;

  const _BreakdownItem({required this.percentage, required this.label, this.circleColor = Colors.white, this.percentageTextColor = Colors.red,
    this.labelColor = Colors.grey, this.labelOpacity = 0.6, required this.position});

  @override
  Widget build(BuildContext context) {
    return (ColumnBuilder(arrangement: Arrangement.spaceBy(8))
        + Text(
            percentage,
            style: TextStyle(color: percentageTextColor.withOpacity(_calculateOpacity()), fontSize: 18, fontWeight: FontWeight.w500))
            .modifier(Modifier()
            .paddingAll(8)
            .shadowShaped(offset: Offset(0, 1),blurRadius: 8,backgroundColor: Colors.white,shadowColor:Colors.black.withOpacity(0.1))
            .intrinsicHeight())
        + Text(label, style: TextStyle(color: labelColor.withOpacity(labelOpacity), fontSize: 14)))
        .build();
  }

  double _calculateOpacity() {
    final baseOpacity = 1.0;final decrement = 0.1;
    return (baseOpacity - (position * decrement)).clamp(0.1, 1.0);
  }
}


//@formater:off
class _AccountInfo extends StatelessWidget {
  final String expiryDate; final String ccv; final VoidCallback onDeletePressed;
  final VoidCallback onSkipPressed; final ValueChanged<String> onAccountNumberChanged; final ValueChanged<String> onPasswordChanged;

  const _AccountInfo({super.key, required this.expiryDate, required this.ccv,
    required this.onDeletePressed, required this.onSkipPressed, required this.onAccountNumberChanged, required this.onPasswordChanged});

  @override
  Widget build(BuildContext context) {
    const labelTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

    return _LayoutStrategy(
        modifier: Modifier().widthIn(maxWidth: 400),
        labelAccount: Text('Account Number:', style: labelTextStyle),
        labelPassword: Text('Password:', style: labelTextStyle),
        expireDate: Text('Expire Date: $expiryDate', style: labelTextStyle),
        ccv: Text('CCV: $ccv', style: labelTextStyle),

        fieldAccountNo: TextFieldBuilder(
            modifier: Modifier().width(200),
            textStyle: labelTextStyle,
            controller: TextEditingController(),
            visualTransformer: VisualTransformer.accountNumber,
            onChanged: onAccountNumberChanged),

        fieldPassword: TextFieldBuilder(
            modifier: Modifier().width(200),
            obscureText: true,
            textStyle: labelTextStyle,
            onChanged: onPasswordChanged),

        deleteButton: ElevatedButtonBuilder(
            label: Text('Delete Card', style: TextStyle(color: Colors.white, fontSize: 14))
                .modifier(Modifier().padding(left: 8,right: 8)),
            cornerRadius: 8, background: Color(0xFF7F00FF)).build(),


        skipButton: ElevatedButtonBuilder(
            label: Text('Skip'.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16)).modifier(Modifier().padding(top: 12,bottom: 12)),
            cornerRadius: 4, background: Color(0xFF5070FA)).build()
    );
  }
}


//@formatter:off
class _LayoutStrategy extends StatelessWidget {
  final Widget labelAccount,labelPassword,expireDate,ccv,fieldAccountNo,fieldPassword,deleteButton,skipButton;
  final Modifier? modifier;

  const _LayoutStrategy({super.key, required this.labelAccount, required this.labelPassword, required this.expireDate,
    required this.ccv, required this.fieldAccountNo, required this.fieldPassword,
    required this.deleteButton, required this.skipButton, this.modifier});

  @override
  Widget build(BuildContext context) {
    return (ColumnBuilder(arrangement: Arrangement.spaceBy(8))
        + (RowBuilder()+labelAccount.modifier(Modifier().weight(1))+fieldAccountNo).build()
        + (RowBuilder()+labelPassword.modifier(Modifier().weight(1))+fieldPassword).build()
        + _CardInfoLayoutStrategy(expireDate: expireDate,ccv: ccv,deleteButton: deleteButton)
        +VSpacer(8)
        + skipButton.modifier(Modifier().fillMaxWidth()))
        .build().modifier(modifier??Modifier());


  }
}
//@formatter:off
class _CardInfoLayoutStrategy extends StatelessWidget {
  final Widget expireDate,ccv,deleteButton;

  const _CardInfoLayoutStrategy({super.key, required this.expireDate, required this.ccv, required this.deleteButton});


  @override
  Widget build(BuildContext context) =>(RowBuilder()
      + (ColumnBuilder(horizontalAlignment: CrossAxisAlignment.start)+expireDate+VSpacer(4)+ccv).build().modifier(Modifier().weight(1))
      + deleteButton.modifier(Modifier().align(Alignment.centerRight))).build();
}

