class SpendData {
  final String period;
  final String currency;
  final Spend spend;

  SpendData({
    required this.period,
    required this.currency,
    required this.spend,
  });

  factory SpendData.fromJson(Map<String, dynamic> json) {
    return SpendData(
      period: json['period'] as String,
      currency: json['currency'] as String,
      spend: Spend.fromJson(json['spend'] as Map<String, dynamic>),
    );
  }
}

class Spend {
  final List<ScheduleData> data;

  Spend({
    required this.data,
  });

  factory Spend.fromJson(Map<String, dynamic> json) {
    var dataList = (json['data'] as List)
        .map((item) => ScheduleData.fromJson(item as Map<String, dynamic>))
        .toList();
    return Spend(data: dataList);
  }
}

class ScheduleData {
  final double firstSchedule;
  final double secondSchedule;
  final double thirdSchedule;
  final double fourthSchedule;
  final double fifthSchedule;

  ScheduleData({
    required this.firstSchedule,
    required this.secondSchedule,
    required this.thirdSchedule,
    required this.fourthSchedule,
    required this.fifthSchedule,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      firstSchedule: json['1st_schedule'] as double,
      secondSchedule: json['2nd_schedule'] as double,
      thirdSchedule: json['3rd_schedule'] as double,
      fourthSchedule: json['4th_schedule'] as double,
      fifthSchedule: json['5th_schedule'] as double,
    );
  }
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
