
import 'package:path_provider/path_provider.dart';

/// Must initialize it in the app, Global mediator for whole app
class DirectoryProvider   {
  static Future<String> getLogFileDirectoryOrThrow()async{
    final directory= await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
