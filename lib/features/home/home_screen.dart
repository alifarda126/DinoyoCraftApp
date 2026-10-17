import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/dc_app_header.dart';
import '../../core/widgets/product_card.dart';
import '../../data/mock_data.dart';

class HomeScreen extends StatefulWidget {
const   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = 'Semua';

  // ── Banner carousel ──────────────────────────────────────────────────────
  static const _banners = [
    AppAssets.bannerDiskon,
    AppAssets.bannerPromo,
    AppAssets.bannerTradisi,
  ];
  final _pageCtrl = PageController();
  int _bannerPage = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_bannerPage + 1) % _banners.length;
      _pageCtrl.animateToPage(
        next,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final picks = MockData.filterProducts(category: _category)
        .take(4)
        .toList();

    return CustomScrollView(
      slivers: [
        SliverPinnedDcHeader(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location label
                Text(
                  'Sentra Keramik Dinoyo, Kota Malang',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 10),
                // Hero headline — sesuai Proto_Final/Beranda.png
                Text(
                  'Tanah liat Dinoyo, dari roda\npemutar langsung ke\ntanganmu.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.22,
                    letterSpacing: -0.4,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 8),
                // Sub-headline — sesuai Proto_Final/Beranda.png
                Text(
                  'Temukan karya keramik lokal dan pengalaman kreatif dari pengrajin Dinoyo.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 18),
                // ── Promo Banner Carousel ──────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageCtrl,
                          itemCount: _banners.length,
                          onPageChanged: (i) =>
                              setState(() => _bannerPage = i),
                          itemBuilder: (context, i) => GestureDetector(
                            onTap: () => context.go('/products'),
                            child: Image.asset(
                              _banners[i],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        // Dot indicator
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _banners.length,
                              (i) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _pageCtrl.animateToPage(
                                  i,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 250),
                                    width: _bannerPage == i ? 20 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: _bannerPage == i
                                          ? Colors.white
                                          : Colors.white
                                              .withValues(alpha: 0.55),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 22),
                // Jelajahi Kategori row — dengan "Lihat Semua"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jelajahi Kategori',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/products'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size(44, 36),
                      ),
                      child: Text(
                        'Lihat Semua',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Tinggi & spacing chip disamakan dengan halaman Produk.
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: MockData.categories.length,
                    separatorBuilder: (_, _) => SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final cat = MockData.categories[i];
                      return CategoryChip(
                        label: cat,
                        selected: cat == _category,
                        // Filter lokal di Beranda — TIDAK berpindah halaman.
                        onTap: () => setState(() => _category = cat),
                      );
                    },
                  ),
                ),
                SizedBox(height: 18),
                // Pilihan Untukmu row
                Row(
                  children: [
                    Text(
                      'Pilihan Untukmu',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () => context.go('/products'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size(44, 40),
                      ),
                      child: Text(
                        'Lihat semua',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Karya keramik favorit dari pengrajin lokal.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
        if (picks.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: Text(
                'Tidak ada produk yang cocok.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverGrid(
              // Ratio & spacing disamakan dengan grid di halaman Produk
              // agar ukuran kartu konsisten antar halaman.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 14,
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductCard(product: picks[index]),
                childCount: picks.length,
              ),
            ),
          ),
      ],
    );
  }
}
