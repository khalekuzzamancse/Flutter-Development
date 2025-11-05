import 'package:features/payment_controller.dart';
import 'package:features/payment_controller_impl.dart';
import 'core/ui/core_ui.dart';
import 'package:flutter/material.dart';
import '_payment_models.dart';
import 'core/language/core_language.dart';
Future<bool?> showCardPayDialog({
  required BuildContext context,
  required String orderId,orderUid,
  required double amount,
  double discount = 0.0,
  double cashback = 0.0,
  double gratuity = 0.0,
  bool printReceipt = false,
}) async {
  return await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return _Dialog(
        orderId: orderId,
        orderUid: "orderUid",
        amount: amount,
        discount: discount,
        gratuity: gratuity,
        cashback: cashback,
        printReceipt: printReceipt,
      );
    },
  );
}

class _Dialog extends StatefulWidget {
  final double amount, discount, cashback, gratuity;
  final bool printReceipt;
  final String orderId,orderUid;

  const _Dialog(
      {required this.amount,
        required this.orderId,
        required this.orderUid,
      this.discount = 0.0,
      this.cashback = 0.0,
      this.gratuity = 0.0,
      this.printReceipt = false});

  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<_Dialog>  {
  late final tag = runtimeType.toString();
  late final CardPayController controller= CardPayControllerImpl.create();
  late var state=controller.state.value;
  late final amount = widget.amount;
  var showCancel=true;

  @override
  void initState() {
    super.initState();
    controller.state.listen((state){

      Logger.keyValueOff(tag,'initState', currentMinuteSecondMillisecond(), state);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        safeSetState(() {
          this.state = state;
          Logger.keyValueOff(tag,'setState',  currentMinuteSecondMillisecond(), state);
        });
      });

    });
    if(!controller.isConnected()){
      Logger.on(tag, 'Not connected');
      //Just try to connect, listen event, once connected start the transaction
      controller.connect();
    }
    else{
      Logger.on(tag, 'Connected');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  //@formatter:off
  //the build method may be call before the init() method
  @override
  Widget build(BuildContext context) {
    final state=controller.state.value;
    Logger.keyValueOff(tag, 'build', currentMinuteSecondMillisecond(), state);
    if(state is SocketConnectStatusConnected){
      controller.startTransaction(
          amount: widget.amount,
          discount: widget.discount,
          cashback: widget.cashback,
          gratuity: widget.gratuity);
    }

    if(state is SocketConnectStatusConnecting){
      return const _ConnectingUI();
    }

    if(SocketState.isRequesting(state)){
      return   _PaymentInProgress('Requesting..',false,dismissable: true,onCancelTransactionRequest:cancelTransaction);
    }
    if(state is SocketConnectStatusTransactionInProgress){
      final message=(state).message;
        return   _PaymentInProgress(message,state.cancellable,onCancelTransactionRequest:cancelTransaction);


    }
    if(state is SocketConnectStatusError){
      final message=(state).message;
      return   _ErrorUI(message);
    }
    if(state==SocketState.transactionCancelled){
      return  const  _TransactionCancelUI();
    }
    if (state is  SocketConnectStatusTransactionSuccess) {
     // return ThankYouPage(orderId: widget.orderUid,);
    }
    //TODO: why this?
    /// If all failed, assuming it is disconnected
    if(state is SocketConnectStatusDisconnected){
      return  _ReConnectDialog(controller);
    }
    return const _WaitingDialog();

  }
  void cancelTransaction()async{
    try {
      await controller.cancelTransaction();
      showSnackBar('Cancel request sent');
    } catch (_) {
      showSnackBar('Failed to sent cancel request');
    }
  }
}

class _WaitingDialog extends StatelessWidget {
  const _WaitingDialog({super.key});

  @override
  Widget build(BuildContext context) =>const _DialogBaseStrategy(
      child: _LoadingBar(),
    );
}




class _DialogBaseStrategy extends StatelessWidget {
  final Widget child;
  const _DialogBaseStrategy({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          width: 300,
          height: 200,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }

}


class _ReConnectDialog extends StatelessWidget {
  final CardPayController repository;
  const _ReConnectDialog(this.repository);
  @override
  Widget build(BuildContext context) {
    return _DialogBaseStrategy(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Disconnected',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SpacerVertical(16),
          _Actions(
              isConnected: false,
              isDisconnected: true,
              onDisconnect: ()async{
                await repository.disconnect();
                // if(context.mounted){
                //   Navigator.of(context).pop(false);
                // }
              },
              onReconnect: (){
                repository.connect();
              })
          ,
        ],
      ) ,
    );
  }
}

