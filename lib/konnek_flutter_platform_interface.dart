import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'konnek_flutter_method_channel.dart';

abstract class KonnekFlutterPlatform extends PlatformInterface {
  /// Constructs a KonnekFlutterPlatform.
  KonnekFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static KonnekFlutterPlatform _instance = MethodChannelKonnekFlutter();

  /// The default instance of [KonnekFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelKonnekFlutter].
  static KonnekFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KonnekFlutterPlatform] when
  /// they register themselves.
  static set instance(KonnekFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> initialize(String flavor) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<String?> getConfig(String clientId) {
    throw UnimplementedError('getConfig() has not been implemented.');
  }

  Future<String?> sendChat(Map<String, dynamic> data) {
    throw UnimplementedError('sendChat() has not been implemented.');
  }

  Future<String?> getConversation(Map<String, dynamic> data) {
    throw UnimplementedError('getConversation() has not been implemented.');
  }

  Future<String?> uploadMedia(Map<String, dynamic> data) {
    throw UnimplementedError('getConversation() has not been implemented.');
  }
}
