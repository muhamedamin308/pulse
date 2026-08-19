import 'package:pulse/core/constants/mood.dart';

class MoodDataPoint {
  final String messageId;
  final Mood mood;
  final DateTime sentAt;
  final String senderId;

  const MoodDataPoint({
    required this.messageId,
    required this.mood,
    required this.sentAt,
    required this.senderId,
  });

  int get moodValue {
    switch (mood) {
      case Mood.excited:
        return 6;
      case Mood.happy:
        return 5;
      case Mood.neutral:
        return 3;
      case Mood.anxious:
        return 2;
      case Mood.sad:
        return 1;
      case Mood.angry:
        return 0;
    }
  }
}
