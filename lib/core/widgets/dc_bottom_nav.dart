import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets.dart';
import '../app_text.dart';
import '../theme/app_colors.dart';

class DcBottomNav extends StatelessWidget {
  const DcBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  // Label diterjemahkan saat build (mengikuti AppSettings.locale).
  static const _items = [
    _NavItem('nav.home', AppAssets.navBerandaActive, Icons.home_rounded),
    _NavItem('nav.products', AppAssets.navProduk, Icons.shopping_bag_outlined),
    _NavItem('nav.stores', AppAssets.navToko, Icons.storefront_outlined),
    _NavItem(
        'nav.workshop', AppAssets.navWorkshop, Icons.location_on_outlined),
    _NavItem('nav.profile', AppAssets.navProfil, Icons.person_outline_rounded),
  ];

  // Tinggi bar konten (items layer) — cukup untuk icon+label
  static const double _barHeight = 76.0;
  // Tinggi background glass — lebih pendek dari items,
  // agar icon active yang pop ke atas bisa "mencuat" keluar dari background
  static const double _bgHeight = 58.0;
  // Ruang ekstra di atas agar icon pop-up tidak terpotong
  static const double _overflowTop = 20.0;

  /// Menghitung bottom padding yang adaptif untuk berbagai mode navigasi sistem:
  /// - Gestur swipe (rawBottom <= 28px): mempertahankan padding ideal seperti semula.
  /// - 3 gestur Android (3-button navigation, rawBottom >= 36px, biasanya 48px):
  ///   mengangkat navbar setinggi tombol navigasi + sedikit margin agar label
  ///   (Beranda, Produk, Toko, Workshop, Profil) tidak terpotong.
  /// - Web / desktop / no-inset (rawBottom < 8px): fallback 8px.
  static double getBottomPadding(BuildContext context) {
    final viewPad = MediaQuery.viewPaddingOf(context).bottom;
    final pad = MediaQuery.paddingOf(context).bottom;
    final rawBottom = viewPad > 0 ? viewPad : pad;

    if (rawBottom >= 36.0) {
      // Navigasi 3 tombol Android (biasanya 48px): beri ruang tombol sistem + margin
      return rawBottom + 4.0;
    }
    if (rawBottom > 28.0) {
      // iOS safe area indicator (34px)
      return rawBottom;
    }
    // Gestur swipe Android (16-28px) atau fallback 8px untuk layar tanpa inset
    return rawBottom.clamp(8.0, 28.0);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = getBottomPadding(context);
    final totalHeight = _barHeight + bottomPad + _overflowTop;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        // Stack bebas overflow ke atas — icon tidak terpotong
        clipBehavior: Clip.none,
        children: [
          // ── Layer 1: iOS authentic frosted glass background ─────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            // Background lebih pendek (_bgHeight) dari items layer (_barHeight)
            // → icon active yang pop ke atas akan mencuat keluar dari background
            height: _bgHeight + bottomPad,
            child: Container(
              // Shadow diffused ke atas di luar clip agar tidak terpotong
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: AppColors.isDark ? 0.40 : 0.08,
                    ),
                    blurRadius: 28,
                    spreadRadius: 0,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: BackdropFilter(
                  // Blur intensitas iOS (transparan & jernih sehingga objek di baliknya terlihat)
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                      // Transparansi khas iOS Liquid / Frosted Glass jernih
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: AppColors.isDark
                            ? [
                                const Color(0xFF2C2C2E).withValues(alpha: 0.35),
                                const Color(0xFF1C1C1E).withValues(alpha: 0.20),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.22),
                                Colors.white.withValues(alpha: 0.08),
                              ],
                      ),
                      border: Border(
                        top: BorderSide(
                          color: AppColors.navigationBorder,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // iOS specular rim glint (kilau bevel atas kaca khas Apple)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 1.2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.10),
                                  Colors.white.withValues(
                                    alpha: AppColors.isDark ? 0.45 : 0.95,
                                  ),
                                  Colors.white.withValues(alpha: 0.10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
          duration: Duration(milliseconds: 280),
          curve: Curves.easeOutBack,
          builder: (ctx, dy, child) {
            return Transform.translate(
              offset: Offset(0, dy),
              child: child,
            );
          },
          child: _IconBubble(active: active, item: item),
        ),
        SizedBox(height: 4),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: active ? FontWeight.w700 : FontWeight.w600,
            color: active
                ? AppColors.ink
                : (AppColors.isDark
                    ? const Color(0xFFE4E4E7)
                    : const Color(0xFF27272A)),
            shadows: [
              Shadow(
                color: (AppColors.isDark ? Colors.black : Colors.white)
                    .withValues(alpha: 0.75),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            AppText.get(item.label),
            // Label tidak boleh wrap: di lebar item ekstrem (window di-resize
            // sangat sempit / split screen) teks membungkus puluhan baris dan
            // membuat Column meluap dari tinggi bar 76px.
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
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
        // Stroke putih tipis kaca bercahaya di luar circle hitam
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.95),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.transparent,
      ),
      // inner circle hitam mengisi hampir penuh (margin 1.5px ikut border)
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: AppColors.black,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: _icon(true),
      ),
    );
  }

  Widget _icon(bool active) {
    final Color iconColor = active
        ? AppColors.white
        : (AppColors.isDark
            ? const Color(0xFFE4E4E7)
            : const Color(0xFF27272A));

    return SvgPicture.asset(
      item.asset,
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(
        iconColor,
        BlendMode.srcIn,
      ),
      placeholderBuilder: (ctx) => Icon(
        item.fallback,
        size: 20,
        color: iconColor,
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
