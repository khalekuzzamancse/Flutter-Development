part of core_ui;


class NeoText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final Color color_bg;
  final double wordSpacing;
  final VoidCallback onClick;

  const NeoText({
    required this.text,
    required this.size,
    required this.fontWeight,
    required this.color,
    required this.color_bg,
    required this.wordSpacing,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFF194771),
        boxShadow: [
          BoxShadow(color: color_bg, spreadRadius: 3),
        ],
      ),
      child: onClick == null
          ? Text(
              text,
              style: TextStyle(
                fontSize: size,
                fontWeight: fontWeight,
                color: color,
                wordSpacing: wordSpacing,
              ),
            )
          : TextButton(
              onPressed: () {
                onClick.call();
              },
              child: Text(
                text,
                style: TextStyle(
                  fontSize: size,
                  fontWeight: fontWeight,
                  color: color,
                  wordSpacing: wordSpacing,
                ),
              ),
            ),
    );
  }
}
/// Cleans and formats a given string into title case.
///
/// - Removes all non-alphabetic characters except underscores (`_`) and hyphens (`-`).
/// - Replaces underscores and hyphens with spaces.
/// - Converts each word’s first letter to uppercase while keeping the rest lowercase.
///
String cleanAndCapitalizeOrOriginal (String input) {
 try{
   return input
       .replaceAll(RegExp(r'[^a-zA-Z_\-]'), '') // Remove non a-z characters except _ and -
       .replaceAll(RegExp(r'[_-]'), ' ') // Replace _ and - with space
       .split(' ') // Split into words
       .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
       .join(' '); // Join words with a space
 }
 catch(_){
   return input;
 }
}

