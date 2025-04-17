import 'dart:convert';
import 'dart:io';

import 'package:fam_coding_supply/logic/app_logger.dart';
import 'package:flutter_plugin_test2/flutter_plugin_test2.dart';
import 'package:flutter_plugin_test2/src/data/models/request/send_chat_request_model.dart';
import 'package:flutter_plugin_test2/src/data/models/response/get_config_response_model.dart';
import 'package:flutter_plugin_test2/src/data/models/response/get_conversation_response_model.dart';
import 'package:flutter_plugin_test2/src/data/models/response/send_chat_response_model.dart';
import 'package:flutter_plugin_test2/src/data/models/response/upload_media_response_model.dart';
import 'package:flutter_plugin_test2/src/data/repositories/chat_repository_impl.dart';
import 'package:flutter_plugin_test2/src/data/source/local/chat_local_source.dart';
import 'package:flutter_plugin_test2/src/support/jwt_converter.dart';

class AppController {
  static bool isLoading = false;

  Future<void> getConfig({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      GetConfigResponseModel? getConfigResponseModel = await ChatRepositoryImpl().getConfig(
        clientId: FlutterPluginTest2.clientId,
      );
      if (getConfigResponseModel == null) {
        onFailed?.call("empty data");
        return;
      }

      if (getConfigResponseModel.meta == null || getConfigResponseModel.data == null) {
        onFailed?.call("empty data 2");
        return;
      }

      if (getConfigResponseModel.meta?.code != 200) {
        onFailed?.call("${getConfigResponseModel.meta?.message}");
        return;
      }

      if (getConfigResponseModel.meta?.code == 200) {
        dataGetConfigValue = getConfigResponseModel.data;
        await ChatLocalSource().setConfigData(getConfigResponseModel.data!);
        onSuccess?.call();
        return;
      }
    } catch (e) {
      onFailed?.call(e.toString());
      return;
    }
  }

  static DataGetConfig? dataGetConfigValue;

  Future<void> getConfigFromLocal({
    void Function(DataGetConfig data)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      DataGetConfig? data = await ChatLocalSource().getConfigData();
      if (data == null) {
        onFailed?.call("empty data");
        return;
      }
      dataGetConfigValue = data;

      onSuccess?.call(data);
      return;
    } catch (e) {
      onFailed?.call(e.toString());
      return;
    }
  }

