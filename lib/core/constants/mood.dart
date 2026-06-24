import 'package:flutter/material.dart';
import '../constants/pulse_colors.dart';

enum Mood {
  happy,
  sad,
  angry,
  anxious,
  excited,
  neutral;

  Color get color {
    switch (this) {
      case Mood.happy:
        return PulseColors.moodHappy;
      case Mood.sad:
        return PulseColors.moodSad;
      case Mood.angry:
        return PulseColors.moodAngry;
      case Mood.anxious:
        return PulseColors.moodAnxious;
      case Mood.excited:
        return PulseColors.moodExcited;
      case Mood.neutral:
        return PulseColors.moodNeutral;
    }
  }

  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊';
      case Mood.sad:
        return '😢';
      case Mood.angry:
        return '😠';
      case Mood.anxious:
        return '😰';
      case Mood.excited:
        return '🤩';
      case Mood.neutral:
        return '😐';
    }
  }

  String get label {
    switch (this) {
      case Mood.happy:
        return 'Happy';
      case Mood.sad:
        return 'Sad';
      case Mood.angry:
        return 'Angry';
      case Mood.anxious:
        return 'Anxious';
      case Mood.excited:
        return 'Excited';
      case Mood.neutral:
        return 'Neutral';
    }
  }

  String get value => name;

  static Mood fromValue(String value) {
    return Mood.values.firstWhere(
      (m) => m.name == value,
      orElse: () => Mood.neutral,
    );
  }
}
