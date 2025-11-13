import 'dart:convert';

class AccountApi {

  Future<String> readActiveLoans() async {
    final List<Map<String, dynamic>> loans = [
      {
        "model": "Model X",
        "imageLink": "https://img.freepik.com/premium-vector/red-city-car-vector-illustration_648968-44.jpg?w=740",
        "price": "\$399/M",
        "date": "5th OCT",
        "status": "pending",
      },
      {
        "model": "Nokia Y",
        "imageLink": "https://auspost.com.au/shop/static/WFS/AusPost-Shop-Site/-/AusPost-Shop-auspost-B2CWebShop/en_AU/feat-cat/mobile-phones/category-carousel/MP_UnlockedPhones_3.jpg",
        "price": "\$299/M",
        "date": "20 OCT",
        "status": "approved"
      },
    ];
    return jsonEncode(loans); // Return JSON string
  }

  Future<String> readCards() async {
    final List<Map<String, dynamic>> cards = [
      {
        "cardName": "VISA",
        "cardNo": "* * * 3854",
        "dueDate": "10 OCT",
        "amount": "5001.86",
        "type": "visa",
      },
      {
        "cardName": "VISA",
        "cardNo": "* * * 3854",
        "dueDate": "10 OCT",
        "amount": "5001.86",
        "type": "visa",
      },
    ];
    return jsonEncode(cards); // Return JSON string
  }

  Future<String> readSpendSummary() async {
    final Map<String, dynamic> summary = {
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
    };
    return jsonEncode(summary); // Return JSON string
  }

  Future<String> readBreakdowns() async {
    final List<Map<String, dynamic>> breakdowns = [
      {"label": "Food & Drinks", "percentage": "45%"},
      {"label": "Dresses", "percentage": "25%"},
      {"label": "Transport", "percentage": "20%"},
      {"label": "Others", "percentage": "10%"}
    ];
    return jsonEncode(breakdowns); // Return JSON string
  }

  Future<String> readSpendData() async {
    final Map<String, dynamic> spendData = {
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
    };
    return jsonEncode(spendData); // Return JSON string
  }
}
