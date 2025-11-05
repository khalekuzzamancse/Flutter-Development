// ignore_for_file: avoid_print
part of "core_language.dart";
abstract class ILogger {
  void on(String context, String subContext, dynamic key, dynamic value);
  void off(String tag, String message);
  void error(String tag, Object error, [StackTrace? stackTrace]);
}

class PrintLogger implements ILogger {
  final String id = 'CustomLog';

  @override
  void on(String context, String subContext, dynamic key, dynamic value) {
    final tag = '$context:$subContext';
    final message = '$key=$value';
    print('$id::$tag -> $message');
  }

  @override
  void off(String tag, String message) {
    print('$id::$tag -> off: $message');
  }

  @override
  void error(String tag, Object error, [StackTrace? stackTrace]) {
    print('$id::$tag -> error: $error');
    if (stackTrace != null) {
      print('$id::$tag -> stackTrace: $stackTrace');
    }
  }
}

class Logger {
  static ILogger _logger = PrintLogger(); // default to PrintLogger

  static void init(ILogger loggerImpl) {
    _logger = loggerImpl;
  }

  static void on(String context, String subContext, dynamic key, dynamic value) {
    _logger.on(context, subContext, key, value);
  }

  static void onSimple(String context, dynamic key, dynamic value) {
    _logger.on(context, '', key, value);
  }

  static void off(String context, dynamic key, dynamic value) {
    // placeholder: no-op
  }

  static void offDetailed(String context, String subContext, dynamic key, dynamic value) {
    // placeholder: no-op
  }

  static void error(String tag, Object error, [StackTrace? stackTrace]) {
    _logger.error(tag, error, stackTrace);
  }
}
