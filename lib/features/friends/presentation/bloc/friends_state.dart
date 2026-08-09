part of 'friends_cubit.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object?> get props => [];
}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendsLoaded extends FriendsState {
  final List<FriendEntity> friends;
  final List<FriendEntity> suggestions;
  const FriendsLoaded({required this.friends, this.suggestions = const []});

  @override
  List<Object?> get props => [friends, suggestions];

  FriendsLoaded copyWith({
    List<FriendEntity>? friends,
    List<FriendEntity>? suggestions,
  }) =>
      FriendsLoaded(
          friends: friends ?? this.friends,
          suggestions: suggestions ?? this.suggestions);
}

class FriendsError extends FriendsState {
  final String message;
  const FriendsError({required this.message});

  @override
  List<Object?> get props => [message];
}
