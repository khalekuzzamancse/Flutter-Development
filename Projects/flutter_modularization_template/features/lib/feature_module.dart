import 'package:flutter/material.dart';

class FeaturesModule extends StatelessWidget {
  const FeaturesModule({super.key});

@override
Widget build(BuildContext context) {
  return  MaterialApp(
    theme: ThemeData(
      useMaterial3: true
    ),
    home: const MyHomePage(),
  );
}
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello , I am From Feature Module',
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}