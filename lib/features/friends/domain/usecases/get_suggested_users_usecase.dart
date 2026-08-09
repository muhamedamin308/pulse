import 'package:injectable/injectable.dart';
import 'package:pulse/features/friends/domain/entities/friend_entity.dart';
import 'package:pulse/features/friends/domain/repository/friends_repository.dart';

@injectable
class GetSuggestedUsersUseCase {
  final FriendsRepository _repository;
  GetSuggestedUsersUseCase(this._repository);

  Future<List<FriendEntity>> execute(String userId) =>
      _repository.getSuggestedUsers(userId);
}
