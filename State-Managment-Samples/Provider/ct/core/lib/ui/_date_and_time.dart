part of core_ui;

class TimerWidget extends StatefulWidget {
  final int updateDuration;
  final bool showSeconds;
  final Color clockColor;
  final double textSize;

  const TimerWidget({
    Key? key,
    required this.updateDuration,
    this.showSeconds = false,
    this.clockColor = Colors.black, // Default clock color
    this.textSize = 18.0, // Default text size
  }) : super(key: key);

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  late String _formattedDateTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(
        Duration(seconds: widget.updateDuration),
            (Timer t) => _updateTime()
    );
  }

  void _updateTime() {
    setState(() {
      _formattedDateTime = getCurrentFormattedDateTime(widget.showSeconds);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formattedDateTime,
      style: TextStyle(
        fontSize: widget.textSize,
        color: widget.clockColor,
      ),
    );
  }
}


String getCurrentFormattedDateTime(bool showSeconds) {
  DateTime now = DateTime.now();

  int hour = now.hour;
  String period = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  hour = hour == 0 ? 12 : hour; // Adjust for 12-hour format

  int minute = now.minute;
  int second = now.second;

  int month = now.month;
  int day = now.day;
  int year = now.year;

  if (showSeconds) {
    return '$hour:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')} $period, $month/$day/$year';
  } else {
    return '$hour:${minute.toString().padLeft(2, '0')} $period, $month/$day/$year';
  }
}

class RangeDatePicker extends StatefulWidget {
  final  Function(Pair<DateTime,DateTime>) onPicked;
  const RangeDatePicker({super.key, required this.onPicked});


  @override
  State<RangeDatePicker> createState() => _RangeDatePickerState();
}

class _RangeDatePickerState extends State<RangeDatePicker> {
   Pair<DateTime?,DateTime?> value=const Pair(null, null);

  @override
  Widget build(BuildContext context) {
    return RangeDatePickerBase(value:value,onPicked: (range){
      setState(() {
        value=range;
      });
      try{
        if(range.first!=null&&range.second!=null){
          widget.onPicked(Pair(range.first!, range.second!));
        }
      }
      catch(_){}

    });
  }
}

// Parent Widget Implementation
class RangeDatePickerBase extends StatelessWidget {
  ///hoisting the state because there is some use case when need to clear the filter
  final Pair<DateTime?,DateTime?> value;
  final  Function(Pair<DateTime?,DateTime?>) onPicked;
  const RangeDatePickerBase({super.key, this.value=const Pair(null,null),required this.onPicked,});

  @override
  Widget build(BuildContext context) {
    final  fromDate=value.first==null?'Select date':value.first.toString();
    final toDate=value.second==null?'Select date':value.second.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const Text(
        //   "Date",
        //   style: TextStyle(fontSize: 16, color: Colors.white),
        // ),
        _DatePickerButton(
          dateText: DateTimeUtils.exactDateOrOriginal(fromDate),
          onDateSelected: (DateTime date) {
            onPicked(value.changeFirst(date));
          },
        ),
        const Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            "To",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        _DatePickerButton(
          dateText:DateTimeUtils.exactDateOrOriginal(toDate) ,
          onDateSelected: (DateTime date) {
            onPicked(value.changeSecond(date));
          },
          borderColor: const Color.fromARGB(255, 30, 84, 134),
        ),
      ],
    );
  }
}

// Reusable Date Picker Widget
class _DatePickerButton extends StatelessWidget {
  final String dateText;
  final ValueChanged<DateTime> onDateSelected;
  final Color borderColor;

  const _DatePickerButton({
    required this.dateText,
    required this.onDateSelected,
    this.borderColor = const Color.fromARGB(255, 30, 84, 134),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height:  ThemeInfo.headerButtonHeight,
      child: ElevatedButton(
        onPressed: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            onDateSelected(pickedDate);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: borderColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(color: Colors.white, width: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RenderImg(path: 'clock.png'),
            const SizedBox(width: 8.0),
            Text(
              dateText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ClockText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final Color colorBackground;
  final double wordSpacing;

  const ClockText({super.key,
    required this.text,
    required this.size,
    required this.fontWeight,
    required this.color,
    required this.colorBackground,
    required this.wordSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(30.0),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFF194771),
          boxShadow: [
            BoxShadow(color: colorBackground, spreadRadius: 3),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: size,
            fontWeight: fontWeight,
            color: color,
            wordSpacing: wordSpacing,
          ),
        )
    );
  }
}