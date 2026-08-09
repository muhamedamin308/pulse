import 'package:injectable/injectable.dart';
import 'package:pulse/core/errors/exceptions.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:pulse/features/friends/domain/entities/friend_entity.dart';
import 'package:pulse/features/friends/domain/repository/friends_repository.dart';

@Injectable(as: FriendsRepository)
class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsRemoteDataSource _remoteDataSource;

  FriendsRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> addFriend(String currentUserId, String targetUserId) async {
    try {
      await _remoteDataSource.addFriend(currentUserId, targetUserId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<FriendEntity>> getFriends(String userId) async {
    try {
      return await _remoteDataSource.getFriends(userId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<FriendEntity>> getSuggestedUsers(String userId) async {
    try {
      return await _remoteDataSource.getSuggestedUsers(userId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> removeFriend(String currentUserId, String targetUserId) async {
    try {
      await _remoteDataSource.removeFriend(currentUserId, targetUserId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<FriendEntity>> searchUsers(String query) async {
    try {
      return await _remoteDataSource.searchUsers(query);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
