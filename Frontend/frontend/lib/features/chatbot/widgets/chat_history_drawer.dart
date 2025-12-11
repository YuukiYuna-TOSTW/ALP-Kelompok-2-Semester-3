import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

class ChatHistoryDrawer extends StatefulWidget {
  final List<List<Map<String, String>>> allChats;
  final Function(int) onSelectChat;
  final Function(int) onDeleteChat;

  const ChatHistoryDrawer({
    super.key,
    required this.allChats,
    required this.onSelectChat,
    required this.onDeleteChat,
  });

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary,
            child: const Text(
              "Riwayat Chat",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
            child: widget.allChats.isEmpty
                ? const Center(child: Text("Belum ada riwayat"))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: widget.allChats.length,
                    itemBuilder: (_, i) {
                      final preview =
                          widget.allChats[i].lastWhere(
                            (m) => m['sender'] == 'user',
                            orElse: () => {"text": "Chat"},
                          )['text'] ??
                          "Chat";

                      return Dismissible(
                        key: Key("chat_$i"),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          widget.onDeleteChat(i);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => widget.onSelectChat(i),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
