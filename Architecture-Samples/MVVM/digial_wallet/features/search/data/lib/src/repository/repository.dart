import 'package:network/network_factory.dart';
import 'package:network/to_custom_exception.dart';
import 'package:search_domain/domain_api.dart';

class RepositoryImpl implements Repository {
  @override
  Future<ChartData?> readChartData() async{
    try{
      final parser=NetworkFactory.createJsonParser<ChartData>();
      return   parser.parseOrThrow(_jsonData, ChartData.fromJson);
    }
    catch(e){
      throw  toCustomException(e);
    }

  }

  @override
  Future<List<Product>> readRecentProducts() async{
    final client = NetworkFactory.createApiClient<Product>();
    final url = 'https://fakestoreapi.com/products';
    try {
     return await client.readParseListOrThrow<Product>(url, Product.fromJson);
      //return _dummyProducts;
    } catch (e) {
    throw  toCustomException(e);
    }
  }
}



const _jsonData = '''{
      "data": {
        "1W": {"xAxisData": ["MON", "TUE", "WED", "THU", "FRI", "SAT"], "yAxisData": [1000, 1200, 1500, 2200, 3500, 5000]},
        "1M": {"xAxisData": ["Week 1", "Week 2", "Week 3", "Week 4"], "yAxisData": [15000, 20000, 25000, 30000]},
        "3M": {"xAxisData": ["Jan", "Feb", "Mar"], "yAxisData": [45000, 50000, 60000]},
        "6M": {"xAxisData": ["Oct", "Nov", "Dec", "Jan", "Feb", "Mar"], "yAxisData": [70000, 75000, 80000, 85000, 90000, 95000]},
        "1Y": {"xAxisData": ["Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar"], "yAxisData": [100000, 105000, 110000, 120000, 130000, 140000, 150000, 155000, 160000, 165000, 170000, 175000]},
        "ALL": {"xAxisData": ["2020", "2021", "2022", "2023"], "yAxisData": [300000, 350000, 400000, 450000]}
      },
      "timePeriods": ["1W", "1M", "3M", "6M", "1Y", "ALL"],
      "selectedTimePeriod": "1W"
    }''';


/**
 * final List<Product> _dummyProducts = [
    Product(
    id: 1,
    title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
    price: 109.95,
    description:
    "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
    category: "men's clothing",
    image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
    rating: Rating(rate: 3.9, count: 120),
    ),
    Product(
    id: 2,
    title: "Mens Casual Premium Slim Fit T-Shirts",
    price: 22.3,
    description:
    "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, lightweight & soft fabric for breathable and comfortable wearing.",
    category: "men's clothing",
    image:
    "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
    rating: Rating(rate: 4.1, count: 259),
    ),
    Product(
    id: 3,
    title: "Mens Cotton Jacket",
    price: 55.99,
    description:
    "Great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions, such as working, hiking, camping, mountain/rock climbing, cycling, traveling or other outdoors.",
    category: "men's clothing",
    image: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
    rating: Rating(rate: 4.7, count: 500),
    ),
    Product(
    id: 4,
    title: "Mens Casual Slim Fit",
    price: 15.99,
    description:
    "The color could be slightly different between on the screen and in practice. Please note that body builds vary by person.",
    category: "men's clothing",
    image: "https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg",
    rating: Rating(rate: 2.1, count: 430),
    ),
    Product(
    id: 5,
    title:
    "John Hardy Women's Legends Naga Gold & Silver Dragon Station Chain Bracelet",
    price: 695,
    description:
    "From our Legends Collection, the Naga was inspired by the mythical water dragon that protects the ocean's pearl.",
    category: "jewelery",
    image: "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg",
    rating: Rating(rate: 4.6, count: 400),
    ),
    Product(
    id: 6,
    title: "Solid Gold Petite Micropave",
    price: 168,
    description:
    "Satisfaction Guaranteed. Return or exchange any order within 30 days. Designed and sold by Hafeez Center in the United States.",
    category: "jewelery",
    image: "https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_.jpg",
    rating: Rating(rate: 3.9, count: 70),
    ),
    Product(
    id: 7,
    title: "White Gold Plated Princess",
    price: 9.99,
    description:
    "Classic Created Wedding Engagement Solitaire Diamond Promise Ring for Her. Gifts to spoil your love more for Engagement, Wedding, Anniversary, Valentine's Day.",
    category: "jewelery",
    image: "https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_.jpg",
    rating: Rating(rate: 3.0, count: 400),
    ),
    Product(
    id: 8,
    title: "Pierced Owl Rose Gold Plated Stainless Steel Double",
    price: 10.99,
    description:
    "Rose Gold Plated Double Flared Tunnel Plug Earrings. Made of 316L Stainless Steel",
    category: "jewelery",
    image: "https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_.jpg",
    rating: Rating(rate: 1.9, count: 100),
    ),
    Product(
    id: 9,
    title: "WD 2TB Elements Portable External Hard Drive - USB 3.0",
    price: 64,
    description:
    "USB 3.0 and USB 2.0 Compatibility Fast data transfers Improve PC Performance High Capacity; Compatibility Formatted NTFS for Windows 10, Windows 8.1, Windows 7.",
    category: "electronics",
    image: "https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg",
    rating: Rating(rate: 3.3, count: 203),
    ),
    Product(
    id: 10,
    title: "SanDisk SSD PLUS 1TB Internal SSD - SATA III 6 Gb/s",
    price: 109,
    description:
    "Easy upgrade for faster boot up, shutdown, application load and response (As compared to 5400 RPM SATA 2.5” hard drive; Based on published specifications).",
    category: "electronics",
    image: "https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg",
    rating: Rating(rate: 2.9, count: 470),
    ),
    // Add more Product instances as needed based on your list
    ];
 */