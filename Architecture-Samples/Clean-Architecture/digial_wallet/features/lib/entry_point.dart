import 'package:features/search/presenation/search_screen.dart';
import 'package:features/wallet/presentation/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'home/presentation/home_screen.dart';
import 'navigation/navigation.dart';
class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return RootNavigation();
   return MaterialApp(home:
   WalletScreen(),
       debugShowCheckedModeBanner: false
   );
  }
}



