
import '../model/chart_data_model.dart';
import '../repository/repository.dart';
class ReadChartDataUseCase{
  final Repository repository;
  ReadChartDataUseCase(this.repository);
  Future<ChartData?> execute()=>repository.readChartData();
}