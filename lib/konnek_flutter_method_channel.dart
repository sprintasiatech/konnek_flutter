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
    final version = await methodChannel.invokeMethod<String>(
      'initialize',
      {
        'flavor': flavor,
      },
    );
    return version;
  }

  @override
  Future<String?> getConfig(String clientId) async {
    final version = await methodChannel.invokeMethod<String>(
      'getConfig',
      {
        'clientId': clientId,
      },
    );
    return version;
  }

  @override
  Future<String?> sendChat(Map<String, dynamic> data) async {
    final version = await methodChannel.invokeMethod<String>(
      'sendChat',
      data,
    );
    return version;
  }

  @override
  Future<String?> getConversation(Map<String, dynamic> data) async {
    final version = await methodChannel.invokeMethod<String>(
      'getConversation',
      data,
    );
    return version;
  }

  @override
  Future<String?> uploadMedia(Map<String, dynamic> data) async {
    final version = await methodChannel.invokeMethod<String>(
      'uploadMedia',
      data,
    );
    return version;
  }

  // @override
  // Widget entryPointWidget() {
  //   return ChatButtonWidget();
  // }
}
