import 'package:pulse/features/timeline/domain/entities/conversation_mood_summary.dart';

abstract class TimelineRemoteDataSource {
  Future<ConversationMoodSummary> getConversationTimeline(String chatId);
}
