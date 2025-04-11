import 'package:flutter/material.dart';

import 'package:flutter_plugin_test2/interface/live_chat_sdk.dart';

class LiveChatSdkScreen extends StatefulWidget {
  final Widget child;

  const LiveChatSdkScreen({
    super.key,
    required this.child,
  });

  @override
  State<LiveChatSdkScreen> createState() => _LiveChatSdkScreenState();
}

class _LiveChatSdkScreenState extends State<LiveChatSdkScreen> {
  Offset position = Offset(70, -40);

  final LiveChatSdk liveChatSdk = LiveChatSdk();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your main UI here
          widget.child,

          // Draggable floating widget
          Align(
            alignment: Alignment.bottomCenter,
            // left: position.dx,
            // top: position.dy,
            child: Transform.translate(
              offset: position,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    position += details.delta;
                  });
                },
                // child: widget.draggableWidget,
                // child: widget.draggableWidget.entryPointWidget(),
                child: liveChatSdk.entryPointWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
