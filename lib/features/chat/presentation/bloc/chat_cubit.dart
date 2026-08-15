import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/features/chat/domain/entities/message_entity.dart';
import 'package:pulse/features/chat/domain/usecases/create_chat_usecase.dart';
import 'package:pulse/features/chat/domain/usecases/delete_message_usecase.dart';
import 'package:pulse/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:pulse/features/chat/domain/usecases/mark_messages_as_read_usecase.dart';
import 'package:pulse/features/chat/domain/usecases/send_message_usecase.dart';

part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final GetMessagesUseCase _getMessages;
  final SendMessageUseCase _sendMessage;
  final DeleteMessageUseCase _deleteMessage;
  final CreateChatUseCase _createChat;
  final MarkMessagesAsReadUseCase _markAsRead;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  ChatCubit(
    this._getMessages,
    this._sendMessage,
    this._deleteMessage,
    this._createChat,
    this._markAsRead,
  ) : super(ChatInitial());

  Future<String> createOrOpenChat({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      final chatId = await _createChat.execute(
          currentUserId: currentUserId, targetUserId: targetUserId);
      return chatId;
    } catch (e) {
      emit(ChatError(e.toString()));
      rethrow;
    }
  }

  void loadMessages(String chatId) {
    emit(ChatLoading());
    _messagesSubscription?.cancel();
    _messagesSubscription = _getMessages.execute(chatId).listen(
          (messages) => emit(ChatLoaded(messages: messages, chatId: chatId)),
          onError: (e) => emit(ChatError(e.toString())),
        );
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    required Mood mood,
    required bool isMoodOverridden,
  }) async {
    try {
      await _sendMessage.execute(
          chatId: chatId,
          senderId: senderId,
          content: content,
          mood: mood,
          isMoodOverridden: isMoodOverridden);
    } catch (e) {
      emit(ChatError(e.toString()));
      rethrow;
    }
  }

  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      await _deleteMessage.execute(chatId, messageId);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> markAsRead({
    required String chatId,
    required String userId,
  }) async {
    try {
      await _markAsRead.execute(chatId, userId);
    } catch (e) {
      // Silent fail — not critical
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
