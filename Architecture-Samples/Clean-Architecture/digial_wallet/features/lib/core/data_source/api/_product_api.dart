part of '../data_source.dart';
abstract interface class ProductApi{
  Future<List<ProductEntity>> readOrThrow({String? nextUrl});

}
class ProductEntity {
  final int id;
  final double price;
  final RatingEntity rating;
  final String title, description, category, image;

  ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });
}

class RatingEntity {
  final double rate;
  final int count;

  RatingEntity({required this.rate, required this.count});
}
