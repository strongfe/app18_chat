import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/chat_viewmodel.dart';
import 'widgets/chat_input.dart';
import 'widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final ScrollController _scrollController = ScrollController();

  AnimationController _createAnimationController() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controllers.add(controller);
    return controller;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Consumer<ChatViewModel>(
                  builder: (context, viewModel, child) {
                    while (_controllers.length < viewModel.messages.length) {
                      final controller = _createAnimationController();
                      controller.forward();
                    }
                    
                    Future.microtask(() => _scrollToBottom());
                    
                    return Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: viewModel.messages.length,
                          itemBuilder: (context, index) {
                            final message = viewModel.messages[index];
                            return ChatBubble(
                              message: message,
                              animation: _controllers[index],
                            );
                          },
                        ),
                        if (viewModel.isLoading)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              child: const Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF007AFF),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'AI가 응답을 작성 중입니다...',
                                      style: TextStyle(
                                        color: Color(0xFF8E8E93),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const ChatInput(),
            ],
          ),
        ),
      ),
    );
  }
} 