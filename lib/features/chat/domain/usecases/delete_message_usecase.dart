import 'package:injectable/injectable.dart';
import 'package:pulse/features/chat/domain/repositories/chat_repository.dart';

@injectable
class DeleteMessageUseCase {
  final ChatRepository _repository;
  DeleteMessageUseCase(this._repository);

  Future<void> execute(String chatId, String messageId) =>
      _repository.deleteMessage(chatId, messageId);
}
