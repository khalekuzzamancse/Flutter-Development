
import '../model/chart_data_model.dart';
import '../model/product_model.dart';

abstract class Repository{
  Future<ChartData?> readChartData();
  Future<List<Product>> readRecentProducts();
}