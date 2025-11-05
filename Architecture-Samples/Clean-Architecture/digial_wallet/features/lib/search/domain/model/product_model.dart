/// TODO: Ideally, each layer (domain, data, presentation) should have its own
/// separate model along with appropriate mappers to reduce coupling.
/// Due to limited time, this has not been implemented here.
/// Refactor this code to follow a clean architecture approach.
//@formatter:off
class Product {
  final int id;  final double price;  final Rating rating;
  final String title,description,category,image;

  Product({required this.id, required this.title, required this.price,
    required this.description, required this.category, required this.image, required this.rating,
  });


  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: Rating.fromJson(json['rating']),
    );
  }
}

//@formatter:off
class Rating {final double rate;final int count;
  Rating({required this.rate, required this.count});
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['rate'].toDouble(),
      count: json['count'],
    );
  }
}