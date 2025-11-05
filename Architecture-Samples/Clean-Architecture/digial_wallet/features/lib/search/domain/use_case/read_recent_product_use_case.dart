import '../model/product_model.dart';
import '../repository/repository.dart';
class ReadRecentProductUseCase{
  final Repository repository;
  ReadRecentProductUseCase(this.repository);
  Future<List<Product>> execute()=>repository.readRecentProducts();
}