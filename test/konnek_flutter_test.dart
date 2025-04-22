import 'package:flutter_test/flutter_test.dart';
import 'package:konnek_flutter/konnek_flutter.dart';
import 'package:konnek_flutter/konnek_flutter_platform_interface.dart';
import 'package:konnek_flutter/konnek_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKonnekFlutterPlatform
    with MockPlatformInterfaceMixin
    implements KonnekFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KonnekFlutterPlatform initialPlatform = KonnekFlutterPlatform.instance;

  test('$MethodChannelKonnekFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKonnekFlutter>());
  });

  test('getPlatformVersion', () async {
    KonnekFlutter konnekFlutterPlugin = KonnekFlutter();
    MockKonnekFlutterPlatform fakePlatform = MockKonnekFlutterPlatform();
    KonnekFlutterPlatform.instance = fakePlatform;

    expect(await konnekFlutterPlugin.getPlatformVersion(), '42');
  });
}
