import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/features/chat/domain/entities/chat_entity.dart';
import 'package:pulse/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getMessages(String chatId);
  Stream<List<ChatEntity>> getChats(String userId);
  Future<String> createChat(String currentUserId, String targetUserId);
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    required Mood mood,
    required bool isMoodOverridden,
  });
  Future<void> deleteMessage(String chatId, String messageId);
  Future<void> markMessagesAsRead(String chatId, String userId);
}
