import 'package:network/network_factory.dart';
import 'package:network/to_custom_exception.dart';
import 'package:wallet_domain/domain_api.dart';

class RepositoryImpl implements Repository {
  @override
  Future<List<BreakdownItemData>> readBreakDownData() async{
    try{
      return   _demoBreakDownData;
    }
    catch(e){
      throw  toCustomException(e);
    }

  }

  @override
  Future<SpendData> readSpendData() async {
    try{
      final parser=NetworkFactory.createJsonParser<SpendData>();
      return   parser.parseOrThrow(_spendDataJson, SpendData.fromJson);
    }
    catch(e){
    throw  toCustomException(e);
    }
  }
}

final _spendDataJson = '''
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

final _demoBreakDownData=[
  BreakdownItemData(label: "Food & Drinks", percentage: "45%"),
  BreakdownItemData(label: "Dresses", percentage: "25%"),
  BreakdownItemData(label: "Transport", percentage: "20%"),
  BreakdownItemData(label: "Others", percentage: "10%")];