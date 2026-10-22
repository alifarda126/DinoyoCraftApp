import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Di-set root widget sesuai tema aktif; warna-warna di bawah membaca
  /// flag ini sehingga seluruh screen ikut berganti saat mode gelap.
  static bool isDark = false;

  static const Color black = Color(0xFF000000);

  /// Putih MURNI — khusus teks/ikon di atas permukaan hitam. Untuk latar
  /// kartu/tile/modal gunakan [surface].
  static const Color white = Color(0xFFFFFFFF);

  /// Latar kartu, tile, modal, dan sheet.
  static Color get surface =>
      isDark ? Color(0xFF1E1E1E) : Color(0xFFFFFFFF);

  /// Permukaan yang sedikit lebih tinggi, misalnya panel pilihan atau sheet.
  static Color get surfaceElevated =>
      isDark ? Color(0xFF262626) : Color(0xFFFFFFFF);

  /// Permukaan halus untuk ikon, field, dan tombol sekunder.
  static Color get surfaceSubtle =>
      isDark ? Color(0xFF2A2A2A) : Color(0xFFF5F5F5);
  static Color get bg =>
      isDark ? Color(0xFF121212) : Color(0xFFFFFFFF);
  static Color get inputBg =>
      surfaceSubtle;
  static Color get border =>
      isDark ? Color(0xFF3D3D3D) : Color(0xFFCCCCCC);
  static Color get borderAlt =>
      isDark ? Color(0xFF4A4446) : Color(0xFFCFC4C5);
  static Color get divider =>
      isDark ? Color(0xFF3A3A3A) : Color(0xFFEEEEEE);

  static Color get navigationSurface =>
      isDark ? Color(0xEE1C1C1C) : Color(0xEEFFFFFF);
  static Color get navigationBorder =>
      isDark ? Color(0xFF484848) : Color(0xFFE6E6E6);

  static Color get successSurface =>
      isDark ? Color(0xFF173B28) : Color(0xFFD4EDDA);
  static Color get successText =>
      isDark ? Color(0xFFB7F5C9) : Color(0xFF155724);

  /// Merah error untuk border validasi, teks error, dan aksi destruktif.
  static Color get danger => isDark ? Color(0xFFEF5350) : Color(0xFFD32F2F);

  /// Latar banner/kotak error.
  static Color get dangerSurface =>
      isDark ? Color(0xFF93000A) : Color(0xFFFFDAD6);

  /// Teks/ikon di atas [dangerSurface].
  static Color get dangerText =>
      isDark ? Color(0xFFFFDAD6) : Color(0xFF93000A);
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

  /// Stroke border tipis untuk tombol hitam saat mode gelap aktif agar shapenya terlihat jelas.
  static OutlinedBorder get stadiumButtonShape => isDark
      ? StadiumBorder(
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.35),
            width: 1.2,
          ),
        )
      : const StadiumBorder();

  /// BorderSide stroke putih untuk tombol hitam saat mode gelap aktif.
  static BorderSide? get darkButtonSide => isDark
      ? BorderSide(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1.2,
        )
      : null;

  /// Shadow putih tipis (glow) untuk tombol hitam saat mode gelap aktif.
  static List<BoxShadow>? get darkButtonShadow => isDark
      ? [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.12),
            blurRadius: 10,
            spreadRadius: 0.5,
          ),
        ]
      : null;
}
