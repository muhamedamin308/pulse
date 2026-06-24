import 'package:flutter/material.dart';
import 'pulse_colors.dart';

class PulseTextStyles {
  PulseTextStyles._();

  static const _font = 'Poppins';

  static const displayLarge = TextStyle(
    fontFamily: _font,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: PulseColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const displayMedium = TextStyle(
    fontFamily: _font,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: PulseColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const headlineLarge = TextStyle(
    fontFamily: _font,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: PulseColors.textPrimary,
  );

  static const headlineMedium = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: PulseColors.textPrimary,
  );

  static const titleLarge = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: PulseColors.textPrimary,
  );

  static const titleMedium = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: PulseColors.textPrimary,
  );

  static const bodyLarge = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: PulseColors.textPrimary,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: PulseColors.textPrimary,
  );

  static const bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: PulseColors.textSecondary,
  );

  static const labelLarge = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: PulseColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const labelSmall = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: PulseColors.textSecondary,
    letterSpacing: 0.3,
  );
}
