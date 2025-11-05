import '../../domain_api.dart';

class ReadSpendDataUseCase{
  final Repository repository;
  ReadSpendDataUseCase(this.repository);
  Future<SpendData>  execute()=>repository.readSpendData();
}