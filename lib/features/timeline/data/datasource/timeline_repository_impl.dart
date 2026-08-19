import 'package:injectable/injectable.dart';
import 'package:pulse/core/errors/exceptions.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/features/timeline/data/datasource/timeline_remote_datasource.dart';
import 'package:pulse/features/timeline/domain/entities/conversation_mood_summary.dart';
import 'package:pulse/features/timeline/domain/repositories/timeline_repository.dart';

@Injectable(as: TimelineRepository)
class TimelineRepositoryImpl implements TimelineRepository {
  final TimelineRemoteDataSource _remoteDataSource;

  TimelineRepositoryImpl(this._remoteDataSource);

  @override
  Future<ConversationMoodSummary> getConversationTimeline(String chatId) async {
    try {
      return await _remoteDataSource.getConversationTimeline(chatId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
