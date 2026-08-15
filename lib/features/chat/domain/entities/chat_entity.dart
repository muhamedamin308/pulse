import 'package:pulse/core/constants/mood.dart';

class ChatEntity {
  final String id;
  final List<String> participantIds;
  final String? lastMessage;
  final Mood? lastMessageMood;
  final DateTime? lastMessageAt;
  final Map<String, int> unreadCount;

  const ChatEntity({
    required this.id,
    required this.participantIds,
    this.lastMessage,
    this.lastMessageMood,
    this.lastMessageAt,
    required this.unreadCount,
  });
}
