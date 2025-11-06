
import '../model/break_down_model.dart';
import '../repository/repository.dart';

class ReadBreakDownUseCase{
  final Repository repository;
  ReadBreakDownUseCase(this.repository);
  Future<List<BreakdownModel>>  execute()=>repository.readBreakDownData();
}
