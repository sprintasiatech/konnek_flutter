import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:konnek_flutter/konnek_flutter.dart';
import 'package:konnek_flutter/src/data/models/request/send_chat_request_model.dart';
import 'package:konnek_flutter/src/data/models/response/get_config_response_model.dart';
import 'package:konnek_flutter/src/data/models/response/get_conversation_response_model.dart';
import 'package:konnek_flutter/src/data/models/response/send_chat_response_model.dart';
import 'package:konnek_flutter/src/data/models/response/socket_chat_response_model.dart';
import 'package:konnek_flutter/src/data/models/response/socket_chat_status_response_model.dart';
import 'package:konnek_flutter/src/data/models/response/upload_media_response_model.dart';
import 'package:konnek_flutter/src/data/repositories/chat_repository_impl.dart';
import 'package:konnek_flutter/src/data/source/local/chat_local_source.dart';
import 'package:konnek_flutter/src/support/app_logger.dart';
import 'package:konnek_flutter/src/support/app_socketio_service.dart';
import 'package:konnek_flutter/src/support/jwt_converter.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:uuid/uuid.dart';

class AppController {
  static bool isLoading = false;

  static bool socketReady = false;

  static void clear() {
    nameUser = "";
    usernameUser = "";
    currentPage = 1;
    limit = 20;
    conversationData = null;
    conversationList = [];
  }

  Future<void> startWebSocketIO({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      AppLoggerCS.debugLog("[AppController][startWebSocketIO] called");
      io.Socket? data = ChatRepositoryImpl().startWebSocketIO();
      onSuccess?.call();
    } catch (e) {
      AppLoggerCS.debugLog('[startWebSocketIO] e: $e');
      onFailed?.call(e.toString());
    }
  }

  void listenToMessages(String eventName, Function(dynamic) onMessage) {
    AppSocketioService.socket.on(
      // 'new_message',
      eventName,
      (data) {
        onMessage(data); // callback
      },
    );
  }

  void sendMessage(String eventName, Map<String, dynamic> message) {
    AppSocketioService.socket.emit(
      // 'send_message',
      eventName,
      message,
    );
  }

  static void Function() onSocketChatCalled = () {};
  static void Function() onSocketChatStatusCalled = () {};

  Future<void> handleWebSocketIO({
    // void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      // AppSocketioService.socket.onConnect((_) {
      //   AppLoggerCS.debugLog("onConnect: ${AppSocketioService.socket.toString()}");
      // });

      AppSocketioService.socket.on("chat", (output) async {
        AppLoggerCS.debugLog("socket output: ${jsonEncode(output)}");
        SocketChatResponseModel socket = SocketChatResponseModel.fromJson(output);

        ConversationList? chatModel;
        chatModel = null;
        // AppLoggerCS.debugLog("socket.customer?.username: ${socket.customer?.username}");
        // AppLoggerCS.debugLog("socket.customer?.name: ${socket.customer?.name}");

        chatModel = ConversationList(
          // widget.data.session?.agent?.id
          session: SessionGetConversation(
            agent: UserGetConversation(
              id: socket.agent?.userId,
              name: socket.agent?.name,
              username: socket.agent?.username,
            ),
          ),
          fromType: socket.message?.fromType,
          text: socket.message?.text,
          messageId: socket.messageId,
          user: UserGetConversation(
            id: socket.customer?.userId,
            username: socket.customer?.username,
            name: socket.customer?.name,
          ),
          messageTime: socket.message?.time,
          sessionId: socket.session?.id,
          roomId: socket.session?.roomId,
          replyId: socket.replyId,
          payload: socket.message?.payload,
          type: socket.message?.type,
        );
        conversationList.add(chatModel);
        // onSuccess?.call();
        onSocketChatCalled.call();
      });

      AppSocketioService.socket.on("chat.status", (output) async {
        AppLoggerCS.debugLog("socket chat.status output: ${jsonEncode(output)}");
        SocketChatStatusResponseModel socket = SocketChatStatusResponseModel.fromJson(output);
        conversationList = conversationList.map((element) {
          if (element.messageId == socket.data?.messageId) {
            element.status = socket.data?.status;
            return element;
          } else {
            return element;
          }
        }).toList();
        onSocketChatStatusCalled.call();
      });
    } catch (e) {
      AppLoggerCS.debugLog('[handleWebSocketIO] e: $e');
      onFailed?.call(e.toString());
    }
  }

