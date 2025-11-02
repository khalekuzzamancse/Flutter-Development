import 'package:flutter_test/flutter_test.dart';
import 'package:kzcs_platform/kzcs_platform.dart';
import 'package:kzcs_platform/kzcs_platform_platform_interface.dart';
import 'package:kzcs_platform/kzcs_platform_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKzcsPlatformPlatform
    with MockPlatformInterfaceMixin
    implements KzcsPlatformPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KzcsPlatformPlatform initialPlatform = KzcsPlatformPlatform.instance;

  test('$MethodChannelKzcsPlatform is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKzcsPlatform>());
  });

  test('getPlatformVersion', () async {
    KzcsPlatform kzcsPlatformPlugin = KzcsPlatform();
    MockKzcsPlatformPlatform fakePlatform = MockKzcsPlatformPlatform();
    KzcsPlatformPlatform.instance = fakePlatform;

    expect(await kzcsPlatformPlugin.getPlatformVersion(), '42');
  });
}
