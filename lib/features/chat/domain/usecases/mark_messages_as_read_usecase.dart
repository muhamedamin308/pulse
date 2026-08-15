import 'package:injectable/injectable.dart';
import 'package:pulse/features/chat/domain/repositories/chat_repository.dart';

@injectable
class MarkMessagesAsReadUseCase {
  final ChatRepository _repository;
  MarkMessagesAsReadUseCase(this._repository);

  Future<void> execute(String chatId, String userId) =>
      _repository.markMessagesAsRead(chatId, userId);
}
