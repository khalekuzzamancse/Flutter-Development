import 'package:features/_feature_core/ui.dart';
import 'package:features/core/core_ui.dart';
import 'package:features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
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
    const cornerRadius = 24.0;
    const background= Color(0xFF256C34);
    return Scaffold(
      appBar: AppBar(
        title: TextH1(text:'Wallet'),
        backgroundColor: background,
      ),
      backgroundColor: background,
      body:Column(
        children: [
        _AccountInfo(
          expiryDate: "12/24", ccv: "123",
          onDeletePressed: () {},
            onSkipPressed: () {},
           onAccountNumberChanged: (value) {},
            onPasswordChanged: (value) {}),
          SpacerVertical(32),
          Expanded(
              child: Container(
               decoration:   BoxDecoration(
                      color:Color(0xFFA5D15B),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(cornerRadius),
                        topRight: Radius.circular(cornerRadius),
                      )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SpacerVertical(32),
                      Expanded(child: Cards(cards: controller.cards)),
                    ],
                  )
              )
          )
        ],
      )
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
    const labelTextStyle = TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500);

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


        skipButton: ElevatedButtonBuilder(
            label: Text('Add',
                style: TextStyle(color: Colors.white, fontSize: 16))
                .modifier(Modifier().padding(top: 12,bottom: 12)),
            cornerRadius: 4, background: Color(0xFF5070FA)).build()
    );
  }
}


//@formatter:off
class _LayoutStrategy extends StatelessWidget {
  final Widget labelAccount,labelPassword,expireDate,ccv,fieldAccountNo,fieldPassword,skipButton;
  final Modifier? modifier;

  const _LayoutStrategy({super.key, required this.labelAccount, required this.labelPassword, required this.expireDate,
    required this.ccv, required this.fieldAccountNo, required this.fieldPassword,
    required this.skipButton, this.modifier});

  @override
  Widget build(BuildContext context) {
    return (ColumnBuilder(arrangement: Arrangement.spaceBy(8))
        + (RowBuilder()+labelAccount.modifier(Modifier().weight(1))+fieldAccountNo).build()
        + (RowBuilder()+labelPassword.modifier(Modifier().weight(1))+fieldPassword).build()
        + _CardInfoLayoutStrategy(expireDate: expireDate,ccv: ccv)
        +SpacerVertical(8)
        + skipButton.modifier(Modifier().fillMaxWidth()))
        .build().modifier(modifier??Modifier());


  }
}
//@formatter:off
class _CardInfoLayoutStrategy extends StatelessWidget {
  final Widget expireDate,ccv;

  const _CardInfoLayoutStrategy({super.key, required this.expireDate, required this.ccv,});


  @override
  Widget build(BuildContext context) =>(RowBuilder()
      + (ColumnBuilder(horizontalAlignment: CrossAxisAlignment.start)+expireDate+SpacerVertical(4)+ccv).build().modifier(Modifier().weight(1))
    ).build();
}

