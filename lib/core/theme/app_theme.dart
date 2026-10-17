import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        scaffold: Color(0xFFFFFFFF),
        inputFill: Color(0xFFF5F5F5),
        border: AppColors.border,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scaffold: Color(0xFF121212),
        inputFill: Color(0xFF2A2A2A),
        border: Color(0xFF3D3D3D),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color scaffold,
    required Color inputFill,
    required Color border,
  }) {
    final fontFamily = GoogleFonts.plusJakartaSans().fontFamily;
    final isDark = brightness == Brightness.dark;
    final onSurface = isDark ? Color(0xFFF5F5F5) : AppColors.ink;
    final baseText = ThemeData(brightness: brightness).textTheme.apply(
          fontFamily: fontFamily,
          bodyColor: onSurface,
          displayColor: onSurface,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.black,
        brightness: brightness,
        primary: AppColors.black,
        onPrimary: AppColors.white,
        surface: scaffold,
      ),
      scaffoldBackgroundColor: scaffold,
      fontFamily: fontFamily,
      textTheme: baseText,
      primaryTextTheme: baseText,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurface, width: 1.2),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.black;
          return AppColors.white;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: BorderSide(color: border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
