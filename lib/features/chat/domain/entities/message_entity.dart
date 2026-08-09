import 'package:pulse/core/constants/mood.dart';

enum MessageType { text }

class MessageEntity {
  final String id;
  final String senderId;
  final String content;
  final Mood mood;
  final bool isMoodOverridden;
  final MessageType type;
  final DateTime sentAt;
  final bool isRead;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
    required this.mood,
    required this.isMoodOverridden,
    required this.type,
    required this.sentAt,
    required this.isRead,
  });
}
