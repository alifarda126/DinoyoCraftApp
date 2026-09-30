import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets.dart';
import '../theme/app_colors.dart';

class DcBottomNav extends StatelessWidget {
  const DcBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem('Beranda', AppAssets.navBerandaActive, Icons.home_rounded),
    _NavItem('Produk', AppAssets.navProduk, Icons.shopping_bag_outlined),
    _NavItem('Toko', AppAssets.navToko, Icons.storefront_outlined),
    _NavItem('Workshop', AppAssets.navWorkshop, Icons.location_on_outlined),
    _NavItem('Bantuan', AppAssets.navBantuan, Icons.help_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final active = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: active ? 48 : 40,
                      height: active ? 48 : 40,
                      decoration: BoxDecoration(
                        color: active ? AppColors.black : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: _NavIcon(
                        asset: item.asset,
                        fallback: item.fallback,
                        active: active,
                      ),
                    ),
                    if (!active) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.asset, this.fallback);

  final String label;
  final String asset;
  final IconData fallback;
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.asset,
    required this.fallback,
    required this.active,
  });

  final String asset;
  final IconData fallback;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.white : AppColors.textMuted;
    return SvgPicture.asset(
      asset,
      width: 22,
      height: 22,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      placeholderBuilder: (_) => Icon(fallback, size: 22, color: color),
    );
  }
}
