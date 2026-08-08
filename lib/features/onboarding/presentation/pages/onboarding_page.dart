import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:pulse/config/router/app_router.dart';
import '../../../../core/constants/pulse_colors.dart';
import '../../../../core/constants/pulse_text_styles.dart';
import '../../../../core/constants/pulse_constants.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      PulseColors.primary,
                      PulseColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: PulseColors.primary.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to ${PulseConstants.appName}',
                style: PulseTextStyles.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                PulseConstants.appTagline,
                style: PulseTextStyles.bodyLarge.copyWith(
                  color: PulseColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Chat with friends and let your emotions speak.\nEvery message carries a feeling.',
                style: PulseTextStyles.bodyMedium.copyWith(
                  color: PulseColors.textHint,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              // Mood preview chips
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _MoodChip(
                      emoji: '😊',
                      label: 'Happy',
                      color: PulseColors.moodHappy),
                  _MoodChip(
                      emoji: '😢', label: 'Sad', color: PulseColors.moodSad),
                  _MoodChip(
                      emoji: '🤩',
                      label: 'Excited',
                      color: PulseColors.moodExcited),
                  _MoodChip(
                      emoji: '😠',
                      label: 'Angry',
                      color: PulseColors.moodAngry),
                  _MoodChip(
                      emoji: '😰',
                      label: 'Anxious',
                      color: PulseColors.moodAnxious),
                  _MoodChip(
                      emoji: '😐',
                      label: 'Neutral',
                      color: PulseColors.moodNeutral),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final box = Hive.box(PulseConstants.settingsBox);
                  await box.put(PulseConstants.isOnboardedKey, true);
                  if (context.mounted) context.goNamed(AppRoutes.registerName);
                },
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  final box = Hive.box(PulseConstants.settingsBox);
                  await box.put(PulseConstants.isOnboardedKey, true);
                  if (context.mounted) context.goNamed(AppRoutes.loginName);
                },
                child: const Text('I already have an account'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;

  const _MoodChip({
    required this.emoji,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
