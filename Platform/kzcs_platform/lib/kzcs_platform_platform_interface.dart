import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kzcs_platform_method_channel.dart';

abstract class KzcsPlatformPlatform extends PlatformInterface {
  /// Constructs a KzcsPlatformPlatform.
  KzcsPlatformPlatform() : super(token: _token);

  static final Object _token = Object();

  static KzcsPlatformPlatform _instance = MethodChannelKzcsPlatform();

  /// The default instance of [KzcsPlatformPlatform] to use.
  ///
  /// Defaults to [MethodChannelKzcsPlatform].
  static KzcsPlatformPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KzcsPlatformPlatform] when
  /// they register themselves.
  static set instance(KzcsPlatformPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
