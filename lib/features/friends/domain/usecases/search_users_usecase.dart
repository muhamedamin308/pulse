import 'package:injectable/injectable.dart';
import 'package:pulse/features/friends/domain/entities/friend_entity.dart';
import 'package:pulse/features/friends/domain/repository/friends_repository.dart';

@injectable
class SearchUsersUsecase {
  final FriendsRepository _repository;
  SearchUsersUsecase(this._repository);

  Future<List<FriendEntity>> execute(String query) =>
      _repository.searchUsers(query);
}
