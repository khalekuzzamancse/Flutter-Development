//TODO: in the production mode just comment out the print statement
//as a result maintaining a single source of truth to turn-on/off the log
//or can switch to better logger without effecting the client
class Logger {


  static void log(String tag, String message) {
  //  print('[$tag]: $message');
  }

  static void debug(String tag, String message) {
  // print('[$tag]: $message');
  }

  ///Use for debugging by turing off other log
  ///Once debug finish must switch to another Log or remove the Log because in production this method may be removed
  static void temp(String tag, String message) {
 print('[$tag]: $message');
  }

  static void error(String tag, String message) {
    // print('[$tag]: $message');
  }

  static void errorWithTrace(String tag, StackTrace trace) {
    //print('[$tag]: $trace');
  }
  ///Meant to used for the core::network layer such as rest api call
  static void network(    String tag, String message){
  //  print('[$tag]: $message');

  }

  static void showStackTrace(String tag, StackTrace trace) {
   //   print('[$tag]');
  }

  static void authInfoLog(String tag, String message) {
   // print('[$tag]: $message');
  }

  static void logSocket(String tag, String message) {
  //  print('[$tag]: $message');
  }

  static void logSocketConnection(String tag, String message) {
 //   print('[$tag]: $message');
  }
}
