import 'package:flutter/material.dart';
import 'package:flutter_plugin_test2/interface/live_chat_sdk_platform.dart';

import '../widget/chat_button_widget.dart';
// import 'package:flutter_plugin_test2/widget/chat_button_widget.dart';

class LiveChatSdkChannel extends LiveChatSDKPlatform {
  @override
  Widget entryPoint({
    Widget? customFloatingWidget,
  }) {
    return ChatButtonWidget(
      customFloatingWidget: customFloatingWidget,
    );
  }
}
