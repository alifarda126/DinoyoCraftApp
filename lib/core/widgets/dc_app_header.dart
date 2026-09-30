import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets.dart';
import '../theme/app_colors.dart';

class DcAppHeader extends StatelessWidget {
  const DcAppHeader({super.key, this.showActions = true});

  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
        child: Row(
          children: [
            Image.asset(AppAssets.logoBlack, width: 36, height: 36),
            const SizedBox(width: 10),
            Text(
              'DinoyoCraft',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const Spacer(),
            if (showActions) ...[
              _IconBtn(
                asset: AppAssets.iconSearch,
                iconSize: 32, // viewBox 40×40 → perlu lebih besar agar visual sama
                onTap: () => context.go('/products'),
              ),
              const SizedBox(width: 4),
              _IconBtn(
                asset: AppAssets.iconProfile,
                iconSize: 26,
                onTap: () => context.push('/profile'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.asset,
    required this.onTap,
    this.iconSize = 26,
  });

  final String asset;
  final VoidCallback onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SvgPicture.asset(
          asset,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
        ),
      ),
    );
  }
}

// ─── Pinned sliver header — pakai ini di CustomScrollView/ListView ────────────
// Konten di-scroll ke bawah, header tetap di atas sebagai pembatas.
class SliverPinnedDcHeader extends StatelessWidget {
  const SliverPinnedDcHeader({super.key, this.showActions = true});

  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _DcHeaderDelegate(showActions: showActions),
    );
  }
}

class _DcHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _DcHeaderDelegate({this.showActions = true});

  final bool showActions;

  // Tinggi header: SafeArea top + konten 52px
  double get _headerH =>
      52.0; // dipakai sebagai basis; SafeArea ditangani di dalam widget

  @override
  double get maxExtent => _headerH;
  @override
  double get minExtent => _headerH;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final topPad = MediaQuery.paddingOf(context).top;
    return Container(
      // Solid white background → konten scroll tidak tembus
      color: Colors.white,
      height: topPad + _headerH,
      child: DcAppHeader(showActions: showActions),
    );
  }

  @override
  bool shouldRebuild(_DcHeaderDelegate old) => old.showActions != showActions;
}
