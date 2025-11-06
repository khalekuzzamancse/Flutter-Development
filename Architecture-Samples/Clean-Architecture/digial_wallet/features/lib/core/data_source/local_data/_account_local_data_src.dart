part of '../data_source.dart';

class AccountLocalDataSource implements AccountApi {
  AccountLocalDataSource._();

  static AccountApi create() => AccountLocalDataSource._();

  @override
  Future<List<ActiveLoanEntity>> readActiveLoansOrThrow() async{
  return  [
      ActiveLoanEntity(
        model: "Model X",
        imageLink:
        "https://img.freepik.com/premium-vector/red-city-car-vector-illustration_648968-44.jpg?w=740",
        price: "\$399/M",
        date: "5th OCT",
        rating: 48,
        ratingMax: 60,
      ),
      ActiveLoanEntity(
        model: "Nokia Y",
        imageLink:
        "https://auspost.com.au/shop/static/WFS/AusPost-Shop-Site/-/AusPost-Shop-auspost-B2CWebShop/en_AU/feat-cat/mobile-phones/category-carousel/MP_UnlockedPhones_3.jpg",
        price: "\$299/M",
        date: "20 OCT",
        rating: 36,
        ratingMax: 50,
      ),
    ];
  }

  @override
  Future<List<CardEntity>> readCardsOrThrow()async {
    return [
      CardEntity(
          cardName: 'VISA',
          cardNo: '* * * 3854',
          dueDate: '10 OCT',
          amount: '5001.86',
          type: "visa"
      ),
      CardEntity(
          cardName: 'VISA',
          cardNo: '* * * 3854',
          dueDate: '10 OCT',
          amount: '5001.86',
          type:"visa"),
    ];
  }

  @override
  Future<SpendSummaryEntity> readSummaryOrThrow() async {
    final Map<String, dynamic> jsonData = jsonDecode(_jsonData);
    return _parser(jsonData);
  }

  SpendSummaryEntity _parser(Map<String, dynamic> json) {
    final dataJson = json['source'] as Map<String, dynamic>;
    final data = dataJson.map((key, value) {
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

  final _jsonData = '''{
      "source": {
        "1W": {"xAxisData": ["MON", "TUE", "WED", "THU", "FRI", "SAT"], "yAxisData": [1000, 1200, 1500, 2200, 3500, 5000]},
        "1M": {"xAxisData": ["Week 1", "Week 2", "Week 3", "Week 4"], "yAxisData": [15000, 20000, 25000, 30000]},
        "3M": {"xAxisData": ["Jan", "Feb", "Mar"], "yAxisData": [45000, 50000, 60000]},
        "6M": {"xAxisData": ["Oct", "Nov", "Dec", "Jan", "Feb", "Mar"], "yAxisData": [70000, 75000, 80000, 85000, 90000, 95000]},
        "1Y": {"xAxisData": ["Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar"], "yAxisData": [100000, 105000, 110000, 120000, 130000, 140000, 150000, 155000, 160000, 165000, 170000, 175000]},
        "ALL": {"xAxisData": ["2020", "2021", "2022", "2023"], "yAxisData": [300000, 350000, 400000, 450000]}
      },
      "timePeriods": ["1W", "1M", "3M", "6M", "1Y", "ALL"],
      "selectedTimePeriod": "1W"
    }''';

  @override
  Future<List<BreakdownEntity>> readBreakDownsOrThrow({String? nextUrl}) async {
    return [
      BreakdownEntity(label: "Food & Drinks", percentage: "45%"),
      BreakdownEntity(label: "Dresses", percentage: "25%"),
      BreakdownEntity(label: "Transport", percentage: "20%"),
      BreakdownEntity(label: "Others", percentage: "10%")
    ];
  }

  @override
  Future<SpendModelEntity> readSpendOrThrow() async {
    dynamic jsonString =  '''
  {
    "period": "This month",
    "currency": "\$",
    "spend": {
        "data": [
            {
                "1st_schedule": 400.00,
                "2nd_schedule": 600.00,
                "3rd_schedule": 1200.00,
                "4th_schedule": 1800.00,
                "5th_schedule": 2600.00
            }
        ]
    }
  }
  ''';
   final json=jsonDecode(jsonString);
    final spendJson = json['spend'] as Map<String, dynamic>;
    final sourceList = spendJson['data'] as List<dynamic>;
    final data = sourceList.map((item) {
      final map = item as Map<String, dynamic>;
      return ScheduleEntity(
        firstSchedule: (map['1st_schedule'] as num).toDouble(),
        secondSchedule: (map['2nd_schedule'] as num).toDouble(),
        thirdSchedule: (map['3rd_schedule'] as num).toDouble(),
        fourthSchedule: (map['4th_schedule'] as num).toDouble(),
        fifthSchedule: (map['5th_schedule'] as num).toDouble(),
      );
    }).toList();

    return SpendModelEntity(
      period: json['period'] as String,
      currency: json['currency'] as String,
      spend: data,
    );
  }
}
