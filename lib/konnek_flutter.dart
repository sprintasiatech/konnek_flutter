import 'package:konnek_flutter/src/support/app_api_service.dart';
import 'package:konnek_flutter/src/support/app_connectivity_service.dart';
import 'package:konnek_flutter/src/support/app_device_info.dart';
import 'package:konnek_flutter/src/support/app_info.dart';
import 'package:konnek_flutter/src/support/app_logger.dart';
import 'package:konnek_flutter/src/support/local_service_hive.dart';

import 'konnek_flutter_platform_interface.dart';
import 'package:konnek_flutter/src/env.dart';

// export 'package:konnek_flutter/export.dart';
export 'package:konnek_flutter/src/presentation/widget/live_chat_sdk_screen.dart';
export 'package:konnek_flutter/src/env.dart';

class KonnekFlutter {
  static String clientId = "";
  static String clientSecret = "";

  static String accessToken = "";

  // static FamCodingSupply famCodingSupply = FamCodingSupply();
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

  static AppConnectivityServiceCS appConnectivityServiceCS = AppConnectivityServiceCS();
  static AppDeviceInfoCS appDeviceInfo = AppDeviceInfoCS();
  static AppInfoCS appInfoCS = AppInfoCS();
  static LocalServiceHive localServiceHive = LocalServiceHive();

  Future<void> initKonnek({
    required String inputClientId,
    required String inputClientSecret,
    Flavor? flavor,
  }) async {
    clientId = inputClientId;
    clientSecret = inputClientSecret;

    // await LiveChatSdk().initialize();
    AppLoggerCS.useLogger = false;
    //
    appApiService.useFoundation = false;
    appApiService.useLogger = false;
    //
    EnvironmentConfig.flavor = flavor ?? Flavor.staging;
    String? result = await initialize(EnvironmentConfig.flavor.name);
    AppLoggerCS.debugLog("value methodChannel: $result");

    await appInfoCS.init();
    await appConnectivityServiceCS.init();
    await appDeviceInfo.getDeviceData();
    await localServiceHive.init();
  }

  // Widget entryPointWidget() {
  //   return KonnekFlutterPlatform.instance.entryPointWidget();
  // }
}
