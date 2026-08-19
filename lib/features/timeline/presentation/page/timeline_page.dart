import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/timeline/presentation/bloc/timeline_cubit.dart';
import 'package:pulse/features/timeline/presentation/widgets/mood_bar_chart.dart';
import 'package:pulse/features/timeline/presentation/widgets/mood_legend.dart';
import 'package:pulse/features/timeline/presentation/widgets/mood_line_chart.dart';

class TimelinePage extends StatefulWidget {
  final String chatId;
  final String friendName;

  const TimelinePage({
    super.key,
    required this.chatId,
    required this.friendName,
  });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void initState() {
    super.initState();
    context.read<TimelineCubit>().loadTimeline(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Emotional Timeline'),
            Text(
              widget.friendName,
              style: PulseTextStyles.labelSmall,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TimelineCubit, TimelineState>(
        builder: (context, state) {
          if (state is TimelineLoading) {
            return const Center(
              child: CircularProgressIndicator(color: PulseColors.primary),
            );
          }

          if (state is TimelineError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, style: PulseTextStyles.bodyMedium),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context
                        .read<TimelineCubit>()
                        .loadTimeline(widget.chatId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TimelineLoaded) {
            final summary = state.summary;

            if (summary.totalMessages < 3) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💬', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    const Text(
                      'Not enough messages yet',
                      style: PulseTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Send at least 3 messages to\nsee your emotional timeline.',
                      style: PulseTextStyles.bodyMedium.copyWith(
                        color: PulseColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: PulseColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: summary.dominantMood.color.withValues(alpha: .3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          summary.dominantMood.emoji,
                          style: const TextStyle(fontSize: 36),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dominant Mood',
                              style: PulseTextStyles.labelSmall,
                            ),
                            Text(
                              summary.dominantMood.label,
                              style: PulseTextStyles.headlineMedium.copyWith(
                                color: summary.dominantMood.color,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${summary.totalMessages}',
                              style: PulseTextStyles.headlineLarge.copyWith(
                                color: PulseColors.primary,
                              ),
                            ),
                            const Text(
                              'messages',
                              style: PulseTextStyles.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Line chart
                  MoodLineChart(dataPoints: summary.dataPoints),
                  const SizedBox(height: 28),

                  // Bar chart
                  MoodBarChart(moodFrequency: summary.moodFrequency),
                  const SizedBox(height: 24),

                  // Legend
                  const MoodLegend(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
