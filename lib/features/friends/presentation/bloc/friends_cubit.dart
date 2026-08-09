import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/features/friends/domain/entities/friend_entity.dart';
import 'package:pulse/features/friends/domain/usecases/add_friend_usecase.dart';
import 'package:pulse/features/friends/domain/usecases/get_friend_usecase.dart';
import 'package:pulse/features/friends/domain/usecases/get_suggested_users_usecase.dart';
import 'package:pulse/features/friends/domain/usecases/remove_friend_usecase.dart';

part 'friends_state.dart';

@injectable
class FriendsCubit extends Cubit<FriendsState> {
  final GetFriendUsecase _getFriends;
  final GetSuggestedUsersUseCase _getSuggested;
  final AddFriendUseCase _addFriend;
  final RemoveFriendUseCase _removeFriend;

  FriendsCubit(
    this._getFriends,
    this._getSuggested,
    this._addFriend,
    this._removeFriend,
  ) : super(FriendsInitial());

  Future<void> loadFriends(String userId) async {
    emit(FriendsLoading());
    try {
      final friends = await _getFriends.execute(userId);
      final suggestions = await _getSuggested.execute(userId);

      emit(FriendsLoaded(friends: friends, suggestions: suggestions));
    } catch (e) {
      emit(FriendsError(message: e.toString()));
    }
  }

  Future<void> addFriend({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      await _addFriend.execute(
        currentUserId: currentUserId,
        targetUserId: targetUserId,
      );
      await loadFriends(currentUserId);
    } catch (e) {
      emit(FriendsError(message: e.toString()));
    }
  }

  Future<void> removeFriend({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      await _removeFriend.execute(
        currentUserId: currentUserId,
        targetUserId: targetUserId,
      );
      await loadFriends(currentUserId);
    } catch (e) {
      emit(FriendsError(message: e.toString()));
    }
  }
}
