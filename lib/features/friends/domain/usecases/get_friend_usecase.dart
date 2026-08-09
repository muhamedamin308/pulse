import 'package:injectable/injectable.dart';
import 'package:pulse/features/friends/domain/entities/friend_entity.dart';
import 'package:pulse/features/friends/domain/repository/friends_repository.dart';

@injectable
class GetFriendUsecase {
  final FriendsRepository _repo;
  GetFriendUsecase(this._repo);

  Future<List<FriendEntity>> execute(String userId) => _repo.getFriends(userId);
}
