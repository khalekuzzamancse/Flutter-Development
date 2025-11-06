import 'package:features/search/data/repository.dart' as R;
import 'package:features/wallet/data/repository.dart' show RepositoryImpl;
import 'package:features/search/domain/use_case/read_chart_data_use_case.dart';
import 'package:features/search/domain/use_case/read_recent_product_use_case.dart';
import 'package:features/wallet/domain/use_case/read_break_down_data.dart';
import 'package:features/wallet/domain/use_case/read_spend_data.dart';

class DiContainer{
  static ReadChartDataUseCase readCharData()=>ReadChartDataUseCase(R.SearchRepositoryImpl());
  static  ReadRecentProductUseCase readProducts()=>ReadRecentProductUseCase(R.SearchRepositoryImpl());
  static ReadBreakDownUseCase breakdownCase()=>ReadBreakDownUseCase(RepositoryImpl());
  static ReadSpendDataUseCase spendDataUseCase()=>ReadSpendDataUseCase(RepositoryImpl());

}