  Future<void> loadData({
    required String name,
    required String email,
  }) async {
    isLoading = true;
    try {
      await ChatLocalSource()
          .setClientData(
        name: name,
        email: email,
      )
          .then((_) {
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
    }
  }

  Future<void> sendChat({
    String? text,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading = true;

    AppLoggerCS.debugLog("work here");
    try {
      conversationData = null;
      conversationList = [];
      currentPage = 1;

      Map<String, dynamic>? localDataFormatted = await ChatLocalSource().getClientData();
      AppLoggerCS.debugLog("localDataFormatted: $localDataFormatted");

      SendChatRequestModel requestBody = SendChatRequestModel(
        name: localDataFormatted?["name"],
        text: text,
        username: localDataFormatted?["username"],
      );
      AppLoggerCS.debugLog("requestBody: ${requestBody.toJson()}");

      AppLoggerCS.debugLog("FlutterPluginTest2.clientId: ${FlutterPluginTest2.clientId}");

      SendChatResponseModel? output = await ChatRepositoryImpl().sendChat(
        clientId: FlutterPluginTest2.clientId,
        request: requestBody,
      );
      AppLoggerCS.debugLog("output: $output");

      Map jwtValue = JwtConverter().decodeJwt(output!.data!.token!);
      // AppLoggerCS.debugLog("jwtValue: ${jsonEncode(jwtValue)}");

      await ChatLocalSource().setSupportData(output.data!);

      FlutterPluginTest2.accessToken = output.data!.token!;
      await ChatLocalSource().setAccessToken(output.data!.token!);

      await _getConversation(
        text: text,
        roomId: jwtValue["payload"]["data"]["room_id"],
        onSuccess: () {
          onSuccess?.call();
        },
        onFailed: (errorMessage) {
          onFailed?.call(errorMessage);
        },
      );
    } catch (e) {
      AppLoggerCS.debugLog("[sendChat] error: $e");
      onFailed?.call(e.toString());
      isLoading = false;
    }
  }

  static GetConversationResponseModel? conversationData;
  static List<ConversationList> conversationList = [];

  Future<void> _getConversation({
    String? text,
    required String roomId,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading = true;
    try {
      String? token = await ChatLocalSource().getAccessToken();
      if (token == null) {
        onFailed?.call("process don't success");
        return;
      }

      // Map<String, dynamic> decodeJwt = JwtConverter().decodeJwt(token);
      // AppLoggerCS.debugLog("[_getConversation] decodeJwt $decodeJwt");

      DataSendChat? supportData = await ChatLocalSource().getSupportData();
      if (supportData == null) {
        onFailed?.call("process 2 don't success");
        return;
      }

      GetConversationResponseModel? output = await ChatRepositoryImpl().getConversation(
        limit: limit,
        roomId: roomId,
        currentPage: currentPage,
        sesionId: supportData.sessionId ?? "",
      );
      AppLoggerCS.debugLog("[_getConversation] output ${jsonEncode(output?.meta?.toJson())}");

      conversationData = output;
      conversationList.addAll(output!.data!.conversations!);
      // conversationList = conversationList.reversed.toList();

      FlutterPluginTest2.accessToken = output.data!.token!;
      await ChatLocalSource().setAccessToken(output.data!.token!);

      isLoading = false;
      onSuccess?.call();
    } catch (e) {
      AppLoggerCS.debugLog("[_getConversation] error: $e");
      isLoading = false;
      onFailed?.call(e.toString());
    }
  }

  static int currentPage = 1;
  static int limit = 20;

  Future<void> loadMoreConversation({
    String? text,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    AppLoggerCS.debugLog("call here [loadMoreConversation]");
    try {
      if (conversationData != null && conversationData!.meta != null) {
        if (currentPage <= conversationData!.meta!.pageCount!) {
          currentPage++;
          String? token = await ChatLocalSource().getAccessToken();
          if (token == null) {
            onFailed?.call("process don't success");
            return;
          }

          Map<String, dynamic> decodeJwt = JwtConverter().decodeJwt(token);
          AppLoggerCS.debugLog("[loadMoreConversation] decodeJwt $decodeJwt");

          await _getConversation(
            text: text,
            roomId: decodeJwt["payload"]["data"]["room_id"],
            onSuccess: () {
              isLoading = false;
              onSuccess?.call();
            },
            onFailed: (errorMessage) {
              isLoading = false;
              onFailed?.call(errorMessage);
            },
          );
        } else {
          onSuccess?.call();
        }
      }
    } catch (e) {
      AppLoggerCS.debugLog("[loadMoreConversation] error: $e");
      isLoading = false;
      onFailed?.call(e.toString());
    }
  }

  Future<void> uploadMedia({
    required String? text,
    required File mediaData,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      UploadFilesResponseModel? output = await ChatRepositoryImpl().uploadMedia(
        text: text,
        mediaData: mediaData.path,
      );
      AppLoggerCS.debugLog("[uploadMedia] output ${jsonEncode(output?.meta?.toJson())}");

      if (output == null) {
        onFailed?.call("empty data");
        return;
      }

      if (output.meta == null) {
        onFailed?.call("empty data 2");
        return;
      }

      if (output.meta?.code != 201) {
        onFailed?.call("${output.meta?.message}");
        return;
      }

      if (output.meta?.code == 201) {
        // onSuccess?.call();
        // return;

        String? token = await ChatLocalSource().getAccessToken();
        if (token == null) {
          onFailed?.call("process don't success");
          return;
        }
        Map<String, dynamic> decodeJwt = JwtConverter().decodeJwt(token);
        AppLoggerCS.debugLog("[loadMoreConversation] decodeJwt $decodeJwt");

        conversationData = null;
        conversationList = [];
        currentPage = 1;

        await _getConversation(
          text: text,
          roomId: decodeJwt["payload"]["data"]["room_id"],
          onSuccess: () {
            isLoading = false;
            onSuccess?.call();
          },
          onFailed: (errorMessage) {
            isLoading = false;
            onFailed?.call(errorMessage);
          },
        );
      }
    } catch (e) {
      onFailed?.call(e.toString());
      return;
    }
  }
}
