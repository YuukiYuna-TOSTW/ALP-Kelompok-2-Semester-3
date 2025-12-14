import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String keyCurrentSessionId = 'current_session_id';

  List<List<Map<String, String>>> allChats = [];
  List<Map<String, String>> currentChat = [];

  bool isBotTyping = false;
  bool isLoadingHistory = false;

  late final GenerativeModel _model;
  late ChatSession _chatSession;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _currentChatSessionId;

  // ================= INIT =================
  @override
  void initState() {
    super.initState();

    _model = FirebaseAI.googleAI().generativeModel(
      // jika bermasalah di web, ganti ke: gemini-1.5-flash
      model: 'gemini-2.5-flash',
    );

    _startFreshSession();
    _loadAll();
  }

  void _startFreshSession() {
    _chatSession = _model.startChat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ================= STORAGE =================
  Future<void> _loadAll() async {
    setState(() => isLoadingHistory = true);

    final prefs = await SharedPreferences.getInstance();
    final all = prefs.getString(keyAllChats);
    final cur = prefs.getString(keyCurrentChat);
    final sessionId = prefs.getString(keyCurrentSessionId);

    if (all != null) {
      allChats = (jsonDecode(all) as List)
          .map(
            (e) => List<Map<String, String>>.from(
              e.map((m) => Map<String, String>.from(m)),
            ),
          )
          .toList();
    }

    if (cur != null) {
      currentChat = List<Map<String, String>>.from(
        jsonDecode(cur).map((m) => Map<String, String>.from(m)),
      );
    }

    if (sessionId != null && sessionId.isNotEmpty) {
      _currentChatSessionId = sessionId;
      await _loadChatFromFirestore();
    }

    if (currentChat.isEmpty) {
      await _startNewChat(savePrevious: false);
    }

    setState(() => isLoadingHistory = false);
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAllChats, jsonEncode(allChats));
    await prefs.setString(keyCurrentChat, jsonEncode(currentChat));
    if (_currentChatSessionId != null) {
      await prefs.setString(keyCurrentSessionId, _currentChatSessionId!);
    }
  }

  // ================= FIRESTORE =================
  Future<void> _createFirestoreSession() async {
    final doc = await _firestore.collection('chatbot_sessions').add({
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessageAt': FieldValue.serverTimestamp(),
      'messageCount': 0,
    });

    _currentChatSessionId = doc.id;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyCurrentSessionId, doc.id);

    await _saveMessageToFirestore('bot', currentChat.first['text']!);
  }

  Future<void> _loadChatFromFirestore() async {
    if (_currentChatSessionId == null) return;

    try {
      final snap = await _firestore
          .collection('chatbot_sessions')
          .doc(_currentChatSessionId)
          .collection('messages')
          .orderBy('timestamp')
          .get();

      currentChat = snap.docs
          .map(
            (d) => {
              'sender': d['sender'] as String,
              'text': d['message'] as String,
            },
          )
          .toList();

      await _saveAll();
    } catch (e) {
      debugPrint("Load chat error: $e");
    }
  }

  Future<void> _saveMessageToFirestore(String sender, String text) async {
    if (_currentChatSessionId == null) return;

    await _firestore
        .collection('chatbot_sessions')
        .doc(_currentChatSessionId)
        .collection('messages')
        .add({
          'sender': sender,
          'message': text,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  // ================= CHAT =================
  Future<void> _startNewChat({bool savePrevious = true}) async {
    if (savePrevious && currentChat.isNotEmpty) {
      allChats.insert(0, List.from(currentChat));
    }

    currentChat = [
      {
        "sender": "bot",
        "text":
            "Halo! 👋\n\nSaya adalah AI Assistant berbasis Google Gemini 🤖✨\n\nSilakan ketik pesan Anda!",
      },
    ];

    _startFreshSession();
    await _createFirestoreSession();
    await _saveAll();

    setState(() {});
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

    await _saveMessageToFirestore('user', text);

    try {
      final response = await _chatSession.sendMessage(Content.text(text));

      final reply =
          response.text ?? "Maaf, saya tidak dapat memproses permintaan Anda.";

      setState(() {
        currentChat.add({"sender": "bot", "text": reply});
        isBotTyping = false;
      });

      await _saveMessageToFirestore('bot', reply);
    } catch (e, stackTrace) {
      debugPrint("Gemini Error: $e");
      debugPrintStack(stackTrace: stackTrace);

      setState(() {
        currentChat.add({
          "sender": "bot",
          "text":
              "❌ Layanan AI sedang bermasalah.\nSilakan coba lagi beberapa saat.",
        });
        isBotTyping = false;
      });
    }

    await _saveAll();
    _scrollDown();
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

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (isLoadingHistory) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: ChatHistoryDrawer(
        allChats: allChats,
        onSelectChat: (i) {
          currentChat = List.from(allChats[i]);
          Navigator.pop(context);
          setState(() {});
        },
        onDeleteChat: (i) {
          allChats.removeAt(i);
          _saveAll();
          setState(() {});
        },
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text("Chatbot"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: () => _startNewChat(),
          ),
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
      padding: const EdgeInsets.all(16),
      itemCount: currentChat.length,
      itemBuilder: (_, i) {
        final msg = currentChat[i];
        return ChatBubble(
          message: msg['text']!,
          isUser: msg['sender'] == 'user',
        );
      },
    );
  }
}
