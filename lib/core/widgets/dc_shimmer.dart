import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';

/// Komponen animasi skeleton shimmer loading yang adaptif dengan mode gelap dan terang.
/// Digunakan saat aplikasi memuat data produk, banner, atau obrolan dari Backend.
class DcShimmer extends StatelessWidget {
  const DcShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;

    final defaultBase = isDark
        ? const Color(0xFF262626)
        : const Color(0xFFE5E7EB);
    final defaultHighlight = isDark
        ? const Color(0xFF383838)
        : const Color(0xFFF3F4F6);

    return Shimmer.fromColors(
      baseColor: baseColor ?? defaultBase,
      highlightColor: highlightColor ?? defaultHighlight,
      child: child,
    );
  }

  /// Kotak shimmer dasar dengan ukuran dan radius kustom.
  static Widget box({
    required double width,
    required double height,
    double borderRadius = 8,
  }) {
    return DcShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Skeleton placeholder untuk kartu produk keramik.
  static Widget productCardSkeleton() {
    return DcShimmer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 14,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 12,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Skeleton placeholder untuk promo banner carousel.
  static Widget bannerSkeleton({double aspectRatio = 16 / 9}) {
    return DcShimmer(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

