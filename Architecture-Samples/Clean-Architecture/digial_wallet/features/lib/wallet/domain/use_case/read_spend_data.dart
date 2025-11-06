import '../model/spend_model.dart';
import '../repository/repository.dart';

class ReadSpendDataUseCase{
  final Repository repository;
  ReadSpendDataUseCase(this.repository);
  Future<SpendModel>  execute()=>repository.readSpendData();
}