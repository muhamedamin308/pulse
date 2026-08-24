import 'dart:ui';
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
      extendBodyBehindAppBar: true,
      backgroundColor: PulseColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Emotional Timeline',
                    style: PulseTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: PulseColors.textPrimary,
                    ),
                  ),
                  Text(
                    widget.friendName,
                    style: PulseTextStyles.labelSmall.copyWith(
                      color: PulseColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 44,
                      color: PulseColors.error,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      state.message,
                      style: PulseTextStyles.bodyMedium.copyWith(
                        color: PulseColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => context
                          .read<TimelineCubit>()
                          .loadTimeline(widget.chatId),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                      style: TextButton.styleFrom(
                        foregroundColor: PulseColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TimelineLoaded) {
            final summary = state.summary;

            if (summary.totalMessages < 3) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              PulseColors.primary.withValues(alpha: 0.18),
                              PulseColors.primary.withValues(alpha: 0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('💬', style: TextStyle(fontSize: 40)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Not enough messages yet',
                        style: PulseTextStyles.headlineMedium.copyWith(
                          color: PulseColors.textPrimary,
                        ),
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
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                kToolbarHeight + MediaQuery.of(context).padding.top + 20,
                20,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary header
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          summary.dominantMood.color.withValues(alpha: 0.16),
                          PulseColors.surface,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            summary.dominantMood.color.withValues(alpha: 0.35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: summary.dominantMood.color
                              .withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                PulseColors.background.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            summary.dominantMood.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dominant Mood',
                              style: PulseTextStyles.labelSmall.copyWith(
                                color: PulseColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              summary.dominantMood.label,
                              style: PulseTextStyles.headlineMedium.copyWith(
                                color: summary.dominantMood.color,
                                fontWeight: FontWeight.w700,
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
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'messages',
                              style: PulseTextStyles.labelSmall.copyWith(
                                color: PulseColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  _SectionCard(
                      child: MoodLineChart(dataPoints: summary.dataPoints)),
                  const SizedBox(height: 20),

                  _SectionCard(
                      child:
                          MoodBarChart(moodFrequency: summary.moodFrequency)),
                  const SizedBox(height: 20),

                  const _SectionCard(child: MoodLegend()),
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

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PulseColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: PulseColors.divider.withValues(alpha: 0.5),
        ),
      ),
      child: child,
    );
  }
}
