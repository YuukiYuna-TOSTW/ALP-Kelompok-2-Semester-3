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

  // Firebase Gemini AI Model
  late final GenerativeModel _model;
  late ChatSession _chatSession;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _currentChatSessionId;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase Gemini AI
    _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
    _initChatSession();
    _loadAll();
  }

  void _initChatSession() {
    _chatSession = _model.startChat();
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

    // Load session ID dan restore dari Firestore
    if (sessionId != null && sessionId.isNotEmpty) {
      _currentChatSessionId = sessionId;
      await _loadChatFromFirestore();
    }

    if (currentChat.isEmpty) {
      _startNewChat(savePrevious: false);
    } else {
      // Rebuild context dari chat yang ada
      _rebuildChatContext();
    }

    setState(() => isLoadingHistory = false);
  }

  Future<void> _loadChatFromFirestore() async {
    if (_currentChatSessionId == null) return;

    try {
      // Ambil semua messages dari Firestore
      final messagesSnapshot = await _firestore
          .collection('chatbot_sessions')
          .doc(_currentChatSessionId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      if (messagesSnapshot.docs.isNotEmpty) {
        List<Map<String, String>> firestoreMessages = [];

        for (var doc in messagesSnapshot.docs) {
          final data = doc.data();
          firestoreMessages.add({
            'sender': data['sender'] ?? 'bot',
            'text': data['message'] ?? '',
          });
        }

        // Merge dengan local storage (gunakan Firestore sebagai source of truth)
        if (firestoreMessages.isNotEmpty) {
          currentChat = firestoreMessages;
          await _saveAll();
        }
      }
    } catch (e) {
      debugPrint('Error loading chat from Firestore: $e');
    }
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAllChats, jsonEncode(allChats));
    await prefs.setString(keyCurrentChat, jsonEncode(currentChat));
    if (_currentChatSessionId != null) {
      await prefs.setString(keyCurrentSessionId, _currentChatSessionId!);
    }
  }

  /* ================= CHAT ================= */
  void _startNewChat({bool savePrevious = true}) async {
    if (savePrevious && currentChat.isNotEmpty) {
      allChats.insert(0, List.from(currentChat));
    }

    currentChat = [
      {
        "sender": "bot",
        "text":
            "Halo! 👋\n\nSaya adalah AI Assistant yang didukung oleh Google Gemini 🤖✨\n\nSaya siap membantu Anda dengan berbagai pertanyaan, memberikan informasi, atau sekadar berdiskusi. Silakan ketik pesan Anda!",
      },
    ];

    // Reset chat session untuk percakapan baru
    _initChatSession();

    // Buat session baru di Firestore
    await _createFirestoreSession();

    _saveAll();
    setState(() {});
  }

  Future<void> _createFirestoreSession() async {
    try {
      final sessionDoc = await _firestore.collection('chatbot_sessions').add({
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessageAt': FieldValue.serverTimestamp(),
        'messageCount': 0,
      });
      _currentChatSessionId = sessionDoc.id;

      // Simpan session ID ke local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keyCurrentSessionId, _currentChatSessionId!);

      // Simpan welcome message ke Firestore
      await _saveMessageToFirestore('bot', currentChat[0]['text']!);
    } catch (e) {
      debugPrint('Error creating Firestore session: $e');
    }
  }

  void _openHistory(int index) async {
    currentChat = List.from(allChats[index]);
    Navigator.pop(context);

    // Reset chat session dan rebuild history untuk context
    _initChatSession();
    _rebuildChatContext();

    _saveAll();
    setState(() {});

    // Note: History dari drawer masih menggunakan local storage
    // Jika ingin load dari Firestore per session, perlu tambah sessionId di allChats
  }

  void _rebuildChatContext() {
    // Rebuild chat history untuk AI context (skip welcome message)
    for (int i = 1; i < currentChat.length; i++) {
      final msg = currentChat[i];
      if (msg['sender'] == 'user' && msg['text'] != null) {
        // Kirim ke chat session untuk rebuild context (tanpa await response)
        try {
          _chatSession.sendMessage(Content.text(msg['text']!));
        } catch (e) {
          debugPrint('Error rebuilding context: $e');
        }
      }
    }
  }

  void _deleteChat(int index) {
    setState(() => allChats.removeAt(index));
    _saveAll();
  }

  Future<void> _saveMessageToFirestore(String sender, String message) async {
    if (_currentChatSessionId == null) return;

    try {
      await _firestore
          .collection('chatbot_sessions')
          .doc(_currentChatSessionId)
          .collection('messages')
          .add({
            'sender': sender,
            'message': message,
            'timestamp': FieldValue.serverTimestamp(),
          });

      // Update last message timestamp dan counter
      await _firestore
          .collection('chatbot_sessions')
          .doc(_currentChatSessionId)
          .update({
            'lastMessageAt': FieldValue.serverTimestamp(),
            'messageCount': FieldValue.increment(1),
          });
    } catch (e) {
      debugPrint('Error saving message to Firestore: $e');
    }
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

    // Simpan pesan user ke Firestore
    await _saveMessageToFirestore('user', text);

    // Call Gemini AI to get response with chat history context
    try {
      final response = await _chatSession.sendMessage(Content.text(text));

      // Display AI response instantly (no typing effect)
      final botResponse =
          response.text ?? "Maaf, saya tidak dapat memproses permintaan Anda.";

      setState(() {
        currentChat.add({"sender": "bot", "text": botResponse});
        isBotTyping = false;
      });
      _scrollDown();

      // Simpan response bot ke Firestore
      await _saveMessageToFirestore('bot', botResponse);
    } catch (e) {
      final errorMessage = "❌ Maaf, terjadi kesalahan: ${e.toString()}";

      setState(() {
        currentChat.add({"sender": "bot", "text": errorMessage});
        isBotTyping = false;
      });
      _scrollDown();

      // Simpan error message ke Firestore
      await _saveMessageToFirestore('bot', errorMessage);
    }

    _saveAll();
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

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    if (isLoadingHistory) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading chat history...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

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
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reload from Firestore',
            onPressed: () => _loadChatFromFirestore(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: currentChat.length,
      itemBuilder: (_, i) {
        final msg = currentChat[i];
        final isUser = msg['sender'] == 'user';

        return ChatBubble(message: msg['text'] ?? '', isUser: isUser);
      },
    );
  }
}
