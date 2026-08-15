import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/features/chat/domain/entities/chat_entity.dart';
import 'package:pulse/features/chat/domain/usecases/get_chats_usecase.dart';

part 'chats_list_state.dart';

@injectable
class ChatsListCubit extends Cubit<ChatsListState> {
  final GetChatsUseCase _getChats;
  StreamSubscription<List<ChatEntity>>? _chatSubscription;

  ChatsListCubit(this._getChats) : super(ChatsListInitial());

  Future<void> loadChats(String userId) async {
    emit(ChatsListLoading());

    await _chatSubscription?.cancel();

    _chatSubscription = _getChats.execute(userId).listen(
      (chats) {
        emit(ChatsListLoaded(chats));
      },
      onError: (error) {
        emit(ChatsListError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() async {
    await _chatSubscription?.cancel();
    return super.close();
  }
}
