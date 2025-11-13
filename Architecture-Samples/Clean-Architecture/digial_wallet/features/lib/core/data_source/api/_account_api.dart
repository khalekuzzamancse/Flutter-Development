part of '../data_source.dart';

abstract interface class AccountApi {
  Future<List<CardEntity>> readCardsOrThrow();
  Future<List<ActiveLoanEntity>> readActiveLoansOrThrow();
  Future<SpendSummaryEntity> readSummaryOrThrow();
  Future<List<BreakdownEntity>> readBreakDownsOrThrow();
  Future<List<TransactionEntity>> readTransactionsOrThrow();
  Future<SpendModelEntity> readSpendOrThrow();
}


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
//@formatter:off
class CardEntity {
  final String cardName,cardNo,dueDate,amount, type;
  CardEntity( {required this.type, required this.cardName, required this.cardNo, required this.dueDate, required this.amount});
}
//@formatter:off
class ActiveLoanEntity {
  final String model, imageLink,price,date,status;
  const ActiveLoanEntity({required this.model, required this.imageLink, required this.price,
    required this.date, required this.status});
}
class TransactionEntity {
  final String image;
  final String title;
  final String subtitle;
  final String amount;
  final String date;

  TransactionEntity({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
  });
}