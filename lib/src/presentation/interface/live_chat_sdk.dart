import 'package:flutter/material.dart';
import 'package:flutter_plugin_test2/src/presentation/interface/live_chat_sdk_platform.dart';

class LiveChatSdk {
  Widget entryPointWidget({
    Widget? customFloatingWidget,
  }) {
    return LiveChatSDKPlatform.instance.entryPoint(
      customFloatingWidget: customFloatingWidget,
    );
  }

  Future<void> initialize() async {
    await LiveChatSDKPlatform.instance.initialize();
  }
}
