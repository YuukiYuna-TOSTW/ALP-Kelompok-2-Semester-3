import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/theme/colors.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_history_drawer.dart';
import '../widgets/typing_bubble.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final String keyAllChats = 'all_chats';
  final String keyCurrentChat = 'current_chat';

  List<List<Map<String, String>>> allChats = [];
  List<Map<String, String>> currentChat = [];

  bool isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /* ================= STORAGE ================= */
  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final all = prefs.getString(keyAllChats);
    final cur = prefs.getString(keyCurrentChat);

    if (all != null) {
      allChats = (jsonDecode(all) as List)
          .map((e) => List<Map<String, String>>.from(
              e.map((m) => Map<String, String>.from(m))))
          .toList();
    }

    if (cur != null) {
      currentChat = List<Map<String, String>>.from(
        jsonDecode(cur).map((m) => Map<String, String>.from(m)),
      );
    }

    if (currentChat.isEmpty) _startNewChat(savePrevious: false);
    setState(() {});
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAllChats, jsonEncode(allChats));
    await prefs.setString(keyCurrentChat, jsonEncode(currentChat));
  }

  /* ================= CHAT ================= */
  void _startNewChat({bool savePrevious = true}) {
    if (savePrevious && currentChat.isNotEmpty) {
      allChats.insert(0, List.from(currentChat));
    }

    currentChat = [
      {
        "sender": "bot",
        "text": "Halo 👋\nSaya Chatbot 🤖\nSilakan ketik pesan."
      }
    ];

    _saveAll();
    setState(() {});
  }

  void _openHistory(int index) {
    currentChat = List.from(allChats[index]);
    Navigator.pop(context);
    _saveAll();
    setState(() {});
  }

  void _deleteChat(int index) {
    setState(() => allChats.removeAt(index));
    _saveAll();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || isBotTyping) return;

    setState(() {
      currentChat.add({"sender": "user", "text": text});
      isBotTyping = true;
    });

    _controller.clear();
    _scrollDown();

    if (currentChat.length == 2) {
      allChats.insert(0, List.from(currentChat));
    }

    _saveAll();

    await Future.delayed(const Duration(seconds: 1));
    setState(() => isBotTyping = false);

    await _typeBotMessage("✅ Pesan diterima:\n$text");
    _saveAll();
    _scrollDown();
  }

  Future<void> _typeBotMessage(String text) async {
    currentChat.add({"sender": "bot", "text": ""});
    final index = currentChat.length - 1;

    String temp = "";
    for (int i = 0; i < text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      temp += text[i];
      setState(() => currentChat[index]["text"] = temp);
      _scrollDown();
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: ChatHistoryDrawer(
        allChats: allChats,
        onSelectChat: _openHistory,
        onDeleteChat: _deleteChat,
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: const Text(
          "Chatbot",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded),
            onPressed: () => _startNewChat(),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _chatList()),
          if (isBotTyping) const TypingBubble(),
          ChatInput(
            controller: _controller,
            focusNode: _focusNode,
            onSend: _sendMessage,
            isLoading: isBotTyping,
          ),
        ],
      ),
    );
  }

  Widget _chatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: currentChat.length,
      itemBuilder: (_, i) {
        final msg = currentChat[i];
        final isUser = msg['sender'] == 'user';

        return ChatBubble(
          message: msg['text'] ?? '',
          isUser: isUser,
        );
      },
    );
  }
}
