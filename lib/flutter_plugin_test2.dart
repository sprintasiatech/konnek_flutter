library flutter_plugin_test2;

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter_plugin_test2/src/env.dart';

import 'flutter_plugin_test2_platform_interface.dart';

// export 'package:flutter_plugin_test2/export.dart';
export 'package:flutter_plugin_test2/src/presentation/widget/live_chat_sdk_screen.dart';

class FlutterPluginTest2 {
  static String clientId = "";
  static String clientSecret = "";

  static String accessToken = "";

  static FamCodingSupply famCodingSupply = FamCodingSupply();
  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  Future<String?> getPlatformVersion() {
    return FlutterPluginTest2Platform.instance.getPlatformVersion();
  }

  Future<void> initialize({
    required String inputClientId,
    required String inputClientSecret,
    dynamic configuration,
  }) async {
    clientId = inputClientId;
    clientSecret = inputClientSecret;

    EnvironmentConfig.flavor = Flavor.staging;
    // await LiveChatSdk().initialize();
    AppLoggerCS.useLogger = true;
    await famCodingSupply.appInfo.init();
    await famCodingSupply.appConnectivityService.init();
    await famCodingSupply.appDeviceInfo.getDeviceData();
    await famCodingSupply.localServiceHive.init();
  }

  // Widget entryPointWidget() {
  //   return FlutterPluginTest2Platform.instance.entryPointWidget();
  // }
}
