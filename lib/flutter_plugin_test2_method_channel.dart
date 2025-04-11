import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flutter_plugin_test2_platform_interface.dart';

/// An implementation of [FlutterPluginTest2Platform] that uses method channels.
class MethodChannelFlutterPluginTest2 extends FlutterPluginTest2Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_plugin_test2');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // @override
  // Widget entryPointWidget() {
  //   return ChatButtonWidget();
  // }
}
