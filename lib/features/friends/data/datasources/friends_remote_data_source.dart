import 'package:pulse/features/friends/data/models/friend_model.dart';

abstract class FriendsRemoteDataSource {
  Future<List<FriendModel>> getFriends(String userId);
  Future<List<FriendModel>> searchUsers(String query);
  Future<List<FriendModel>> getSuggestedUsers(String userId);
  Future<void> addFriend(String currentUserId, String targetUserId);
  Future<void> removeFriend(String currentUserId, String targetUserId);
}
