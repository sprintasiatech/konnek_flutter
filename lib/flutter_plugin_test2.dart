
import 'flutter_plugin_test2_platform_interface.dart';

class FlutterPluginTest2 {
  Future<String?> getPlatformVersion() {
    return FlutterPluginTest2Platform.instance.getPlatformVersion();
  }
}
