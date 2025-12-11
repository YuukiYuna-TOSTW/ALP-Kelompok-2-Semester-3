import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../config/theme/colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: isUser
                  ? const LinearGradient(
                      colors: [AppColors.secondary, AppColors.primary],
                    )
                  : null,
              color: isUser ? null : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isUser ? const Radius.circular(18) : Radius.zero,
                bottomRight: isUser ? Radius.zero : const Radius.circular(18),
              ),
            ),
            child: MarkdownBody(
              data: message,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  height: 1.4,
                  fontSize: 14,
                ),
                strong: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                em: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
                code: TextStyle(
                  backgroundColor: isUser
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  color: isUser ? Colors.white : Colors.black87,
                  fontFamily: 'monospace',
                ),
                listBullet: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
