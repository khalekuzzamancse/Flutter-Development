
part of core_ui;


class ScreenTitleAndTimerView extends StatelessWidget {
  final String title;
  const ScreenTitleAndTimerView({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              title,
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
          const TimerWidget(
            updateDuration: 1,
            showSeconds: true,
            clockColor: Colors.white,
          ),
        ],
      ),
    );
  }
}



