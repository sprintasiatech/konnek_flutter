import 'dart:io';

import 'package:fam_coding_supply/logic/app_file_picker.dart';
import 'package:fam_coding_supply/logic/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_test2/assets/assets.dart';
import 'package:flutter_plugin_test2/src/data/models/response/get_config_response_model.dart';
import 'package:flutter_plugin_test2/src/data/models/response/get_conversation_response_model.dart';
import 'package:flutter_plugin_test2/src/presentation/controller/app_controller.dart';
import 'package:flutter_plugin_test2/src/presentation/widget/chat_bubble_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class ChatItem {}

// class ChatMessage extends ChatItem {
//   final String text;
//   final DateTime timestamp;

//   ChatMessage({required this.text, required this.timestamp});
// }

class DateSeparator extends ChatItem {
  final String label;

  DateSeparator(this.label);
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  TextEditingController textController = TextEditingController();
  bool isTextFieldFocused = false;
  bool isTextFieldEmpty = true;

  bool isLoading = false;

  DataGetConfig? dataGetConfig;

  // Sample data
  // final List<ChatMessage> _messages = [
  //   ChatMessage(text: 'Hey!', timestamp: DateTime.now().subtract(Duration(minutes: 5))),
  //   ChatMessage(text: 'How are you?', timestamp: DateTime.now().subtract(Duration(minutes: 4))),
  //   ChatMessage(text: 'Yesterday\'s message', timestamp: DateTime.now().subtract(Duration(days: 1, minutes: 10))),
  //   ChatMessage(text: 'Another one from yesterday', timestamp: DateTime.now().subtract(Duration(days: 1, minutes: 5))),
  //   ChatMessage(text: 'Old one', timestamp: DateTime.now().subtract(Duration(days: 3))),
  // ];

  late List<ChatItem> _chatItems;

  @override
  void initState() {
    super.initState();
    // Jump to bottom after the widget is built
    // _chatItems = buildChatListWithSeparators(_messages);
    _chatItems = buildChatListWithSeparators(AppController.conversationList);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollToBottom();
      await AppController().getConfigFromLocal(
        onSuccess: (data) {
          // AppLoggerCS.debugLog("[getConfigFromLocal] onSuccess: ${jsonEncode(data.toJson())}");
          setState(() {
            dataGetConfig = data;
          });
        },
        onFailed: (errorMessage) {
          AppLoggerCS.debugLog("[getConfigFromLocal] onFailed: $errorMessage");
        },
      );
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  RefreshController refreshController = RefreshController(initialRefresh: false);

  List<ChatItem> buildChatListWithSeparators(List<ConversationList> messages) {
    messages.sort((a, b) => a.messageTime!.compareTo(b.messageTime!)); // optional: sort oldest to newest
    // List<ChatItem> result = [];
    List<ChatItem> result = [];

    for (int i = 0; i < messages.length; i++) {
      final current = messages[i];
      final previous = i > 0 ? messages[i - 1] : null;

      if (previous == null || !isSameDate(current.messageTime!, previous.messageTime!)) {
        result.add(DateSeparator(formatDate(current.messageTime!)));
      }

      result.add(current);
    }

    return result;
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) return "Today";
    if (msgDate == yesterday) return "Yesterday";
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return months[month];
  }

