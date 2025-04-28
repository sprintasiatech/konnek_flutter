import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:konnek_flutter/src/data/models/response/get_config_response_model.dart';
import 'package:konnek_flutter/src/data/models/response/get_conversation_response_model.dart';
import 'package:konnek_flutter/src/data/source/local/chat_local_source.dart';
import 'package:konnek_flutter/src/presentation/controller/app_controller.dart';
import 'package:konnek_flutter/src/support/app_file_helper.dart';
import 'package:konnek_flutter/src/support/app_image_picker.dart';
import 'package:konnek_flutter/src/support/app_logger.dart';

class ChatBubbleWidget extends StatefulWidget {
  final ConversationList data;
  final DataGetConfig? dataGetConfig;
  final void Function(String srcImage)? openImageCallback;

  const ChatBubbleWidget({
    required this.data,
    required this.dataGetConfig,
    this.openImageCallback,
    super.key,
  });

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  // String getUrlName(String payload) {
  //   AppLoggerCS.debugLog("widget.data.payload: ${widget.data.payload}");
  //   String data = jsonDecode(widget.data.payload ?? "")['url'];
  //   AppLoggerCS.debugLog("getUrlName: $data");
  //   return data;
  // }

  // String getFileNameFromUrl(String payload) {
  //   String data = (jsonDecode(widget.data.payload ?? "")['url'] as String).split("/").last;
  //   return data;
  // }

  bool chatCategoryValidation(ConversationList datas) {
    // Map<String, dynamic>? userData = await ChatLocalSource().getClientData();
    String name = "";
    String username = "";
    // if (userData != null) {
    name = AppController.nameUser;
    username = AppController.usernameUser;
    // AppLoggerCS.debugLog("AppController.nameUser ${AppController.nameUser}");
    // AppLoggerCS.debugLog("AppController.usernameUser ${AppController.usernameUser}");

    // }
    // if (datas.session?.agent?.id == "00000000-0000-0000-0000-000000000000" && datas.fromType == "1" && datas.user?.name == AppController.nameUser) {
    // if (datas.session?.agent?.id == "00000000-0000-0000-0000-000000000000" && datas.fromType == "1") {
    // if (!(datas.user?.name == name) && !(datas.user?.username == username)) {
    //  if (datas.createdBy == name) {
    // if (datas.user?.name == AppController.nameUser && datas.user?.username == AppController.usernameUser) {
    if (datas.fromType == "1") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chatCategoryValidation(widget.data)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(width: 10),
          Flexible(
            child: InkWell(
              onTap: () {
                AppLoggerCS.debugLog("call here");
                if (widget.data.payload != null || widget.data.payload != "") {
                  // if ((jsonDecode(widget.data.payload ?? "")['url'] as String).endsWith(".jpg") || (jsonDecode(widget.data.payload ?? "")['url'] as String).endsWith(".png")) {
                  // if (AppImagePickerServiceCS().isImageFile(getUrlName(widget.data.payload ?? ""))) {
                  widget.openImageCallback?.call(jsonDecode(widget.data.payload ?? "")['url']);
                  // }
                }
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // color: Colors.purpleAccent.shade200.withOpacity(0.3),
                  color: const Color(0xff2a55a4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.data.payload != null && widget.data.payload != "")
                      if (AppImagePickerServiceCS().isImageFile(AppFileHelper.getFileNameFromUrl(widget.data.payload!))) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                // "https://cms.shootingstar.id/74/main.jpg",
                                // jsonDecode(widget.data.payload ?? "")['url'],
                                AppFileHelper.getUrlName(widget.data.payload ?? ""),
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              // "${widget.data.payload}",
                              AppFileHelper.getFileNameFromUrl(widget.data.payload ?? ""),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.lato(
                                color: Colors.black45,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ] else ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Icon(
                                Icons.file_copy_rounded,
                                size: 60,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              // "${widget.data.payload}",
                              AppFileHelper.getFileNameFromUrl(widget.data.payload ?? ""),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.lato(
                                color: Colors.black45,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ],
                    Text(
                      // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
                      widget.data.text ?? "null",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      // "15:29",
                      // "${DateTime.now().hour}:${DateTime.now().minute}",
                      DateFormat("hh:mm").format(widget.data.messageTime!.toLocal()),
                      style: GoogleFonts.lato(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(width: 10),
          // Column(
          //   children: [
          //     SizedBox(height: 5),
          //     CircleAvatar(
          //       backgroundColor: Colors.purpleAccent,
          //       child: Text("FM"),
          //     ),
          //   ],
          // ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(width: 10),
          Column(
            children: [
              SizedBox(height: 5),
              (widget.dataGetConfig != null)
                  ? Image.memory(
                      Uri.parse(widget.dataGetConfig!.avatarImage!).data!.contentAsBytes(),
                      // base64Decode(dataGetConfig!.avatarImage!),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      child: Text("SZ"),
                    ),
            ],
          ),
          SizedBox(width: 10),
          Flexible(
            child: InkWell(
              onTap: () {
                AppLoggerCS.debugLog("call here 2");
                if (widget.data.payload != null || widget.data.payload != "") {
                  // if ((jsonDecode(widget.data.payload ?? "")['url'] as String).endsWith(".jpg") || (jsonDecode(widget.data.payload ?? "")['url'] as String).endsWith(".png")) {
                  // if (AppImagePickerServiceCS().isImageFile(getUrlName(widget.data.payload ?? ""))) {
                  widget.openImageCallback?.call(jsonDecode(widget.data.payload ?? "")['url']);
                  // }
                }
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // color: Colors.purpleAccent.shade200.withOpacity(0.3),
                  color: const Color(0xff203080).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.data.payload != null && widget.data.payload != "")
                      if (AppImagePickerServiceCS().isImageFile(AppFileHelper.getFileNameFromUrl(widget.data.payload!))) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                // "https://cms.shootingstar.id/74/main.jpg",
                                // jsonDecode(widget.data.payload ?? "")['url'],
                                AppFileHelper.getUrlName(widget.data.payload ?? ""),
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              // "${widget.data.payload}",
                              AppFileHelper.getFileNameFromUrl(widget.data.payload ?? ""),
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                color: Colors.black45,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ] else ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Icon(
                                Icons.file_copy_sharp,
                                color: Colors.grey.shade800,
                                size: 60,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              // "${widget.data.payload}",
                              AppFileHelper.getFileNameFromUrl(widget.data.payload ?? ""),
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                color: Colors.black45,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ],
                    Text(
                      widget.data.text ?? "null",
                      // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      // "15:29",
                      "${DateTime.now().hour}:${DateTime.now().minute}",
                      style: GoogleFonts.lato(
                        color: Colors.black45,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
