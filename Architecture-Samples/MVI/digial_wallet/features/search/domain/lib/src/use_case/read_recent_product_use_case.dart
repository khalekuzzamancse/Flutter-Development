import '../../domain_api.dart';
class ReadRecentProductUseCase{
  final Repository repository;
  ReadRecentProductUseCase(this.repository);
  Future<List<Product>> execute()=>repository.readRecentProducts();
}