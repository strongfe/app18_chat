import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");  // .env 파일 로드
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // Gemini API 설정
  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      debugPrint('API 키가 설정되지 않았습니다.');
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
    _chat = _model.startChat();
  }

  Future<String> getAIResponse(String message) async {
    try {
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      return response.text ?? '응답을 받지 못했습니다.';
    } catch (e) {
      debugPrint('AI 응답 오류: $e');
      if (e.toString().contains('API key')) {
        return 'API 키를 확인해주세요.';
      }
      return '죄송합니다. 오류가 발생했습니다: $e';
    }
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;
    
    final userMessage = text;
    _textController.clear();

    setState(() {
      messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
      ));
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final aiResponse = await getAIResponse(userMessage);
      
      setState(() {
        _isLoading = false;
        messages.add(ChatMessage(
          text: aiResponse,
          isUser: false,
        ));
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
        messages.add(const ChatMessage(
          text: "죄송합니다. 응답 처리 중 오류가 발생했습니다.",
          isUser: false,
        ));
      });
      debugPrint('메시지 처리 오류: $e');
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return messages[index];
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -2),
                    blurRadius: 2,
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: '메시지를 입력하세요',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(24),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _handleSubmitted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _handleSubmitted(_textController.text),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isUser ? Colors.blue : Colors.grey[300],
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            text,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}