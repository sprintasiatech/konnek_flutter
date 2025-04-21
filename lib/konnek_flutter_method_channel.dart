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

  // @override
  // Widget entryPointWidget() {
  //   return ChatButtonWidget();
  // }
}
