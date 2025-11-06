/// TODO: Ideally, each layer (domain, source, presentation) should have its own
/// separate model along with appropriate mappers to reduce coupling.
/// Due to limited time, this has not been implemented here.
/// Refactor this code to follow a clean architecture approach.
//@formatter:off
class ProductModel {
  final int id;  final double price;  final RatingModel rating;
  final String title,description,category,image;

  ProductModel({required this.id, required this.title, required this.price,
    required this.description, required this.category, required this.image, required this.rating,
  });


  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: RatingModel.fromJson(json['rating']),
    );
  }
}

//@formatter:off
class RatingModel {final double rate;final int count;
  RatingModel({required this.rate, required this.count});
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: json['rate'].toDouble(),
      count: json['count'],
    );
  }
}