part of '../data_source.dart';

abstract interface class AccountApi {
  Future<PaginationWrapper<List<CardEntity>>> readCardsOrThrow({String? nextUrl});
  Future<PaginationWrapper<List<ActiveLoan>>> readActiveLoansOrThrow({String? nextUrl});
  Future<SpendSummaryEntity> readSpendSummaryOrThrow();
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
