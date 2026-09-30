import 'dart:ui';

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

  // Tinggi bar konten (items layer) — cukup untuk icon+label
  static const double _barHeight = 76.0;
  // Tinggi background glass — lebih pendek dari items,
  // agar icon active yang pop ke atas bisa "mencuat" keluar dari background
  static const double _bgHeight = 58.0;
  // Ruang ekstra di atas agar icon pop-up tidak terpotong
  static const double _overflowTop = 20.0;

  @override
  Widget build(BuildContext context) {
    final rawBottom = MediaQuery.paddingOf(context).bottom;
    // Beri ruang gesture navigation bar Android (max 20px)
    // clamp 28px → navbar lebih naik dari gesture navigation bar Android
    final bottomPad = rawBottom.clamp(8.0, 28.0);
    final totalHeight = _barHeight + bottomPad + _overflowTop;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        // Stack bebas overflow ke atas — icon tidak terpotong
        clipBehavior: Clip.none,
        children: [
          // ── Layer 1: glass background (di-clip, tidak overflow) ──────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
          // Background lebih pendek (_bgHeight) dari items layer (_barHeight)
          // → icon active yang pop ke atas akan mencuat keluar dari background
          height: _bgHeight + bottomPad,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(22)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.60),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22)),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.85),
                        width: 1.2,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Layer 2: nav items (TIDAK di-clip, boleh overflow ke atas) ──
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomPad,
            height: _barHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final active = index == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: _NavItemWidget(item: item, active: active),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Per-item widget ──────────────────────────────────────────────────────────
class _NavItemWidget extends StatelessWidget {
  const _NavItemWidget({required this.item, required this.active});

  final _NavItem item;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: active ? -10.0 : 0.0),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutBack,
          builder: (ctx, dy, child) {
            return Transform.translate(
              offset: Offset(0, dy),
              child: child,
            );
          },
          child: _IconBubble(active: active, item: item),
        ),
        const SizedBox(height: 4),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? AppColors.ink : AppColors.textMuted,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}

// ─── Icon bubble: circle hitam + stroke putih tipis ──────────────────────────
class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.active, required this.item});

  final bool active;
  final _NavItem item;

  @override
  Widget build(BuildContext context) {
    if (!active) {
      // Inactive: ikon biasa tanpa background
      return SizedBox(
        width: 40,
        height: 40,
        child: Center(child: _icon(false)),
      );
    }

    // Active: outer ring putih tipis (1.5px) + inner circle hitam lebih besar
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Stroke putih tipis (1.5px) di luar circle hitam
        border: Border.all(color: Colors.white, width: 1.5),
        color: Colors.transparent,
      ),
      // inner circle hitam mengisi hampir penuh (margin 1.5px ikut border)
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: const BoxDecoration(
          color: AppColors.black,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: _icon(true),
      ),
    );
  }

  Widget _icon(bool active) {
    return SvgPicture.asset(
      item.asset,
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(
        active ? AppColors.white : AppColors.textMuted,
        BlendMode.srcIn,
      ),
      placeholderBuilder: (ctx) => Icon(
        item.fallback,
        size: 20,
        color: active ? AppColors.white : AppColors.textMuted,
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
