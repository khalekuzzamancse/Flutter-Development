part of core_language;
//TODO:Async
Future<void> delayInSecond(int sec) async=>await Future.delayed(Duration(seconds: sec));
Future<void> delayInMs(int ms) async => await Future.delayed(Duration(milliseconds: ms));
Future<T> tryStrategy<T>({required String tag, required Future<T> Function() requestOrThrow}) async {
  try {
    return await requestOrThrow();
  } catch (e, trace) {
  //  Logger.error(tag: '$tag::tryStrategy', error: e, trace: trace);
    Logger.errorCaught(tag,'tryStrategy', e,null);
    throw toCustomException(exception: e,fallBackDebugMsg: 'source:$tag');
  }
}
 String currentMinuteSecondMillisecond() {
final now = DateTime.now();
final mm = now.minute.toString().padLeft(2, '0');
final ss = now.second.toString().padLeft(2, '0');
final ms = now.millisecond.toString().padLeft(3, '0');
return '$mm:$ss:$ms';
}