part of '../core_language.dart';

Future<void> delayInSecond(int sec) async=>await Future.delayed(Duration(seconds: sec));
Future<void> delayInMs(int ms) async => await Future.delayed(Duration(milliseconds: ms));
Future<T> tryStrategy<T>({required String tag, required Future<T> Function() requestOrThrow}) async {
  try {
    return await requestOrThrow();
  } catch (e, trace) {
    //  Logger.error(tag: '$tag::tryStrategy', error: e, trace: trace);
    Logger.errorCaught(tag,'tryStrategy', e,null);
    throw toCustomException2(exception: e,fallBackDebugMsg: 'source:$tag');
  }
}
///Just need next for now
class PaginationWrapper<T> {
  final T data;
  final int totalPage;
  final int count;
  final String? nextUrl;
  PaginationWrapper({required this.data,   this.totalPage=0,  this.count=0,this.nextUrl});

  @override
  String toString() {
    return 'PaginationWrapper(source: ${data.runtimeType}, totalPage: $totalPage,count:$count,next:$nextUrl)';
  }
}
typedef Json = Map<String, dynamic>;
