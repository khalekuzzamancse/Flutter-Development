part of '../data_source.dart';

abstract interface class URLFactory {
  ///Instead of "create" used names as "urls" so that can call as
  /// URLFactory.urls.activeLoansRead, for better readability
  static  URLFactory urls = URLFactoryImpl._();
  String get cardsRead;
  String get activeLoansRead;
  String get productsRead;
  String get spendDataRead;

}

class URLFactoryImpl implements URLFactory {
  ///To force pure abstraction and single source of instance creation
  URLFactoryImpl._();
  @override
  String get activeLoansRead => throw UnimplementedError();
  @override
  String get cardsRead => throw UnimplementedError();
  @override
  String get productsRead => "https://fakestoreapi.com/products";
  @override
  String get spendDataRead => throw UnimplementedError();

}
