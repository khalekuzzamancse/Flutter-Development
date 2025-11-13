import 'package:features/home/presentation/home_controller_impl.dart';
import 'package:features/search/data/search_repository.dart' as R;
import 'package:features/wallet/data/wallet_repository.dart' show WalletRepositoryImpl;
import 'package:features/search/domain/use_case/read_chart_data_use_case.dart';
import 'package:features/search/domain/use_case/read_recent_product_use_case.dart';
import 'package:features/wallet/domain/use_case/read_break_down_data.dart';
import 'package:features/wallet/domain/use_case/read_spend_data.dart';

import 'home/presentation/home_controller.dart';

class DiContainer{
  static ReadChartDataUseCase readCharData()=>ReadChartDataUseCase(R.SearchRepositoryImpl());
  static  ReadRecentProductUseCase readProducts()=>ReadRecentProductUseCase(R.SearchRepositoryImpl());
  static ReadBreakDownUseCase breakdownCase()=>ReadBreakDownUseCase(WalletRepositoryImpl());
  static ReadSpendDataUseCase spendDataUseCase()=>ReadSpendDataUseCase(WalletRepositoryImpl());
  static HomeController homeController()=>HomeControllerImpl();

}