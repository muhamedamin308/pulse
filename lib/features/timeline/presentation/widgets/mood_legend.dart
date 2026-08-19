import 'package:flutter/material.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';

class MoodLegend extends StatelessWidget {
  const MoodLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: Mood.values.map((mood) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: mood.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${mood.emoji} ${mood.label}',
              style: PulseTextStyles.labelSmall,
            ),
          ],
        );
      }).toList(),
    );
  }
}
