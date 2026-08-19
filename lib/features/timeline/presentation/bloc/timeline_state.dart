part of 'timeline_cubit.dart';

abstract class TimelineState extends Equatable {
  const TimelineState();
  @override
  List<Object?> get props => [];
}

class TimelineInitial extends TimelineState {}

class TimelineLoading extends TimelineState {}

class TimelineLoaded extends TimelineState {
  final ConversationMoodSummary summary;
  const TimelineLoaded(this.summary);
  @override
  List<Object?> get props => [summary];
}

class TimelineError extends TimelineState {
  final String message;
  const TimelineError(this.message);
  @override
  List<Object?> get props => [message];
}