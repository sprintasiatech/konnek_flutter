import 'konnek_flutter_platform_interface.dart';
import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:konnek_flutter/src/env.dart';

// export 'package:konnek_flutter/export.dart';
export 'package:konnek_flutter/src/presentation/widget/live_chat_sdk_screen.dart';
export 'package:konnek_flutter/src/env.dart';

class KonnekFlutter {
  static String clientId = "";
  static String clientSecret = "";

  static String accessToken = "";

  static FamCodingSupply famCodingSupply = FamCodingSupply();
  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  Future<String?> getPlatformVersion() {
    return KonnekFlutterPlatform.instance.getPlatformVersion();
  }

  Future<String?> initialize(String flavor) {
    return KonnekFlutterPlatform.instance.initialize(flavor);
  }

  Future<String?> getConfig(String clientId) {
    return KonnekFlutterPlatform.instance.getConfig(clientId);
  }

  Future<String?> sendChat(Map<String, dynamic> data) {
    return KonnekFlutterPlatform.instance.sendChat(data);
  }

  Future<String?> getConversation(Map<String, dynamic> data) {
    return KonnekFlutterPlatform.instance.getConversation(data);
  }

  Future<String?> uploadMedia(Map<String, dynamic> data) {
    return KonnekFlutterPlatform.instance.uploadMedia(data);
  }

  Future<void> initKonnek({
    required String inputClientId,
    required String inputClientSecret,
    Flavor? flavor,
  }) async {
    clientId = inputClientId;
    clientSecret = inputClientSecret;

    // await LiveChatSdk().initialize();
    AppLoggerCS.useLogger = true;
    //
    appApiService.useFoundation = true;
    appApiService.useLogger = true;
    //
    EnvironmentConfig.flavor = flavor ?? Flavor.staging;
    String? result = await initialize(EnvironmentConfig.flavor.name);
    AppLoggerCS.debugLog("value methodChannel: $result");

    await famCodingSupply.appInfo.init();
    await famCodingSupply.appConnectivityService.init();
    await famCodingSupply.appDeviceInfo.getDeviceData();
    await famCodingSupply.localServiceHive.init();
  }

  // Widget entryPointWidget() {
  //   return KonnekFlutterPlatform.instance.entryPointWidget();
  // }
}
