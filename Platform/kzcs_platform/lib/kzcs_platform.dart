
import 'kzcs_platform_platform_interface.dart';

class KzcsPlatform {
  Future<String?> getPlatformVersion() {
    return KzcsPlatformPlatform.instance.getPlatformVersion();
  }
}
