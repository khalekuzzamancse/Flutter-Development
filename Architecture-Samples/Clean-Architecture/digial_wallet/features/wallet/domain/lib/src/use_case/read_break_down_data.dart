import '../../domain_api.dart';
class ReadBreakDownUseCase{
  final Repository repository;
  ReadBreakDownUseCase(this.repository);
  Future<List<BreakdownItemData>>  execute()=>repository.readBreakDownData();
}