class _Actions extends StatelessWidget {
  final bool isConnected,isDisconnected;
  final VoidCallback onDisconnect,onReconnect;
  const _Actions({required this.isConnected, required this.isDisconnected,
    required this.onDisconnect, required this.onReconnect});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        __Button(
          label: 'Close',
          color: Colors.amber,
          onClick:(){
            Navigator.of(context).pop(false);
          } ,
        ),
        if(isConnected)
          ...[
            const SpacerHorizontal(16),
            __Button(
              label: 'Disconnect',
              color: Colors.red,
              onClick:onDisconnect ,
            )
          ],
        if(isDisconnected)
          ...[
            const SpacerHorizontal(16),
            __Button(
              label: 'Reconnect ?',
              color: Colors.green,
              onClick:onReconnect,
            )
          ]
      ],
    );
  }
}


class _PaymentInProgress extends StatelessWidget {
  final VoidCallback onCancelTransactionRequest;
  final String state;
  final bool show,dismissable;
  const _PaymentInProgress(this.state,this.show,{this.dismissable=false,required this.onCancelTransactionRequest});
  @override
  Widget build(BuildContext context) {
    return _DialogStrategy(
      title:  state,
      action:show?__Button(
        label: 'Cancel Transaction',
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
        color: const Color(0xFFD2E544),
        onClick:onCancelTransactionRequest ,
      ):dismissable?const __CloseButton():null,
    );
  }
}
class _TransactionCancelUI extends StatelessWidget {
  const _TransactionCancelUI();
  @override
  Widget build(BuildContext context) {
    return const _DialogStrategy(
      title:'Transaction Cancelled',
      action: __CloseButton(),
      headerUI:_CrossSymbol() ,
    );
  }
}
class _ConnectingUI extends StatelessWidget {
  const _ConnectingUI();
  @override
  Widget build(BuildContext context) {
    return const _DialogStrategy(
      title:  'Trying to Connect',
      action:__CloseButton() ,
    );
  }
}


class _ErrorUI extends StatelessWidget {
  final String error;
  const _ErrorUI(this.error);
  @override
  Widget build(BuildContext context) {
    return  _DialogStrategy(
      headerUI: const _CrossSymbol(),
      title:  error,
      action:const __CloseButton() ,
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar({super.key});

  @override
  Widget build(BuildContext context)=>const LoadingUI(size: 40,color:  Color(0xFF009B49));
}

class _DialogStrategy extends StatelessWidget {
  final String title;
  final Widget headerUI;
  final Widget? action;
   const _DialogStrategy({required this.title,  this.action,  this.headerUI=const _LoadingBar()});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          width: 300,
          height: 200,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                headerUI,
                const SpacerVertical(8),
                 Text(
                  title,
                   textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
                ,
                const SpacerVertical(24),
                if(action!=null)
                action!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class __CloseButton extends StatelessWidget {
  const __CloseButton();

  @override
  Widget build(BuildContext context) {
    return __Button(
      label: 'Close',
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      color: const Color(0xFFD2E544),
      onClick:(){
        Navigator.of(context).pop(false);
      } ,
    );
  }
}

class _CrossSymbol extends StatelessWidget {
  const _CrossSymbol();
  @override
  Widget build(BuildContext context) {
       return const ImageButton(
      size: 35,
      color: Color(0xFFBE3F45),
      iconPath: 'cancel_cross_icon',

    );
  }
}
class __Button extends StatelessWidget {
  final Color color;
  final VoidCallback onClick;
  final EdgeInsets padding;
  final String label;
  const __Button({required this.color, required this.onClick, required this.label,  this.padding=const EdgeInsets.all(8)});

  @override
  Widget build(BuildContext context) {
    return    InkWell(
        onTap: onClick,
        child: Container(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey), // border color
              borderRadius: BorderRadius.circular(8), // rounded corners
            ),
            padding: padding,
            child:  Text(label,
                style: TextStyle(color: color.contentColor))
        )
    );
  }
}

