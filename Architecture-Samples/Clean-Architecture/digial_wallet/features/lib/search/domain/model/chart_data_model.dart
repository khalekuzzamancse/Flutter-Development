/// TODO: Ideally, each layer (domain, data, presentation) should have its own
/// separate model along with appropriate mappers to reduce coupling.
/// Due to limited time, this has not been implemented here.
/// Refactor this code to follow a clean architecture approach.
class ChartData {
  final Map<String, TimePeriodData> data;
  final List<String> timePeriods;
  final String selectedTimePeriod;

  ChartData({
    required this.data,
    required this.timePeriods,
    required this.selectedTimePeriod,
  });

  // Factory method to create a ChartData instance from JSON
  factory ChartData.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>;
    final data = dataJson.map((key, value) =>
        MapEntry(key, TimePeriodData.fromJson(value)));

    return ChartData(
      data: data,
      timePeriods: List<String>.from(json['timePeriods']),
      selectedTimePeriod: json['selectedTimePeriod'],
    );
  }
}
/// TODO: Ideally, each layer (domain, data, presentation) should have its own
/// separate model along with appropriate mappers to reduce coupling.
/// Due to limited time, this has not been implemented here.
/// Refactor this code to follow a clean architecture approach.
class TimePeriodData {
  final List<String> xAxisData;
  final List<int> yAxisData;

  TimePeriodData({required this.xAxisData, required this.yAxisData});

  // Factory method to create a TimePeriodData instance from JSON
  factory TimePeriodData.fromJson(Map<String, dynamic> json) {
    return TimePeriodData(
      xAxisData: List<String>.from(json['xAxisData']),
      yAxisData: List<int>.from(json['yAxisData']),
    );
  }
}
