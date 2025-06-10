import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:konnek_flutter/konnek_flutter.dart';
import 'package:konnek_flutter/src/data/models/request/send_chat_request_model.dart';
import 'package:konnek_flutter/src/data/models/response/get_config_response_model.dart';
import 'package:konnek_flutter/src/data/models/response/get_conversation_response_model.dart';
import 'package:konnek_flutter/src/data/models/response/send_chat_response_model.dart';
import 'package:konnek_flutter/src/data/models/response/upload_media_response_model.dart';
import 'package:konnek_flutter/src/data/source/remote/chat_remote_source.dart';
import 'package:konnek_flutter/src/domain/repository/chat_repository.dart';
import 'package:konnek_flutter/src/support/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:uuid/uuid.dart';

class ChatRepositoryImpl extends ChatRepository {
  static ChatRemoteSource remoteSource = ChatRemoteSourceImpl();

  @override
  io.Socket? startWebSocketIO() {
    try {
      io.Socket? socket = remoteSource.startWebSocketIO();
      return socket;
    } catch (e) {
      AppLoggerCS.debugLog("[ChatRepositoryImpl][startWebSocketIO] error: $e");
      rethrow;
    }
  }

  @override
  Future<GetConfigResponseModel?> getConfig({
    required String clientId,
  }) async {
    try {
      String? response = await KonnekFlutter().getConfig(clientId);
      if (response == null) {
        return null;
      }
      GetConfigResponseModel mapping = GetConfigResponseModel.fromJson(
        jsonDecode(response),
      );
      return mapping;
    } catch (e) {
      AppLoggerCS.debugLog("[ChatRepositoryImpl][getConfig] error: $e");
      rethrow;
    }
  }

  @override
  Future<GetConversationResponseModel?> getConversation({
    required int limit,
    required String roomId,
    required int currentPage,
    required String sessionId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "limit": "$limit",
        "roomId": roomId,
        "currentPage": "$currentPage",
        "sessionId": sessionId,
      };
      String? response = await KonnekFlutter().getConversation(data);
      if (response == null) {
        return null;
      }
      GetConversationResponseModel mapping = GetConversationResponseModel.fromJson(
        jsonDecode(response),
      );
      return mapping;
    } catch (e) {
      AppLoggerCS.debugLog("[ChatRepositoryImpl][getConversation] error: $e");
      rethrow;
    }
  }

  @override
  Future<UploadFilesResponseModel?> uploadMedia({
    String? text,
    String? mediaData,
  }) async {
    try {
      MultipartFile media = await MultipartFile.fromFile(
        '$mediaData',
        filename: mediaData.toString().split('/').last,
      );

      String uuid = const Uuid().v4();

      Map<String, dynamic> requestData = {
        "media": media,
        "message_id": uuid,
        "reply_id": "",
      };

      if (text != null) {
        requestData.addAll(
          {
            "text": text,
          },
        );
      }

      String date1 = DateFormat("yyyy-MM-dd").format(DateTime.now());
      String time1 = DateFormat("hh:mm:ss.").format(DateTime.now());
      String concatDateTime = "${date1}T${time1}992Z";

      requestData.addAll(
        {
          "time": concatDateTime,
        },
      );

      Map<String, dynamic> data = {
        "fileData": "$mediaData",
        "messageId": uuid,
        "replyId": "",
        "time": concatDateTime,
      };
      if (text != null) {
        data.addAll(
          {
            "text": text,
          },
        );
      }
      String? response = await KonnekFlutter().uploadMedia(data);
      if (response == null) {
        return null;
      }
      UploadFilesResponseModel mapping = UploadFilesResponseModel.fromJson(
        jsonDecode(response),
      );
      return mapping;
    } catch (e) {
      AppLoggerCS.debugLog("[ChatRepositoryImpl][uploadMedia] error: $e");
      rethrow;
    }
  }

  @override
  Future<SendChatResponseModel?> sendChat({
    required String clientId,
    required SendChatRequestModel request,
  }) async {
    try {
      Map<String, dynamic> reqData = {
        'clientId': clientId,
      };
      reqData.addAll(request.toJson());

      String? response = await KonnekFlutter().sendChat(reqData);
      if (response == null) {
        return null;
      }
      SendChatResponseModel mapping = SendChatResponseModel.fromJson(
        jsonDecode(response),
      );
      return mapping;
    } catch (e) {
      AppLoggerCS.debugLog("[ChatRepositoryImpl][sendChat] error: $e");
      rethrow;
    }
  }
}
