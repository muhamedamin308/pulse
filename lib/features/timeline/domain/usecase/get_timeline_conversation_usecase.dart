import 'package:injectable/injectable.dart';
import 'package:pulse/features/timeline/domain/entities/conversation_mood_summary.dart';
import 'package:pulse/features/timeline/domain/repositories/timeline_repository.dart';

@injectable
class GetConversationTimelineUseCase {
  final TimelineRepository _repository;
  GetConversationTimelineUseCase(this._repository);

  Future<ConversationMoodSummary> execute(String chatId) =>
      _repository.getConversationTimeline(chatId);
}
