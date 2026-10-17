import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Di-set root widget sesuai tema aktif; warna-warna di bawah membaca
  /// flag ini sehingga seluruh screen ikut berganti saat mode gelap.
  static bool isDark = false;

  static const Color black = Color(0xFF000000);

  static Color get white =>
      isDark ? Color(0xFF1E1E1E) : Color(0xFFFFFFFF);
  static Color get bg =>
      isDark ? Color(0xFF121212) : Color(0xFFFFFFFF);
  static Color get inputBg =>
      isDark ? Color(0xFF2A2A2A) : Color(0xFFF5F5F5);
  static Color get border =>
      isDark ? Color(0xFF3D3D3D) : Color(0xFFCCCCCC);
  static Color get borderAlt =>
      isDark ? Color(0xFF4A4446) : Color(0xFFCFC4C5);
  static Color get textSecondary =>
      isDark ? Color(0xFFB5B5B5) : Color(0xFF5F5E5E);
  static Color get textSecondaryAlt =>
      isDark ? Color(0xFF9CA3AF) : Color(0xFF6B7280);
  static Color get textZinc =>
      isDark ? Color(0xFFA1A1AA) : Color(0xFF71717A);
  static Color get textMuted =>
      isDark ? Color(0xFF909090) : Color(0xFF888888);
  static Color get ink =>
      isDark ? Color(0xFFF5F5F5) : Color(0xFF1A1A1A);
}
