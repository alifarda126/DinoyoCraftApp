import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => AppColors.isDark = false);

  test('tema terang tidak mewarisi warna dari mode gelap sebelumnya', () {
    AppColors.isDark = true;

    final theme = AppTheme.light;

    expect(theme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, const Color(0xFFFFFFFF));
    expect(theme.dialogTheme.backgroundColor, const Color(0xFFFFFFFF));
    expect(theme.textTheme.bodyMedium?.color, const Color(0xFF1A1A1A));
  });

  test('tema gelap tidak mewarisi warna dari mode terang sebelumnya', () {
    AppColors.isDark = false;

    final theme = AppTheme.dark;

    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, const Color(0xFF121212));
    expect(theme.dialogTheme.backgroundColor, const Color(0xFF262626));
    expect(theme.textTheme.bodyMedium?.color, const Color(0xFFF5F5F5));
  });

  test('token warna mengikuti flag isDark', () {
    AppColors.isDark = false;
    expect(AppColors.surface, const Color(0xFFFFFFFF));
    expect(AppColors.surfaceSubtle, const Color(0xFFF5F5F5));
    expect(AppColors.ink, const Color(0xFF1A1A1A));
    expect(AppColors.danger, const Color(0xFFD32F2F));
    expect(AppColors.dangerSurface, const Color(0xFFFFDAD6));
    expect(AppColors.dangerText, const Color(0xFF93000A));

    AppColors.isDark = true;
    expect(AppColors.surface, const Color(0xFF1E1E1E));
    expect(AppColors.surfaceSubtle, const Color(0xFF2A2A2A));
    expect(AppColors.ink, const Color(0xFFF5F5F5));
    expect(AppColors.danger, const Color(0xFFEF5350));
    expect(AppColors.dangerSurface, const Color(0xFF93000A));
    expect(AppColors.dangerText, const Color(0xFFFFDAD6));
  });

  test('ThemeData light & dark di-cache, tidak dibuat ulang tiap akses', () {
    expect(identical(AppTheme.light, AppTheme.light), isTrue);
    expect(identical(AppTheme.dark, AppTheme.dark), isTrue);
  });
}
