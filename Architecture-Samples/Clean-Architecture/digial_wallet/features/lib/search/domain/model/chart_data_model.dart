
class SpendSummaryModel {
  final Map<String, TimePeriodModel> data;
  final List<String> timePeriods;
  final String selectedTimePeriod;

  SpendSummaryModel({
    required this.data,
    required this.timePeriods,
    required this.selectedTimePeriod,
  });

  // Factory method to create a ChartData instance from JSON
  factory SpendSummaryModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['source'] as Map<String, dynamic>;
    final data = dataJson.map((key, value) =>
        MapEntry(key, TimePeriodModel.fromJson(value)));

    return SpendSummaryModel(
      data: data,
      timePeriods: List<String>.from(json['timePeriods']),
      selectedTimePeriod: json['selectedTimePeriod'],
    );
  }
}

class TimePeriodModel {
  final List<String> xAxisData;
  final List<int> yAxisData;

  TimePeriodModel({required this.xAxisData, required this.yAxisData});

  // Factory method to create a TimePeriodData instance from JSON
  factory TimePeriodModel.fromJson(Map<String, dynamic> json) {
    return TimePeriodModel(
      xAxisData: List<String>.from(json['xAxisData']),
      yAxisData: List<int>.from(json['yAxisData']),
    );
  }
}
