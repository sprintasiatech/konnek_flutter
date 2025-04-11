library flutter_plugin_test2;

import 'flutter_plugin_test2_platform_interface.dart';

export 'package:flutter_plugin_test2/export.dart';
export 'package:flutter_plugin_test2/flutter_plugin_test2.dart';

class FlutterPluginTest2 {
  static String? clientId;
  static String? clientSecret;

  Future<String?> getPlatformVersion() {
    return FlutterPluginTest2Platform.instance.getPlatformVersion();
  }

  Future<void> initialize({
    String? clientId,
    String? clientSecret,
    dynamic configuration,
  }) async {
    clientId = clientId;
    clientSecret = clientSecret;
  }

  // Widget entryPointWidget() {
  //   return FlutterPluginTest2Platform.instance.entryPointWidget();
  // }
}
