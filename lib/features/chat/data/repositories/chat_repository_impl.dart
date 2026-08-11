import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/core/errors/exceptions.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:pulse/features/chat/domain/entities/chat_entity.dart';
import 'package:pulse/features/chat/domain/entities/message_entity.dart';
import 'package:pulse/features/chat/domain/repositories/chat_repository.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChatRepositoryImpl(this._chatRemoteDataSource);

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    try {
      return _chatRemoteDataSource.getMessages(chatId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Stream<List<ChatEntity>> getChats(String userId) {
    try {
      return _chatRemoteDataSource.getChats(userId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<String> createChat(String currentUserId, String targetUserId) async {
    try {
      return await _chatRemoteDataSource.createChat(
          currentUserId, targetUserId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> sendMessage(
      {required String chatId,
      required String senderId,
      required String content,
      required Mood mood,
      required bool isMoodOverridden}) async {
    try {
      await _chatRemoteDataSource.sendMessage(
          chatId: chatId,
          senderId: senderId,
          content: content,
          mood: mood,
          isMoodOverridden: isMoodOverridden);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _chatRemoteDataSource.deleteMessage(chatId, messageId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    try {
      await _chatRemoteDataSource.markMessagesAsRead(chatId, userId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
