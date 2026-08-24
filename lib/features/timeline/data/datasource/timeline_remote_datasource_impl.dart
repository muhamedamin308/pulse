import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/core/constants/pulse_constants.dart';
import 'package:pulse/core/errors/exceptions.dart';
import 'package:pulse/features/timeline/data/datasource/timeline_remote_datasource.dart';
import 'package:pulse/features/timeline/domain/entities/conversation_mood_summary.dart';
import 'package:pulse/features/timeline/domain/entities/mood_data_point.dart';

@Injectable(as: TimelineRemoteDataSource)
class TimelineRemoteDatasourceImpl implements TimelineRemoteDataSource {
  final FirebaseFirestore _firestore;

  TimelineRemoteDatasourceImpl(this._firestore);

  @override
  Future<ConversationMoodSummary> getConversationTimeline(String chatId) async {
    try {
      final snapshot = await _firestore
          .collection(PulseConstants.chatsCollection)
          .doc(chatId)
          .collection(PulseConstants.messagesCollection)
          .orderBy('sentAt', descending: false)
          .get();

      if (snapshot.docs.isEmpty) {
        return ConversationMoodSummary(
            chatId: chatId,
            dataPoints: [],
            moodFrequency: {},
            totalMessages: 0,
            dominantMood: Mood.neutral);
      }

      final dataPoints = snapshot.docs.map((doc) {
        final data = doc.data();
        return MoodDataPoint(
            messageId: doc.id,
            mood: Mood.fromValue(data['mood'] ?? Mood.neutral),
            sentAt: (data['sentAt'] as Timestamp).toDate(),
            senderId: data['senderId'] ?? '');
      }).toList();

      final frequency = <Mood, int>{};
      for (final point in dataPoints) {
        frequency[point.mood] = (frequency[point.mood] ?? 0) + 1;
      }

      final dominantMood =
          frequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;

      return ConversationMoodSummary(
          chatId: chatId,
          dataPoints: dataPoints,
          moodFrequency: frequency,
          totalMessages: dataPoints.length,
          dominantMood: dominantMood);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
