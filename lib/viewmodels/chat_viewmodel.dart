import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../models/message_model.dart';
import '../services/ai_service.dart';

class ChatViewModel extends ChangeNotifier {
  final Logger _logger = Logger();
  final List<MessageModel> _messages = [];
  final AIService _aiService = AIService();
  
  List<MessageModel> get messages => _messages;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // 사용자 메시지 추가
    final userMessage = MessageModel(
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    notifyListeners();

    // AI 응답 처리
    _isLoading = true;
    notifyListeners();

    try {
      final aiResponse = await _aiService.getAIResponse(content);
      final aiMessage = MessageModel(
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(aiMessage);
    } catch (e) {
      _logger.e('Error in sendMessage', error: e, stackTrace: StackTrace.current);
      final errorMessage = MessageModel(
        content: '죄송합니다. 응답 중 오류가 발생했습니다.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 