import '../../domain_api.dart';
abstract class Repository{
  Future<ChartData?> readChartData();
  Future<List<Product>> readRecentProducts();
}