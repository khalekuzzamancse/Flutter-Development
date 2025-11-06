part of '../data_source.dart';

abstract class ProductRDSTemplate implements ProductApi {
  String get readUrl => URLFactory.urls.productsRead;
  List<ProductEntity> parseOrThrow(String json);
  late final client = NetworkClient.createBaseClient();

  @override
  Future<List<ProductEntity>> readOrThrow({String? nextUrl}) {
    if (nextUrl != null) {
      return _readOrThrow(nextUrl);
    } else {
      return _readOrThrow(readUrl);
    }
  }
  Future<List<ProductEntity>> _readOrThrow(String url) async {
    final response = await client.getOrThrow(url: url);
    return parseOrThrow(response);
  }
}

class ProductRemoteDataSrc extends ProductRDSTemplate {
  ProductRemoteDataSrc._();
  static ProductApi create() => ProductRemoteDataSrc._();
  @override
  List<ProductEntity> parseOrThrow(String json) {
    final _json= jsonDecode(json);
    final List<dynamic> items = _json as List<dynamic>;
    final products = items.map((item) {
      return parse(item as Json);
    }).toList();
    return products;
  }
  ProductEntity parse(Json json) {
    final ratingJson = json['rating'] as Json;
    return ProductEntity(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: RatingEntity(
        rate: (ratingJson['rate'] as num).toDouble(),
        count: ratingJson['count'] as int,
      ),
    );
  }
}
