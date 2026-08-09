import 'package:injectable/injectable.dart';
import 'package:pulse/features/friends/domain/repository/friends_repository.dart';

@injectable
class RemoveFriendUseCase {
  final FriendsRepository _repository;
  RemoveFriendUseCase(this._repository);

  Future<void> execute({
    required String currentUserId,
    required String targetUserId,
  }) =>
      _repository.removeFriend(currentUserId, targetUserId);
}
