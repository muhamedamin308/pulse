import 'package:injectable/injectable.dart';
import 'package:pulse/features/chat/domain/entities/chat_entity.dart';
import 'package:pulse/features/chat/domain/repositories/chat_repository.dart';

@injectable
class GetChatsUseCase {
  final ChatRepository _repository;
  GetChatsUseCase(this._repository);

  Stream<List<ChatEntity>> execute(String userId) =>
      _repository.getChats(userId);
}
