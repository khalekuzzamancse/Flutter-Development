part of core_language;

abstract interface class ILogger {
  void log(String tag, String msg);
  void errorCaught(String tag, String msg);
  void debug(String tag, String msg);
  static String fileNameLogAll (String dir) => '$dir/EposLogAll.txt';
  static String fileNameLogError (String dir) => '$dir/EposLogError.txt';
  static String fileNameLogDebug(String dir) => '$dir/EposLogDebug.txt';
  static ILogger create(bool runOnSeparateIsolate){
    return BackGroundLogger();
  }
}
class MainIsolateLogger implements ILogger {
  @override
  void log(String tag, String msg) {
    print('[$tag]::$msg');
  }

  @override
  void errorCaught(String tag, String msg) {
    // TODO: implement catchError
  }

  @override
  void debug(String tag, String msg) {
    // TODO: implement debug
  }



}




