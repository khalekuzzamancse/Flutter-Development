import '../../domain_api.dart';
class ReadChartDataUseCase{
  final Repository repository;
  ReadChartDataUseCase(this.repository);
  Future<ChartData?> execute()=>repository.readChartData();
}