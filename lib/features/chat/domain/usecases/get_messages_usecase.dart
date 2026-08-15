import 'package:injectable/injectable.dart';
import 'package:pulse/features/chat/domain/entities/message_entity.dart';
import 'package:pulse/features/chat/domain/repositories/chat_repository.dart';

@injectable
class GetMessagesUseCase {
  final ChatRepository _repository;
  GetMessagesUseCase(this._repository);

  Stream<List<MessageEntity>> execute(String chatId) =>
      _repository.getMessages(chatId);
}
