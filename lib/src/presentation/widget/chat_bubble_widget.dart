import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin_test2/src/data/models/response/get_conversation_response_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubbleWidget extends StatelessWidget {
  // final DataGetConversation data;
  final ConversationList data;

  const ChatBubbleWidget({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (data.session?.agent?.id == "00000000-0000-0000-0000-000000000000") {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(width: 10),
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
                    // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
                    data.text ?? "null",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    // "15:29",
                    // "${DateTime.now().hour}:${DateTime.now().minute}",
                    DateFormat("hh:mm").format(data.messageTime!.toLocal()),
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
                    data.text ?? "null",
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
        ],
      );
    }
  }
}
