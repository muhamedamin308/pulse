import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/features/timeline/domain/repositories/timeline_repository.dart';

@injectable
class GetMoodFrequencyUseCase {
  final TimelineRepository _repository;
  GetMoodFrequencyUseCase(this._repository);

  Future<Map<Mood, int>> execute(String chatId) async {
    final summary = await _repository.getConversationTimeline(chatId);
    return summary.moodFrequency;
  }
}
