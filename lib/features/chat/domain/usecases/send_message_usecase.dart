import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/features/chat/domain/repositories/chat_repository.dart';

@injectable
class SendMessageUseCase {
  final ChatRepository _repository;
  SendMessageUseCase(this._repository);

  Future<void> execute({
    required String chatId,
    required String senderId,
    required String content,
    required Mood mood,
    required bool isMoodOverridden,
  }) =>
      _repository.sendMessage(
        chatId: chatId,
        senderId: senderId,
        content: content,
        mood: mood,
        isMoodOverridden: isMoodOverridden,
      );
}
