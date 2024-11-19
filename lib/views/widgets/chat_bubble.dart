import 'package:flutter/material.dart';
import '../../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final Animation<double> animation;

  const ChatBubble({
    super.key,
    required this.message,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            (1 - animation.value) * (message.isUser ? 100 : -100),
            0,
          ),
          child: Opacity(
            opacity: animation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Align(
                alignment: message.isUser 
                    ? Alignment.centerRight 
                    : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? const Color(0xFF007AFF)
                        : const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      bottomRight: message.isUser 
                          ? const Radius.circular(5) 
                          : null,
                      bottomLeft: !message.isUser 
                          ? const Radius.circular(5) 
                          : null,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 