
import '../model/break_down_model.dart';
import '../repository/repository.dart';

class ReadBreakDownUseCase{
  final Repository repository;
  ReadBreakDownUseCase(this.repository);
  Future<List<BreakdownItemData>>  execute()=>repository.readBreakDownData();
}
