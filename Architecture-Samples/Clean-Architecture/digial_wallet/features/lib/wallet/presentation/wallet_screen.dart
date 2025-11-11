import 'package:features/_feature_core/ui.dart';
import 'package:features/core/core_ui.dart';
import 'package:features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import '../domain/model/break_down_model.dart';
import 'factory.dart';

//@formatter:off
class WalletScreen extends StatelessWidget {
  final controller=PresentationFactory.createController();
  WalletScreen(){
    //TODO:Not good idea to fetch source within UI, refactor later
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
          +Cards(cards: controller.cards,)
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
        +SpacerVertical(8)
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
      + (ColumnBuilder(horizontalAlignment: CrossAxisAlignment.start)+expireDate+SpacerVertical(4)+ccv).build().modifier(Modifier().weight(1))
      + deleteButton.modifier(Modifier().align(Alignment.centerRight))).build();
}

