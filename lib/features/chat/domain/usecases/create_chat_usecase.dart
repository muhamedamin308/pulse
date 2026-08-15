import 'package:injectable/injectable.dart';
import 'package:pulse/features/chat/domain/repositories/chat_repository.dart';

@injectable
class CreateChatUseCase {
  final ChatRepository _repository;
  CreateChatUseCase(this._repository);

  Future<String> execute({
    required String currentUserId,
    required String targetUserId,
  }) =>
      _repository.createChat(currentUserId, targetUserId);
}
