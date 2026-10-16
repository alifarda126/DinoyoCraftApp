import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    // Center melonggarkan constraint ketat dari ListView horizontal agar
    // tinggi chip mengikuti kontennya (ramping), bukan memenuhi baris.
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: selected ? AppColors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.black : AppColors.borderAlt,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.white : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
