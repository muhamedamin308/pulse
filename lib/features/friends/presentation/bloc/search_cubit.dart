import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/features/friends/domain/entities/friend_entity.dart';
import 'package:pulse/features/friends/domain/usecases/search_users_usecase.dart';

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final SearchUsersUsecase _searchUsers;

  SearchCubit(this._searchUsers) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final results = await _searchUsers.execute(query.trim());
      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void clearSearch() => emit(SearchInitial());
}
