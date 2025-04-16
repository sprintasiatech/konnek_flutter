import 'package:fam_coding_supply/logic/app_file_picker.dart';
import 'package:fam_coding_supply/logic/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_test2/assets/assets.dart';
import 'package:flutter_plugin_test2/src/presentation/controller/app_controller.dart';
import 'package:flutter_plugin_test2/src/presentation/widget/chat_bubble_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  @override
  void initState() {
    super.initState();
    // Jump to bottom after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  RefreshController refreshController = RefreshController(initialRefresh: false);

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
                    child: Text(
                      "App!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  centerTitle: false,
                  title: Text(
                    "Bot Cust Service 1",
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
                    AppLoggerCS.debugLog("onLoading");
                    await AppController().loadMoreConversation(
                      onSuccess: () {
                        // refreshController.loadComplete();
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
                            ListView.separated(
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: (AppController.conversationList.isEmpty) ? 0 : AppController.conversationList.length,
                              padding: EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                var data = AppController.conversationList[index];
                                return ChatBubbleWidget(
                                  data: data,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 10);
                              },
                            ),
                          ],
                          SizedBox(height: kToolbarHeight + 30),
                        ],
                      ),
                    ),
                  ),
                ),
                resizeToAvoidBottomInset: true,
                bottomSheet: Container(
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
                                      await AppController().sendChat(
                                        text: textController.text,
                                        // onLoading: (isLoadingValue) {
                                        //   AppLoggerCS.debugLog("isLoading1: $isLoadingValue");
                                        //   if (isLoadingValue) {
                                        //     isLoading = true;
                                        //   } else {
                                        //     isLoading = false;
                                        //   }
                                        //   setState(() {});
                                        // },
                                        onSuccess: () {
                                          AppLoggerCS.debugLog("isLoading1: ${AppController.isLoading}");
                                          if (AppController.isLoading) {
                                            isLoading = true;
                                          } else {
                                            isLoading = false;
                                          }
                                          setState(() {});
                                        },
                                      );
                                      AppLoggerCS.debugLog("Debug here");
                                      textController.clear();
                                      isTextFieldEmpty = true;
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: (isTextFieldFocused && isTextFieldEmpty)
                                          ? InkWell(
                                              onTap: () async {
                                                await AppController().sendChat(
                                                  text: textController.text,
                                                  // onLoading: (isLoadingValue) {
                                                  //   AppLoggerCS.debugLog("isLoading1: $isLoadingValue");
                                                  //   if (isLoadingValue) {
                                                  //     isLoading = true;
                                                  //   } else {
                                                  //     isLoading = false;
                                                  //   }
                                                  //   setState(() {});
                                                  // },
                                                  onSuccess: () {
                                                    AppLoggerCS.debugLog("isLoading1: ${AppController.isLoading}");
                                                    if (AppController.isLoading) {
                                                      isLoading = true;
                                                    } else {
                                                      isLoading = false;
                                                    }
                                                  },
                                                );

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
                              await AppImagePickerServiceCS().getImage();
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
                              await AppFilePickerServiceCS().pickFiles();
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
