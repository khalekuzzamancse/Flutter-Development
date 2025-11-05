part of 'core_language.dart';

///context= can be file or class name
/// subContext= method name or scope name or closer, etc
class Logger {
  static final ILogger _logger = ILogger.create(true);

  static void off(String context, String? message, {String? method, Object? key, Object? value}) {
    //TODO: Just empty body so that user can switch between on and off without removing/commenting the code
  }

  /// @Deprecated, use to keyValueOn() instead
  ///
  ///Use for debugging by turing off other log
  ///Once debug finish must switch to another Log or remove the Log because in production this method may be removed
  ///
  static void on(String context, String? message, {String? method, Object? key, Object? value, bool fileWrite = true}) {
    final tg = method == null ? context : '$context::$method';
    final msg = message ?? '$key=$value';
    _logger.log(tg, msg);
  }

  /// Write all the log in eposLogAll.text file, use key must be unique to avoid missing info
  static void keyValueOn( String context, String? subContext,Object? key, Object? value) {
    final tag = subContext == null ? context : '$context::$subContext';
    var message = '$key:$value';
    _logger.log(tag, message);
  }
  /// error with trace will be logged in ErrorLog channel and only the error name will be written in All Log file
  static void errorCaught( String context, String? subContext, Object error, StackTrace? trace){
    final tag = subContext == null ? context : '$context::$subContext';
    _logger.errorCaught(tag, 'errorLog:error:$error,trace:$trace');
  }

  /// Write the log in eposLogAll.text and eposLogDebug.text file, just work as filer channel
  static void debug( String context, String? subContext,Object? key, Object? value) {
    final tag = subContext == null ? context : '$context::$subContext()';
    final message = '$key:$value';
    _logger.debug(tag, message);
  }

  ///should call once before on app start-up
  static void clearLogs() async {


  }
  /// Does not write or print
  static void keyValueOff( String context, String? subContext,Object? key, Object? value) {}

}
