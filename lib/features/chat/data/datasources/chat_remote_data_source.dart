import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/features/chat/data/models/chat_model.dart';
import 'package:pulse/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<MessageModel>> getMessages(String chatId);
  Stream<List<ChatModel>> getChats(String userId);
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
