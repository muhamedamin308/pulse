import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/features/timeline/domain/entities/conversation_mood_summary.dart';
import 'package:pulse/features/timeline/domain/usecase/get_timeline_conversation_usecase.dart';

part 'timeline_state.dart';

@injectable
class TimelineCubit extends Cubit<TimelineState> {
  final GetConversationTimelineUseCase _getTimeline;

  TimelineCubit(this._getTimeline) : super(TimelineInitial());

  Future<void> loadTimeline(String chatId) async {
    emit(TimelineLoading());
    try {
      final summary = await _getTimeline.execute(chatId);
      emit(TimelineLoaded(summary));
    } catch (e) {
      emit(TimelineError(e.toString()));
    }
  }
}
