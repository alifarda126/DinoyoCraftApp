import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';
import '../theme/app_colors.dart';

/// Pill filter kategori — dipakai di Beranda & halaman Produk agar
/// ukuran dan gaya selalu konsisten. Container wrap-content sehingga
/// teks tidak pernah terpotong.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Bentuk pill penuh sesuai desain awal; mengisi tinggi baris (38px).
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.black : AppColors.inputBg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label.tr,
          maxLines: 1,
          overflow: TextOverflow.visible,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