  Future<void> getConfig({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      // bool? valueSocketReady = await ChatLocalSource().getSocketReady();
      // if (valueSocketReady != null) {
      //   AppController.socketReady = valueSocketReady;
      // } else {
      //   AppController.socketReady = false;
      // }

      AppController.socketReady = false;

      GetConfigResponseModel? getConfigResponseModel = await ChatRepositoryImpl().getConfig(
        clientId: KonnekFlutter.clientId,
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

  static String nameUser = "";
  static String usernameUser = "";

  Future<void> loadData({
    required String name,
    required String email,
  }) async {
    isLoading = true;
    try {
      nameUser = name;
      usernameUser = email;
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

  static bool isWebSocketStart = false;

  Future<void> sendChat({
    String? text,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
    void Function(MetaSendChat value)? onGreetingsFailed,
    void Function()? onChatSentFirst,
  }) async {
    isLoading = true;
    try {
      Map<String, dynamic>? localDataFormatted = await ChatLocalSource().getClientData();

      String uuid = const Uuid().v4();
      ConversationList? chatModel0;
      chatModel0 = null;
      chatModel0 = ConversationList(
        fromType: "1",
        text: text,
        messageId: uuid,
        messageTime: DateTime.now().toUtc(),
      );
      conversationList.add(chatModel0);
      onChatSentFirst?.call();

      SendChatRequestModel requestBody = SendChatRequestModel(
        name: localDataFormatted?["name"],
        text: text,
        username: localDataFormatted?["username"],
      );

      SendChatResponseModel? output = await ChatRepositoryImpl().sendChat(
        clientId: KonnekFlutter.clientId,
        request: requestBody,
      );
      // AppLoggerCS.debugLog("output: ${output?.toJson()}");
      if (output == null) {
        onFailed?.call("empty data #1110");
        return;
      }
      if (output.meta == null) {
        onFailed?.call("empty data #1111");
        return;
      }
      if (output.meta?.code == 403) {
        String uuid = const Uuid().v4();
        ConversationList? chatModel;
        chatModel = null;

        chatModel = ConversationList(
          fromType: "2",
          text: "${output.meta?.message}",
          messageId: uuid,
          messageTime: DateTime.now().toUtc(),
        );
        conversationList.add(chatModel);
        onGreetingsFailed?.call(output.meta!);
        return;
      }
      if (output.meta?.code != 200) {
        onFailed?.call("${output.meta?.message}");
        return;
      }
      if (output.meta?.code == 200) {
        Map jwtValue = JwtConverter().decodeJwt(output.data!.token!);
        // AppLoggerCS.debugLog("jwtValue: ${jsonEncode(jwtValue)}");

        await ChatLocalSource().setSupportData(output.data!);

        KonnekFlutter.accessToken = output.data!.token!;
        await ChatLocalSource().setAccessToken(output.data!.token!);

        if (!isWebSocketStart) {
          await startWebSocketIO();
          await handleWebSocketIO();
          isWebSocketStart = true;
        }

        String uuid = const Uuid().v4();
        AppSocketioService.socket.emit(
          "chat",
          {
            "message_id": uuid,
            "reply_id": null,
            "ttl": 5,
            "text": "text",
            "time": getDateTimeFormatted(),
            "type": text,
            "room_id": jwtValue["payload"]["data"]["room_id"],
            "session_id": jwtValue["payload"]["data"]["session_id"],
            "channel_code": checkPlatform(),
            "reply_token": "",
            "from_type": 1,
            // "data": {
            //   {
            //     "message_id": uuid,
            //     "reply_id": null,
            //     "ttl": 5,
            //     "text": "write",
            //     "time": getDateTimeFormatted(),
            //     "type": "text",
            //     "room_id": jwtValue["payload"]["data"]["room_id"],
            //     "session_id": jwtValue["payload"]["data"]["session_id"],
            //     "channel_code": checkPlatform(),
            //     "reply_token": "",
            //     "from_type": 1,
            //   },
            // },
          },
        );

        conversationData = null;
        conversationList = [];
        currentPage = 1;

        await _getConversation(
          roomId: jwtValue["payload"]["data"]["room_id"],
          onSuccess: () async {
            AppLoggerCS.debugLog("conversationList.last: ${jsonEncode(conversationList.last)}");
            if (isWebSocketStart) {
              AppSocketioService.socket.emit(
                "chat.status",
                {
                  "data": {
                    "message_id": conversationList.first.messageId,
                    "room_id": conversationList.first.roomId,
                    "session_id": conversationList.first.sessionId,
                    "status": 2,
                    "times": (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
                    "timestamp": getDateTimeFormatted(),
                  },
                },
              );
              isWebSocketStart = true;
            }
            onSuccess?.call();
          },
          onFailed: (errorMessage) {
            onFailed?.call(errorMessage);
          },
        );
        return;
      }
    } catch (e) {
      AppLoggerCS.debugLog("[sendChat] error: $e");
      onFailed?.call(e.toString());
      isLoading = false;
    }
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

  String getDateTimeFormatted() {
    String date1 = DateFormat("yyyy-MM-dd").format(DateTime.now());
    // AppLoggerCS.debugLog("date1: $date1");
    String time1 = DateFormat("hh:mm:ss.").format(DateTime.now());
    // AppLoggerCS.debugLog("time1: $time1");
    String concatDateTime = "${date1}T${time1}992Z";
    AppLoggerCS.debugLog("concatDateTime: $concatDateTime");
    return concatDateTime;
  }

  static GetConversationResponseModel? conversationData;
  static List<ConversationList> conversationList = [];

  List<ConversationList> removeDuplicatesById(List<ConversationList> originalList) {
    final seenIds = <String>{};
    return originalList.where((item) {
      final isNew = !seenIds.contains(item.messageId);
      seenIds.add(item.messageId!);
      return isNew;
    }).toList();
  }

  Future<void> _getConversation({
    // String? text,
    required String roomId,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading = true;
    try {
      DataSendChat? supportData = await ChatLocalSource().getSupportData();
      if (supportData == null) {
        onFailed?.call("process 2 don't success");
        return;
      }

      GetConversationResponseModel? output = await ChatRepositoryImpl().getConversation(
        limit: limit,
        roomId: roomId,
        currentPage: currentPage,
        sessionId: supportData.sessionId ?? "",
      );
      // AppLoggerCS.debugLog("[_getConversation] output ${jsonEncode(output?.meta?.toJson())}");
      if (output == null) {
        onFailed?.call("empty data #1110");
        return;
      }
      if (output.meta == null) {
        onFailed?.call("empty data #1111");
        return;
      }
      if (output.meta?.code != 200) {
        onFailed?.call("${output.meta?.message}");
        return;
      }

      conversationData = output;
      conversationList.addAll(output.data!.conversations!);
      conversationList = removeDuplicatesById(conversationList);
      // conversationList = conversationList.reversed.toList();

      KonnekFlutter.accessToken = output.data!.token!;
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
    try {
      if (conversationData != null && conversationData!.meta != null) {
        if (currentPage <= conversationData!.meta!.pageCount!) {
          currentPage++;
          Map<String, dynamic>? decodeJwt = await _decodeJwt();

          await _getConversation(
            roomId: decodeJwt!["payload"]["data"]["room_id"],
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
        Map<String, dynamic>? decodeJwt = await _decodeJwt();

        conversationData = null;
        conversationList = [];
        currentPage = 1;

        await _getConversation(
          roomId: decodeJwt!["payload"]["data"]["room_id"],
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

  Future<Map<String, dynamic>?> _decodeJwt({
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      String? token = await ChatLocalSource().getAccessToken();
      if (token == null) {
        onFailed?.call("process don't success");
        return null;
      }

      Map<String, dynamic> decodeJwt = JwtConverter().decodeJwt(token);
      // AppLoggerCS.debugLog("[_decodeJwt] $decodeJwt");
      return decodeJwt;
    } catch (e) {
      onFailed?.call("e: $e");
      return null;
    }
  }
}
