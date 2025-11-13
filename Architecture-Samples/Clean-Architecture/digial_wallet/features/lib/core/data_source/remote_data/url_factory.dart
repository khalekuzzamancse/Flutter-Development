part of '../data_source.dart';

abstract interface class URLFactory {
  ///Instead of "create" used names as "urls" so that can call as
  /// URLFactory.urls.activeLoansRead, for better readability
  static  URLFactory urls = URLFactoryLocalServer._();
  String get cardsRead;
  String get activeLoansRead;
  String get productsRead;
  String get spendDataRead;
  String get spendSummary;
  String get transactionsRead;

}

class URLFactoryLocalServer implements URLFactory {
  ///To force pure abstraction and single source of instance creation
  URLFactoryLocalServer._();
  final base="http://192.168.10.218:8080";
  @override
  String get productsRead => "https://fakestoreapi.com/products";
  @override
  String get activeLoansRead => '$base/active-loans';
  @override
  String get cardsRead => '$base/cards';
  @override
  String get spendDataRead => '$base/spend-data';
  @override
  String get spendSummary => '$base/spend-summary';
  @override
  String get transactionsRead => '$base/transactions';
}
