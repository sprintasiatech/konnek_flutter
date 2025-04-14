import 'dart:developer';

import 'package:fam_coding_supply/logic/app_file_picker.dart';
import 'package:fam_coding_supply/logic/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_test2/assets/assets.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          // extendBodyBehindAppBar: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            forceMaterialTransparency: true,
            leadingWidth: 90,
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
              "CS 1",
              style: GoogleFonts.inter(
                color: Colors.green,
                fontSize: 24,
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
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(width: 10),
                          Column(
                            children: [
                              SizedBox(height: 5),
                              CircleAvatar(
                                backgroundColor: Colors.purpleAccent,
                                child: Text("FM"),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.purpleAccent.shade200.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
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
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                  ),
                  SizedBox(height: kToolbarHeight + 30),
                ],
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
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                log("Debug here");
                                textController.clear();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.send,
                                  size: 24,
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
