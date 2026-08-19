import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/features/timeline/domain/entities/mood_data_point.dart';

class ConversationMoodSummary {
  final String chatId;
  final List<MoodDataPoint> dataPoints;
  final Map<Mood, int> moodFrequency;
  final int totalMessages;
  final Mood dominantMood;

  const ConversationMoodSummary({
    required this.chatId,
    required this.dataPoints,
    required this.moodFrequency,
    required this.totalMessages,
    required this.dominantMood,
  });
}
