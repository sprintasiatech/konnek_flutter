import 'package:flutter/material.dart';

/// Helper class to put your draggable floating top of your screen
class DraggableFloatingWidget extends StatefulWidget {
  /// Your main screen
  final Widget child;

  /// Put your mini widget here to be draggable and floating
  final Widget draggableWidget;

  const DraggableFloatingWidget({
    super.key,
    required this.child,
    required this.draggableWidget,
  });

  @override
  State<DraggableFloatingWidget> createState() => _DraggableFloatingWidgetState();
}

class _DraggableFloatingWidgetState extends State<DraggableFloatingWidget> {
  Offset position = Offset(70, -40);

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
                child: widget.draggableWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
