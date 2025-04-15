import 'package:flutter_plugin_test2/src/data/models/request/send_chat_request_model.dart';
import 'package:flutter_plugin_test2/src/data/models/response/get_config_response_model.dart';
import 'package:flutter_plugin_test2/src/data/models/response/get_conversation_response_model.dart';
import 'package:flutter_plugin_test2/src/data/models/response/send_chat_response_model.dart';
import 'package:flutter_plugin_test2/src/data/models/response/upload_media_response_model.dart';

abstract class ChatRepository {
  Future<SendChatResponseModel?> sendChat({
    required String clientId,
    required SendChatRequestModel request,
  });
  Future<GetConversationResponseModel?> getConversation({
    required int pages,
    required String roomId,
    required int currentPage,
    required int sesionId,
  });
  Future<GetConfigResponseModel?> getConfig({
    required String clientId,
  });
  Future<UploadFilesResponseModel?> uploadMedia({
    String? text,
    String? mediaData,
  });
}
