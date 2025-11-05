
import 'package:wallet_data/api.dart';
import 'package:wallet_domain/domain_api.dart';

class DiContainer{
  static ReadBreakDownUseCase breakdownCase()=>ReadBreakDownUseCase(RepositoryImpl());
  static ReadSpendDataUseCase spendDataUseCase()=>ReadSpendDataUseCase(RepositoryImpl());

}