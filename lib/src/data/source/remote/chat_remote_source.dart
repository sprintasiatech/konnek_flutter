import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter_plugin_test2/flutter_plugin_test2.dart';
import 'package:flutter_plugin_test2/src/data/models/request/send_chat_request_model.dart';
import 'package:flutter_plugin_test2/src/env.dart';

abstract class ChatRemoteSource {
  Future<Response?> sendChat({
    required String clientId,
    required SendChatRequestModel request,
  });
  Future<Response?> getConversation({
    required int limit,
    required String roomId,
    required int currentPage,
    required String sesionId,
  });
  Future<Response?> getConfig({
    required String clientId,
  });
  Future<Response?> uploadMedia({
    required Map<String, dynamic> requestData,
  });
}

class ChatRemoteSourceImpl extends ChatRemoteSource {
  static String baseUrl = EnvironmentConfig.baseUrl();
  static AppApiServiceCS apiService = FlutterPluginTest2.appApiService;

  @override
  Future<Response?> getConfig({required String clientId}) async {
    try {
      String url = "$baseUrl/channel/config/$clientId/web";
      Response? response = await apiService.call(
        url,
        method: MethodRequestCS.get,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response?> getConversation({
    required int limit,
    required String roomId,
    required int currentPage,
    required String sesionId,
  }) async {
    try {
      AppLoggerCS.debugLog("[remoteSource] currentPage: $currentPage");
      AppLoggerCS.debugLog("baseUrl: $baseUrl");
      String url = "$baseUrl/room/conversation/$roomId?page=$currentPage&limit=20&session_id=$sesionId";
      Response? response = await apiService.call(
        url,
        method: MethodRequestCS.get,
        header: {
          // 'Authorization': accessToken,
          'Authorization': FlutterPluginTest2.accessToken,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response?> sendChat({
    required String clientId,
    required SendChatRequestModel request,
  }) async {
    try {
      AppLoggerCS.debugLog("baseUrl: $baseUrl");
      String url = "$baseUrl/webhook/widget/$clientId";
      Response? response = await apiService.call(
        url,
        request: request.toJson(),
        method: MethodRequestCS.post,
      );
      return response;
    } catch (e) {
      AppLoggerCS.debugLog("[ChatRemoteSourceImpl][sendChat] error: $e");
      rethrow;
    }
  }

  @override
  Future<Response?> uploadMedia({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      String url = "$baseUrl/chat/media";
      Response? response = await apiService.call(
        url,
        header: {
          "Access-Control-Allow-Origin": "*",
          'Authorization': FlutterPluginTest2.accessToken,
          // 'Authorization': accessToken,
        },
        request: requestData,
        method: MethodRequestCS.post,
        useFormData: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
