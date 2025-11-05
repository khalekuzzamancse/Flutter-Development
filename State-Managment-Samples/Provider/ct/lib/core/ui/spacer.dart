import 'package:flutter/widgets.dart';

class SpacerHorizontal4 extends StatelessWidget {
  const SpacerHorizontal4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(width: 4);
}

class SpacerHorizontal8 extends StatelessWidget {
  const SpacerHorizontal8({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(width: 8);
}

class SpacerHorizontal16 extends StatelessWidget {
  const SpacerHorizontal16({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(width: 16);
}

class SpacerHorizontal32 extends StatelessWidget {
  const SpacerHorizontal32({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(width: 32);
}

class SpacerHorizontal64 extends StatelessWidget {
  const SpacerHorizontal64({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(width: 64);
}

class SpacerVertical4 extends StatelessWidget {
  const SpacerVertical4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(height: 4);
}

class SpacerVertical8 extends StatelessWidget {
  const SpacerVertical8({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(height: 8);
}
class SpacerVertical extends StatelessWidget {
  final double height;
  const SpacerVertical(this.height,{Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) =>  SizedBox(height: height);
}


class SpacerVertical16 extends StatelessWidget {
  const SpacerVertical16({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(height: 16);
}

class SpacerVertical32 extends StatelessWidget {
  const SpacerVertical32({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(height: 32);
}

class SpacerVertical64 extends StatelessWidget {
  const SpacerVertical64({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(height: 64);
}
