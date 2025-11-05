part of remote_data_source;

abstract class UrlProvider {
  // Private static instance initialized with LocalUrlBuilder
  static final UrlProvider _builder = _ProductionUrlBuilder();


  // Singleton instance accessor
  static UrlProvider get ins => _builder;

  // Category
  String get category => _builder.category;

  // Inventory
  String productInfo(int id) => _builder.productInfo(id);
  String productReadOneUrl(String id)=>_builder.productReadOneUrl(id);
  String productsRead(String? categoryId) => _builder.productsRead(categoryId);

  // Customer
  String get customerListRead => _builder.customerListRead;
  String customerReadOne(String id)=>_builder.customerReadOne(id);
  String customerByPhoneNumber(String phone) => _builder.customerListRead;
  String customerQuery(String query) => _builder.customerQuery(query);
  String get customerCreate => _builder.customerCreate;
  String  customerUpdate(String id)=>_builder.customerUpdate(id);

  // Order
  String orderDetails(int id) => _builder.orderDetails(id);
  String get order => _builder.order;

  String orderById(int id) => _builder.orderById(id);
  String orderQuery(String query) => _builder.orderQuery(query);
  String orderDateFilter(String? type, Pair<DateTime, DateTime> range) =>
      _builder.orderDateFilter(type, range);
  String orderStatusFilter(String? type,List<Pair<String, String?>> status) =>
      _builder.orderStatusFilter(type,status);
  String orderUpdate(String id) => _builder.orderUpdate(id);

  // Delivery
  String get deliveryRead => _builder.deliveryRead;
  String deliveryUpdate(int deliveryId) => _builder.deliveryUpdate(deliveryId);
  String get deliveryBoyListRead => _builder.deliveryBoyListRead;
  String deliveryAssignBoy(String deliveryId)=>_builder.deliveryAssignBoy(deliveryId);

  String assignDeliveryBoy(int orderId) => _builder.assignDeliveryBoy(orderId);

  // Takeaway Orders & Transactions
  String get takeAwaySaveOrder => _builder.takeAwaySaveOrder;

  String get transactionHistory => _builder.transactionHistory;

  // Authentication
  String get authLogin => _builder.authLogin;
  String get refreshAccessToken=>_builder.refreshAccessToken;

  // Collection List
  String updateCollection(String id) => _builder.updateCollection(id);
  String buildPaySocketUrl({
    required String softwareHouseId,
    required String deviceUid,
    required String apiVersion,
    required String apiKey,
    required String tid,
  });
}

class _ProductionUrlBuilder implements UrlProvider {
  final String baseUrl = 'https://epos.sandbox.payinpos.com';

  //TODO: Related to customer
  @override
  String get customerListRead => '$baseUrl/api/v1/auth/customer/list';
  @override
  String customerQuery(String query) => '$baseUrl/api/v1/auth/customer/list?search=$query';
  @override
  String get customerCreate => '$baseUrl/api/v1/auth/customer/create';
  @override
  String customerReadOne(String id)=>'$baseUrl/api/v1/auth/customer/list?id=$id';
  @override
  String customerUpdate(String id)=>'$baseUrl/api/v1/auth/customer/update/$id/';

  @override
  String get category => '$baseUrl/api/v1/inventory/category/';

  @override
  String productInfo(int id) => '$baseUrl/api/v1/inventory/product/$id';

  @override
  String productsRead(String? categoryId) {
    final category = (categoryId == null ? '' : '?category=$categoryId');
    return '$baseUrl/api/v1/inventory/product/$category';
  }
  @override
  String productReadOneUrl(String id)=>'$baseUrl/api/v1/inventory/product/$id';
  //TODO: Order Related
  @override
  String orderDetails(int id) => '$baseUrl/api/v1/order/pos-order/$id';
  @override
  String get order => '$baseUrl/api/v1/order/pos-order/';
  @override
  String orderById(int id) => '$baseUrl/api/v1/order/pos-order/$id';
  @override
  String orderQuery(String query) => '$baseUrl/api/v1/order/pos-order/?search=$query';

  @override
  String orderUpdate(String id) => '$baseUrl/api/v1/order/pos-order/$id/';
  @override
  String updateCollection(String id) => orderUpdate(id);
  @override
  String get deliveryRead => '$baseUrl/api/v1/delivery/delivery/';
  @override
  String deliveryUpdate(int deliveryId) => '$deliveryRead$deliveryId/';
  @override
  String get deliveryBoyListRead => '$baseUrl/api/v1/auth/delivery-boy/list';
  @override
  String assignDeliveryBoy(int orderId) => '$baseUrl/remote/v1/delivery/delivery/$orderId/';
  @override
  String deliveryAssignBoy(String deliveryId)=>'$baseUrl/api/v1/delivery/delivery/$deliveryId/';

  @override
  String get takeAwaySaveOrder => '$baseUrl/api/v1/order/pos-order/';

  @override
  String get transactionHistory => '$baseUrl/api/v1/order/transaction/';

  @override
  String get authLogin => '$baseUrl/api/v1/auth/merchant-stuff/login';
  @override
  String get refreshAccessToken => '$baseUrl/api/v1/auth/token/refresh/';

  @override
  // TODO: implement customerByPhoneNumber
  String customerByPhoneNumber(String phone) => throw UnimplementedError();

  @override
  String orderDateFilter(String? type, Pair<DateTime, DateTime> range) {
    if(type==null){
      return "$baseUrl/api/v1/order/pos-order/?created_at_from=${formatDate(range.first)}&created_at_to=${formatDate(range.second)}";
    }
    return "$baseUrl/api/v1/order/pos-order/?order_type=$type&created_at_from=${formatDate(range.first)}&created_at_to=${formatDate(range.second)}";
  }

  String formatDate(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  @override
  String orderStatusFilter(String? type, List<Pair<String, String?>> status) {
    final filteredStatus = status.where((pair) => pair.second != null);
    final queryString = filteredStatus
        .map((pair) => '${pair.first}=${pair.second}')
        .join('&');
    if(type==null){
      return '$baseUrl/api/v1/order/pos-order/?$queryString';
    }
   return '$baseUrl/api/v1/order/pos-order/?order_type=$type&$queryString';

  }

  @override
  String buildPaySocketUrl({required String softwareHouseId,
    required String deviceUid, required String apiVersion, required String apiKey, required String tid}) {
    final String url =
        "wss://psa1.paymentsave.co.uk/ws/v1/pos/?api-key=$apiKey&api-version=$apiVersion&software-house-id=$softwareHouseId&device-uid=$deviceUid";
    return url;
  }

}
