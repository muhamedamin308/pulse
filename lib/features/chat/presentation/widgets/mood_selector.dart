import 'package:flutter/widgets.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';

class MoodSelector extends StatelessWidget {
  final Mood selectedMood;
  final ValueChanged<Mood> onMoodSelected;

  const MoodSelector(
      {super.key, required this.selectedMood, required this.onMoodSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Mood.values.length,
        separatorBuilder: (_, __) => const SizedBox(
          width: 8,
        ),
        itemBuilder: (context, index) {
          final mood = Mood.values[index];
          final isSelected = mood == selectedMood;
          return GestureDetector(
            onTap: () => onMoodSelected(mood),
            child: AnimatedContainer(
              duration: const Duration(microseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: isSelected
                      ? mood.color.withValues(alpha: .25)
                      : PulseColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: isSelected ? mood.color : PulseColors.divider,
                      width: isSelected ? 1.5 : 1)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mood.emoji,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (isSelected) ...[
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      mood.label,
                      style: PulseTextStyles.labelSmall
                          .copyWith(color: mood.color),
                    )
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
