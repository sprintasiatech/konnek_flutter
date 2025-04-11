import 'package:flutter/material.dart';
import 'package:flutter_plugin_test2/interface/live_chat_sdk_platform.dart';

class LiveChatSdk {
  Widget entryPointWidget() {
    return LiveChatSDKPlatform.instance.entryPoint();
  }
}
