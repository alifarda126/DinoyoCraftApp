import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  // ── Headlines ────────────────────────────────────────────────────────────
  static TextStyle heroHeadline = GoogleFonts.plusJakartaSans(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 1.22,
    letterSpacing: -0.4,
    color: AppColors.ink,
  );

  static TextStyle sectionTitle = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );

  static TextStyle cardTitle = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static TextStyle subTitle = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  // ── App Bar / Brand ───────────────────────────────────────────────────────
  static TextStyle appBarTitle = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static TextStyle brandName = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );

  // ── Body ─────────────────────────────────────────────────────────────────
  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    color: AppColors.ink,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 13,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  // ── Form ─────────────────────────────────────────────────────────────────
  static TextStyle fieldLabel = GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static TextStyle fieldText = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    color: AppColors.ink,
  );

  static TextStyle fieldHint = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    color: AppColors.textMuted,
  );

  // ── Button ────────────────────────────────────────────────────────────────
  static TextStyle buttonLabel = GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  // ── Price / Badge ─────────────────────────────────────────────────────────
  static TextStyle price = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );

  static TextStyle badge = GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle ratingBadge = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  // ── Link / Action Text ────────────────────────────────────────────────────
  static TextStyle seeAll = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static TextStyle seeAllBold = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
}
