import 'package:flutter/material.dart';
import './database.dart';
//TODO: Maintain singleton instead
var database= MyDatabase();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    database.init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionButton(
              text: 'Insert',
              onPressed: () async {
                final result = await database.insert('Mr. Bean', '147507',);
                print('Insert successful: $result');
              },
            ),
            ActionButton(
              text: 'Update',
              onPressed: () async {
                final result = await database.update('Mr. Bean X', '147507',);
                print('Update successful: $result');
              },
            ),
            ActionButton(
              text: 'Read',
              onPressed: () async {
                final result = await database.readByRoll("147507");
                print('Read result: $result');
              },
            ),
            ActionButton(
              text: 'Read All',
              onPressed: () async {
                final result = await database.readAll();

                print('Read-all result: $result');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: 160,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}