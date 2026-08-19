import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/timeline/domain/entities/mood_data_point.dart';

class MoodLineChart extends StatelessWidget {
  final List<MoodDataPoint> dataPoints;

  const MoodLineChart({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) return const SizedBox.shrink();

    final spots = dataPoints.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.moodValue.toDouble());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mood Journey', style: PulseTextStyles.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 6,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (_) => const FlLine(
                  color: PulseColors.divider,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 28,
                    getTitlesWidget: (value, _) {
                      final mood = _moodFromValue(value.toInt());
                      if (mood == null) return const SizedBox.shrink();
                      return Text(
                        mood.emoji,
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.4,
                  color: PulseColors.primary,
                  barWidth: 2.5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, _, __, ___) {
                      final mood = _moodFromValue(spot.y.toInt());
                      return FlDotCirclePainter(
                        radius: 5,
                        color: mood?.color ?? PulseColors.primary,
                        strokeWidth: 2,
                        strokeColor: PulseColors.background,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        PulseColors.primary.withValues(alpha: 0.3),
                        PulseColors.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final mood = _moodFromValue(spot.y.toInt());
                      return LineTooltipItem(
                        mood != null ? '${mood.emoji} ${mood.label}' : '',
                        PulseTextStyles.labelSmall.copyWith(
                          color: mood?.color ?? PulseColors.primary,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Mood? _moodFromValue(int value) {
    switch (value) {
      case 6:
        return Mood.excited;
      case 5:
        return Mood.happy;
      case 3:
        return Mood.neutral;
      case 2:
        return Mood.anxious;
      case 1:
        return Mood.sad;
      case 0:
        return Mood.angry;
      default:
        return null;
    }
  }
}
