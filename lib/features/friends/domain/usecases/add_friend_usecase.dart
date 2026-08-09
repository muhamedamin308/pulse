import 'package:injectable/injectable.dart';
import 'package:pulse/features/friends/domain/repository/friends_repository.dart';

@injectable
class AddFriendUseCase {
  final FriendsRepository _repository;
  AddFriendUseCase(this._repository);

  Future<void> execute({
    required String currentUserId,
    required String targetUserId,
  }) =>
      _repository.addFriend(currentUserId, targetUserId);
}