  File? uploadFile;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        isLoading = false;
        setState(() {});
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  forceMaterialTransparency: true,
                  leadingWidth: 70,
                  leading: Center(
                    child: (dataGetConfig != null)
                        ? Image.memory(
                            Uri.parse(dataGetConfig!.avatarImage!).data!.contentAsBytes(),
                            // base64Decode(dataGetConfig!.avatarImage!),
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : Text(
                            "App!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    // child: Text(
                    //   "App!",
                    //   textAlign: TextAlign.center,
                    //   style: GoogleFonts.inter(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                  ),
                  centerTitle: false,
                  title: Text(
                    (dataGetConfig != null) ? "${dataGetConfig?.avatarName}" : "Bot Cust Service 1",
                    style: GoogleFonts.inter(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 28,
                        ),
                      ),
                    )
                  ],
                ),
                body: SmartRefresher(
                  reverse: true,
                  controller: refreshController,
                  enablePullUp: true,
                  enablePullDown: false,
                  onLoading: () async {
                    await AppController().loadMoreConversation(
                      onSuccess: () {
                        // refreshController.loadComplete();
                        _chatItems = buildChatListWithSeparators(AppController.conversationList);
                        setState(() {});
                      },
                      onFailed: (errorMessage) {
                        // refreshController.loadComplete();
                        setState(() {});
                      },
                    ).then((value) {
                      refreshController.loadComplete();
                    });
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          if (isLoading) ...[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.black38,
                              child: Center(
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ] else ...[
                            // ListView.separated(
                            //   reverse: true,
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   shrinkWrap: true,
                            //   itemCount: (AppController.conversationList.isEmpty) ? 0 : AppController.conversationList.length,
                            //   padding: EdgeInsets.all(0),
                            //   itemBuilder: (context, index) {
                            //     var data = AppController.conversationList[index];
                            //     return ChatBubbleWidget(
                            //       data: data,
                            //       dataGetConfig: dataGetConfig,
                            //     );
                            //   },
                            //   separatorBuilder: (context, index) {
                            //     return SizedBox(height: 10);
                            //   },
                            // ),
                            ListView.builder(
                              reverse: false,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // controller: _scrollController,
                              itemCount: _chatItems.length,
                              padding: EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                final item = _chatItems[index];

                                if (item is DateSeparator) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        item.label,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (item is ConversationList) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: ChatBubbleWidget(
                                      data: item,
                                      dataGetConfig: dataGetConfig,
                                    ),
                                  );
                                  // return ListTile(
                                  //   title: Text(item.text!),
                                  //   subtitle: Text(item.messageTime.toString()),
                                  // );
                                }

                                return SizedBox.shrink();
                              },
                            ),
                          ],
                          SizedBox(
                            height: kToolbarHeight + 30 + ((uploadFile != null) ? 80 : 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                resizeToAvoidBottomInset: true,
                bottomSheet: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (uploadFile != null)
                      Container(
                        // color: Colors.amber,
                        color: Colors.grey.shade300,
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Image.network(
                            //   "https://images.unsplash.com/photo-1575936123452-b67c3203c357?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D",
                            //   height: 60,
                            //   width: 60,
                            //   fit: BoxFit.cover,
                            // ),
                            Image.file(
                              uploadFile!,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  uploadFile = null;
                                });
                              },
                              child: Icon(
                                Icons.close,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: FocusScope(
                                    child: Focus(
                                      onFocusChange: (focus) {
                                        AppLoggerCS.debugLog("focus: $focus");
                                        setState(() {
                                          isTextFieldFocused = focus;
                                        });
                                      },
                                      child: TextField(
                                        controller: textController,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value != "") {
                                              isTextFieldEmpty = true;
                                            } else {
                                              isTextFieldEmpty = false;
                                            }
                                          });
                                        },
                                        onSubmitted: (value) async {
                                          if (uploadFile != null) {
                                            await AppController().uploadMedia(
                                              text: textController.text,
                                              mediaData: uploadFile!,
                                              onSuccess: () {
                                                uploadFile = null;
                                                _chatItems = buildChatListWithSeparators(AppController.conversationList);
                                                setState(() {});
                                              },
                                              onFailed: (errorMessage) {
                                                uploadFile = null;
                                                setState(() {});
                                              },
                                            );
                                          } else {
                                            await AppController().sendChat(
                                              text: textController.text,
                                              onSuccess: () {
                                                _chatItems = buildChatListWithSeparators(AppController.conversationList);
                                                if (AppController.isLoading) {
                                                  isLoading = true;
                                                } else {
                                                  isLoading = false;
                                                }
                                                setState(() {});
                                              },
                                            );
                                          }

                                          AppLoggerCS.debugLog("Debug here");
                                          textController.clear();
                                          isTextFieldEmpty = true;
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: (isTextFieldFocused && isTextFieldEmpty)
                                              ? InkWell(
                                                  onTap: () async {
                                                    if (uploadFile != null) {
                                                      await AppController().uploadMedia(
                                                        text: textController.text,
                                                        mediaData: uploadFile!,
                                                        onSuccess: () {
                                                          uploadFile = null;
                                                          setState(() {});
                                                        },
                                                        onFailed: (errorMessage) {
                                                          uploadFile = null;
                                                          setState(() {});
                                                        },
                                                      );
                                                    } else {
                                                      await AppController().sendChat(
                                                        text: textController.text,
                                                        onSuccess: () {
                                                          _chatItems = buildChatListWithSeparators(AppController.conversationList);
                                                          if (AppController.isLoading) {
                                                            isLoading = true;
                                                          } else {
                                                            isLoading = false;
                                                          }
                                                        },
                                                      );
                                                    }

                                                    AppLoggerCS.debugLog("Debug here");
                                                    textController.clear();
                                                    isTextFieldEmpty = true;
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      radius: 20,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.send,
                                                          size: 16,
                                                          color: isTextFieldFocused ? Colors.green : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : null,
                                          hintText: "Type something...",
                                          hintStyle: GoogleFonts.lato(
                                            color: Colors.black38,
                                            fontSize: 14,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade300,
                                          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(width: 12),
                              InkWell(
                                onTap: () async {
                                  uploadFile = await AppImagePickerServiceCS().getImageAsFile();
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.image,
                                    size: 24,
                                  ),
                                ),
                              ),
                              // SizedBox(width: 12),
                              InkWell(
                                onTap: () async {
                                  uploadFile = await AppFilePickerServiceCS().pickFiles();
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Icon(
                                    // Icons.send,
                                    Icons.attach_file_rounded,
                                    size: 24,
                                  ),
                                ),
                              ),
                              // SizedBox(width: 12),
                            ],
                          ),
                          SizedBox(height: 5),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Chat By",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Image.asset(
                                  Assets.icKonnek,
                                  package: "flutter_plugin_test2",
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // if (isLoading)
              //   Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height,
              //     color: Colors.black38,
              //     child: Center(
              //       child: SizedBox(
              //         height: 50,
              //         width: 50,
              //         child: CircularProgressIndicator(),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
