import 'package:flutter/material.dart';
import 'package:konnek_flutter/src/presentation/interface/live_chat_sdk_platform.dart';

import '../widget/chat_button_widget.dart';
// import 'package:konnek_flutter/widget/chat_button_widget.dart';

class LiveChatSdkChannel extends LiveChatSDKPlatform {
  @override
  Widget entryPoint({
    Widget? customFloatingWidget,
  }) {
    return ChatButtonWidget(
      customFloatingWidget: customFloatingWidget,
    );
  }

  // @override
  // Future<void> initialize() async {
  //   EnvironmentConfig.flavor = Flavor.staging;
  //   LocalServiceHive().init();
  // }
}
