import 'package:flutter/material.dart';

class TypingBubble extends StatelessWidget {
  const TypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 6),
      child: Row(
        children: const [
          Icon(Icons.smart_toy),
          SizedBox(width: 6),
          DotTyping(),
        ],
      ),
    );
  }
}

class DotTyping extends StatefulWidget {
  const DotTyping({super.key});

  @override
  State<DotTyping> createState() => _DotTypingState();
}

class _DotTypingState extends State<DotTyping>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final dots = "." * ((_controller.value * 3).floor() + 1);
        return Text("mengetik$dots");
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
