import 'konnek_flutter_platform_interface.dart';
import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:konnek_flutter/src/env.dart';

// export 'package:konnek_flutter/export.dart';
export 'package:konnek_flutter/src/presentation/widget/live_chat_sdk_screen.dart';

class KonnekFlutter {
  static String clientId = "";
  static String clientSecret = "";

  static String accessToken = "";

  static FamCodingSupply famCodingSupply = FamCodingSupply();
  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  Future<String?> getPlatformVersion() {
    return KonnekFlutterPlatform.instance.getPlatformVersion();
  }

  Future<void> initialize({required String inputClientId, required String inputClientSecret, dynamic configuration}) async {
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
  //   return KonnekFlutterPlatform.instance.entryPointWidget();
  // }
}
