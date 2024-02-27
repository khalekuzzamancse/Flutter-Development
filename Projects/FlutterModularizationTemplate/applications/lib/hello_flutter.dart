import 'package:flutter/material.dart';


class MyModules extends StatelessWidget {
  const MyModules({super.key});

@override
Widget build(BuildContext context) {
  return const MaterialApp(
    home: MyHomePage(),
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
          'Hello World',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}