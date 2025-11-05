part of 'core_feature.dart';

class TextDescription extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const TextDescription({
    super.key,
    required this.text,
    this.textAlign = TextAlign.justify,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}

// -------------------- Headings --------------------
class TextHeading1 extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const TextHeading1({Key? key, required this.text, this.textAlign = TextAlign.start}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class TextHeading2 extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const TextHeading2({Key? key, required this.text, this.textAlign = TextAlign.start}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class TextHeading3 extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const TextHeading3({Key? key, required this.text, this.textAlign = TextAlign.start}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

// -------------------- TextPoint --------------------
class TextPoint extends StatelessWidget {
  final String text;

  const TextPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double bulletSize = 8;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: bulletSize,
          height: bulletSize,
          margin: const EdgeInsets.only(top: 6), // vertical alignment
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              height: 1.25, // lineHeight equivalent
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
      ],
    );
  }
}

// -------------------- ButtonView --------------------
class ButtonView extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onClick;

  const ButtonView({
    Key? key,
    required this.label,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- BackIcon --------------------
class BackIcon extends StatelessWidget {
  final VoidCallback onClick;

  const BackIcon({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClick,
      icon: const Icon(Icons.arrow_back), // Flutter doesn't have AutoMirrored
    );
  }
}



class CustomButtonView extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onClick;

  const CustomButtonView({
    required this.label,
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Material(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


