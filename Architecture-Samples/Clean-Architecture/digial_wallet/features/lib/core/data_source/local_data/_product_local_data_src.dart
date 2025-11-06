part of '../data_source.dart';
class ProductLocalDataSource implements ProductApi{
  ProductLocalDataSource._();
  static ProductApi create()=> ProductLocalDataSource._();
  @override
  Future<List<ProductEntity>> readOrThrow({String? nextUrl}) {
    // TODO: implement readOrThrow
    throw UnimplementedError();
  }

}