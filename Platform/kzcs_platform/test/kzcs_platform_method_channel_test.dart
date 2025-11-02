import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kzcs_platform/kzcs_platform_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelKzcsPlatform platform = MethodChannelKzcsPlatform();
  const MethodChannel channel = MethodChannel('kzcs_platform');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
