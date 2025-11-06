part of '../data_source.dart';

abstract interface class AccountApi {
  Future<PaginationWrapper<List<CardEntity>>> readCardsOrThrow({String? nextUrl});
  Future<PaginationWrapper<List<ActiveLoan>>> readActiveLoansOrThrow({String? nextUrl});
  Future<SpendSummaryEntity> readSummaryOrThrow();
  Future<List<BreakdownEntity>> readBreakDownsOrThrow();
  Future<SpendModelEntity> readSpendOrThrow();
}

class CardEntity {}

class ActiveLoan {}

class SpendSummaryEntity {
  final Map<String, TimePeriodEntity> data;
  final List<String> timePeriods;
  final String selectedTimePeriod;

  SpendSummaryEntity({
    required this.data,
    required this.timePeriods,
    required this.selectedTimePeriod,
  });
}

class TimePeriodEntity {
  final List<String> xAxisData;
  final List<int> yAxisData;

  TimePeriodEntity({required this.xAxisData, required this.yAxisData});
}

//@formater:off
class BreakdownEntity {
  final String label;
  final String percentage;

  BreakdownEntity({required this.label, required this.percentage});
}

class SpendModelEntity {
  final String period;
  final String currency;
  final List<ScheduleEntity> spend;

  SpendModelEntity({
    required this.period,
    required this.currency,
    required this.spend,
  });
}
class ScheduleEntity {
  final double firstSchedule;
  final double secondSchedule;
  final double thirdSchedule;
  final double fourthSchedule;
  final double fifthSchedule;

  ScheduleEntity({
    required this.firstSchedule,
    required this.secondSchedule,
    required this.thirdSchedule,
    required this.fourthSchedule,
    required this.fifthSchedule,
  });
}