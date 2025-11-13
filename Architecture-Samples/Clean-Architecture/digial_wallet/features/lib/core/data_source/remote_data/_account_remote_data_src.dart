part of '../data_source.dart';

abstract class AccountRDSTemplate implements AccountApi{
  String get loanReadUrl=>URLFactory.urls.activeLoansRead;
  String get cardReadUrl=>URLFactory.urls.cardsRead;
  String get spendSummaryReadUrl=>URLFactory.urls.spendSummary;
  String get transactionReadUrl=>URLFactory.urls.transactionsRead;
  final _client= NetworkClient.createBaseClient();
  List<ActiveLoanEntity> parseActiveLoans(dynamic json);
  List<CardEntity> parseCards(dynamic json);
  SpendSummaryEntity parseSpendSummary(dynamic json);
  SpendModelEntity parseSpend(dynamic json);
  List<TransactionEntity> parseTransaction(dynamic json);

  @override
  Future<List<TransactionEntity>> readTransactionsOrThrow() async{
    final response=await _client.getOrThrow(url: transactionReadUrl);
    await delayInMs(3000);
    return parseTransaction(jsonDecode(response));

  }
  @override
  Future<List<ActiveLoanEntity>> readActiveLoansOrThrow() async{
    final response=await _client.getOrThrow(url: loanReadUrl);
    return parseActiveLoans(jsonDecode(response));
  }

  @override
  Future<List<BreakdownEntity>> readBreakDownsOrThrow() {
    // TODO: implement readBreakDownsOrThrow
    throw UnimplementedError();
  }

  @override
  Future<List<CardEntity>> readCardsOrThrow()async {
    final response=await _client.getOrThrow(url: cardReadUrl);
    return parseCards(jsonDecode(response));
  }

  @override
  Future<SpendModelEntity> readSpendOrThrow()async {
    final response=await _client.getOrThrow(url: loanReadUrl);
    return parseSpend(jsonDecode(response));
  }

  @override
  Future<SpendSummaryEntity> readSummaryOrThrow() async{
    final response=await _client.getOrThrow(url: spendSummaryReadUrl);
    return parseSpendSummary(jsonDecode(response));
  }

}
class AccountLocalServer extends AccountRDSTemplate {

  AccountLocalServer._();
  static AccountApi create()=>AccountLocalServer._();

  @override
  List<ActiveLoanEntity> parseActiveLoans(dynamic json) {
    List<dynamic> loansJson = json;
    return loansJson.map((loanJson) {
      return ActiveLoanEntity(
        model: loanJson['model'],
        imageLink: loanJson['imageLink'],
        price: loanJson['price'],
        date: loanJson['date'],
        status: loanJson['status'],
      );
    }).toList();
  }

  // Parse Cards
  List<CardEntity> parseCards(dynamic json) {
    List<dynamic> cardsJson = json;
    return cardsJson.map((cardJson) {
      return CardEntity(
        cardName: cardJson['cardName'],
        cardNo: cardJson['cardNo'],
        dueDate: cardJson['dueDate'],
        amount: cardJson['amount'],
        type: cardJson['type'],
      );
    }).toList();
  }

  // Parse Spend Data
  SpendModelEntity parseSpend(dynamic json) {
    final spendJson = json['spend'] as Map<String, dynamic>;
    final dataJsonList = spendJson['data'] as List<dynamic>;

    final spendData = dataJsonList.map((dataJson) {
      return ScheduleEntity(
        firstSchedule: (dataJson['1st_schedule'] as num).toDouble(),
        secondSchedule: (dataJson['2nd_schedule'] as num).toDouble(),
        thirdSchedule: (dataJson['3rd_schedule'] as num).toDouble(),
        fourthSchedule: (dataJson['4th_schedule'] as num).toDouble(),
        fifthSchedule: (dataJson['5th_schedule'] as num).toDouble(),
      );
    }).toList();

    return SpendModelEntity(
      period: json['period'],
      currency: json['currency'],
      spend: spendData,
    );
  }

  // Parse Spend Summary
  SpendSummaryEntity parseSpendSummary(dynamic json) {
    final sourceJson = json['source'] as Map<String, dynamic>;
    // Parse 'source' into a map of `TimePeriodEntity`
    final data = sourceJson.map((key, value) {
      final timeEntity = TimePeriodEntity(
        xAxisData: List<String>.from(value['xAxisData']),
        yAxisData: List<int>.from(value['yAxisData']),
      );
      return MapEntry(key, timeEntity);
    });

    return SpendSummaryEntity(
      data: data,
      timePeriods: List<String>.from(json['timePeriods']),
      selectedTimePeriod: json['selectedTimePeriod'],
    );
  }

  List<TransactionEntity> parseTransaction(dynamic json) {
    return (json as List<dynamic>).map((transaction) {
      return TransactionEntity(
        image: transaction['image'],
        title: transaction['title'],
        subtitle: transaction['subtitle'],
        amount: transaction['amount'],
        date: transaction['date'],
      );
    }).toList();
  }


}