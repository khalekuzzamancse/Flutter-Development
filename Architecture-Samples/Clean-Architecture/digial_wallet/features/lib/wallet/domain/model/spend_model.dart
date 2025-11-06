class SpendModel {
  final String period;
  final String currency;
  final SpendItemModel spend;

  SpendModel({
    required this.period,
    required this.currency,
    required this.spend,
  });

}

class SpendItemModel {
  final List<ScheduleModel> data;

  SpendItemModel({
    required this.data,
  });

}

class ScheduleModel {
  final double firstSchedule;
  final double secondSchedule;
  final double thirdSchedule;
  final double fourthSchedule;
  final double fifthSchedule;

  ScheduleModel({
    required this.firstSchedule,
    required this.secondSchedule,
    required this.thirdSchedule,
    required this.fourthSchedule,
    required this.fifthSchedule,
  });


  /// Returns a list of costs for each schedule.
  List<double> toCost() {
    return [
      firstSchedule,
      secondSchedule,
      thirdSchedule,
      fourthSchedule,
      fifthSchedule,
    ];
  }
}
