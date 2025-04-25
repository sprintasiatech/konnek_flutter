import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'konnek_flutter_platform_interface.dart';

/// An implementation of [KonnekFlutterPlatform] that uses method channels.
class MethodChannelKonnekFlutter extends KonnekFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('konnek_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> initialize(String flavor) async {
    Map<String, dynamic> data = {
      'flavor': flavor,
    };
    Map<String, dynamic> newData = checkPlatformWithData(data);
    final version = await methodChannel.invokeMethod<String>(
      'initialize',
      newData,
    );
    return version;
  }

  @override
  Future<String?> getConfig(String clientId) async {
    Map<String, dynamic> data = {
      'clientId': clientId,
    };
    Map<String, dynamic> newData = checkPlatformWithData(data);
    final version = await methodChannel.invokeMethod<String>(
      'getConfig',
      newData,
    );
    return version;
  }

  @override
  Future<String?> sendChat(Map<String, dynamic> data) async {
    Map<String, dynamic> newData = checkPlatformWithData(data);
    final version = await methodChannel.invokeMethod<String>(
      'sendChat',
      newData,
    );
    return version;
  }

  @override
  Future<String?> getConversation(Map<String, dynamic> data) async {
    Map<String, dynamic> newData = checkPlatformWithData(data);
    final version = await methodChannel.invokeMethod<String>(
      'getConversation',
      newData,
    );
    return version;
  }

  @override
  Future<String?> uploadMedia(Map<String, dynamic> data) async {
    Map<String, dynamic> newData = checkPlatformWithData(data);
    final version = await methodChannel.invokeMethod<String>(
      'uploadMedia',
      newData,
    );
    return version;
  }

  String checkPlatform() {
    String platform = "webhook";
    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    } else {
      platform = "web";
    }
    return platform;
  }

  Map<String, dynamic> checkPlatformWithData(Map<String, dynamic> data) {
    String platform = "web";
    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    } else {
      platform = "web";
    }
    Map<String, dynamic> newData = data;
    newData.addAll(
      {
        'platform': platform,
      },
    );
    return newData;
  }

  // @override
  // Widget entryPointWidget() {
  //   return ChatButtonWidget();
  // }
}
