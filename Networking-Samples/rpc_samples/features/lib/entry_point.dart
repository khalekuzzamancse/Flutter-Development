import 'package:flutter/material.dart';
import 'card_payment_dialog.dart';

class FeatureModuleEntryPoint extends StatelessWidget {
  const FeatureModuleEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  showCardPayDialog(context: context, orderId: "1", amount: 10);
                },
                child: Text("Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
