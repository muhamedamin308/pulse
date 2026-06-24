import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/pulse_colors.dart';
import '../constants/pulse_text_styles.dart';

class PulseTheme {
  PulseTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: PulseColors.background,
      primaryColor: PulseColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: PulseColors.primary,
        secondary: PulseColors.primaryLight,
        surface: PulseColors.surface,
        background: PulseColors.background,
        error: PulseColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: PulseColors.textPrimary,
        onBackground: PulseColors.textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: PulseColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: PulseColors.textPrimary),
        titleTextStyle: PulseTextStyles.headlineMedium,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: PulseColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PulseColors.surface,
        hintStyle: PulseTextStyles.bodyMedium.copyWith(
          color: PulseColors.textHint,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: PulseColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: PulseColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: PulseColors.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PulseColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: PulseTextStyles.labelLarge,
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: PulseColors.primary,
          textStyle: PulseTextStyles.labelLarge,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: PulseColors.divider,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: PulseTextStyles.displayLarge,
        displayMedium: PulseTextStyles.displayMedium,
        headlineLarge: PulseTextStyles.headlineLarge,
        headlineMedium: PulseTextStyles.headlineMedium,
        titleLarge: PulseTextStyles.titleLarge,
        titleMedium: PulseTextStyles.titleMedium,
        bodyLarge: PulseTextStyles.bodyLarge,
        bodyMedium: PulseTextStyles.bodyMedium,
        bodySmall: PulseTextStyles.bodySmall,
        labelLarge: PulseTextStyles.labelLarge,
        labelSmall: PulseTextStyles.labelSmall,
      ),
    );
  }
}
