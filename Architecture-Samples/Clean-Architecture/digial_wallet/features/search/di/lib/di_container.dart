import 'package:search_data/api.dart';
import 'package:search_domain/domain_api.dart';

class DiContainer{
  static ReadChartDataUseCase readCharData()=>ReadChartDataUseCase(RepositoryImpl());
  static  ReadRecentProductUseCase readProducts()=>ReadRecentProductUseCase(RepositoryImpl());

}