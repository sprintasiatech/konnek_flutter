import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_plugin_test2/flutter_plugin_test2.dart';
import 'package:flutter_plugin_test2/flutter_plugin_test2_platform_interface.dart';
import 'package:flutter_plugin_test2/flutter_plugin_test2_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPluginTest2Platform with MockPlatformInterfaceMixin implements FlutterPluginTest2Platform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPluginTest2Platform initialPlatform = FlutterPluginTest2Platform.instance;

  test('$MethodChannelFlutterPluginTest2 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPluginTest2>());
  });

  test('getPlatformVersion', () async {
    FlutterPluginTest2 flutterPluginTest2Plugin = FlutterPluginTest2();
    MockFlutterPluginTest2Platform fakePlatform = MockFlutterPluginTest2Platform();
    FlutterPluginTest2Platform.instance = fakePlatform;

    expect(await flutterPluginTest2Plugin.getPlatformVersion(), '42');
  });
}
