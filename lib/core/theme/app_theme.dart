import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  /// Di-cache: ThemeData cukup dibuat sekali per mode, tidak dibuat ulang
  /// setiap rebuild root (setiap notifikasi AppSettings).
  static final ThemeData light = _build(
        brightness: Brightness.light,
        scaffold: Color(0xFFFFFFFF),
        inputFill: Color(0xFFF5F5F5),
        border: Color(0xFFCCCCCC),
      );

  static final ThemeData dark = _build(
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
    final onSurface = isDark ? Color(0xFFF5F5F5) : Color(0xFF1A1A1A);
    final surface = isDark ? Color(0xFF1E1E1E) : Color(0xFFFFFFFF);
    final surfaceElevated =
        isDark ? Color(0xFF262626) : Color(0xFFFFFFFF);
    final secondaryText =
        isDark ? Color(0xFFB5B5B5) : Color(0xFF5F5E5E);
    final baseText = ThemeData(brightness: brightness).textTheme.apply(
          fontFamily: fontFamily,
          bodyColor: onSurface,
          displayColor: onSurface,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF000000),
        brightness: brightness,
        primary: Color(0xFF000000),
        onPrimary: Color(0xFFFFFFFF),
        surface: scaffold,
      ),
      scaffoldBackgroundColor: scaffold,
      fontFamily: fontFamily,
      textTheme: baseText,
      primaryTextTheme: baseText,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: onSurface,
        selectionColor: onSurface.withValues(alpha: 0.15),
        selectionHandleColor: onSurface,
      ),
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
      dividerColor: border,
      iconTheme: IconThemeData(color: onSurface),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceElevated,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: GoogleFonts.plusJakartaSans(
          color: secondaryText,
          fontSize: 13,
          height: 1.5,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceElevated,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surfaceElevated,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? Color(0xFF2E2E2E) : Color(0xFF1A1A1A),
        contentTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          color: Color(0xFFF5F5F5),
        ),
        actionTextColor: isDark ? Color(0xFFB7F5C9) : Color(0xFFA5D6A7),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFF000000);
          }
          return isDark ? Color(0xFFBDBDBD) : Color(0xFF777777);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Color(0xFF9C9C9C);
          return isDark ? Color(0xFF484848) : Color(0xFFDDDDDD);
        }),
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
          if (states.contains(WidgetState.selected)) {
            return Color(0xFF000000);
          }
          return surface;
        }),
        checkColor: WidgetStateProperty.all(Color(0xFFFFFFFF)),
        side: BorderSide(color: border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          side: isDark
              ? BorderSide(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 1.2,
                )
              : null,
          shape: isDark
              ? StadiumBorder(
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                )
              : const StadiumBorder(),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          side: isDark
              ? BorderSide(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 1.2,
                )
              : null,
          shape: isDark
              ? StadiumBorder(
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                )
              : const StadiumBorder(),
        ),
      ),
    );
  }
}
