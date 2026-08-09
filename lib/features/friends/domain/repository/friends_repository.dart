import 'package:pulse/features/friends/domain/entities/friend_entity.dart';

abstract class FriendsRepository {
  Future<List<FriendEntity>> getFriends(String userId);
  Future<List<FriendEntity>> searchUsers(String query);
  Future<List<FriendEntity>> getSuggestedUsers(String userId);
  Future<void> addFriend(String currentUserId, String targetUserId);
  Future<void> removeFriend(String currentUserId, String targetUserId);
}
