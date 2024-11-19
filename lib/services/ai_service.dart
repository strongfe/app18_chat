import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final Logger _logger = Logger();
  late final GenerativeModel model;
  
  AIService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      _logger.e('GEMINI_API_KEY not found in .env file');
      throw Exception('GEMINI_API_KEY not found in .env file');
    }
    
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }
  
  ChatSession? _chat;

  Future<String> getAIResponse(String message) async {
    try {
      _chat ??= model.startChat();
      
      final response = await _chat!.sendMessage(Content.text(message));
      final responseText = response.text;
      
      if (responseText == null || responseText.isEmpty) {
        _logger.w('Empty response received from AI');
        return '죄송합니다. 응답을 생성하는 데 문제가 발생했습니다.';
      }
      
      return responseText;
    } catch (e) {
      _logger.e('AI Response Error', error: e, stackTrace: StackTrace.current);
      return '죄송합니다. 오류가 발생했습니다.';
    }
  }
} 