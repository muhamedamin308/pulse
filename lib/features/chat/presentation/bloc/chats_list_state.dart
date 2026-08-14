part of 'chats_list_cubit.dart';

abstract class ChatsListState extends Equatable {
  const ChatsListState();
  @override
  List<Object?> get props => [];
}

class ChatsListInitial extends ChatsListState {}

class ChatsListLoading extends ChatsListState {}

class ChatsListLoaded extends ChatsListState {
  final List<ChatEntity> chats;
  const ChatsListLoaded(this.chats);
  @override
  List<Object?> get props => [chats];
}

class ChatsListError extends ChatsListState {
  final String message;
  const ChatsListError(this.message);
  @override
  List<Object?> get props => [message];
}
