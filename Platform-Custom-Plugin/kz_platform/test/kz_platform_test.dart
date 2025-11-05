import 'package:flutter_test/flutter_test.dart';
import 'package:kz_platform/kz_platform.dart';
import 'package:kz_platform/kz_platform_platform_interface.dart';
import 'package:kz_platform/kz_platform_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKzPlatformPlatform
    with MockPlatformInterfaceMixin
    implements KzPlatformPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KzPlatformPlatform initialPlatform = KzPlatformPlatform.instance;

  test('$MethodChannelKzPlatform is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKzPlatform>());
  });

  test('getPlatformVersion', () async {
    KzPlatform kzPlatformPlugin = KzPlatform();
    MockKzPlatformPlatform fakePlatform = MockKzPlatformPlatform();
    KzPlatformPlatform.instance = fakePlatform;

    expect(await kzPlatformPlugin.getPlatformVersion(), '42');
  });
}
