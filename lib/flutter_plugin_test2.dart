
import 'flutter_plugin_test2_platform_interface.dart';

export 'package:flutter_plugin_test2/export.dart';

class FlutterPluginTest2 {
  Future<String?> getPlatformVersion() {
    return FlutterPluginTest2Platform.instance.getPlatformVersion();
  }

  Future<void> initialize() async {
    // 
  }
}
