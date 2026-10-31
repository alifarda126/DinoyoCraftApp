import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/dc_app_header.dart';
import '../../core/widgets/product_card.dart';
import '../../data/mock_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = 'Semua';

  // ── Banner carousel (Infinite Loop UX) ──────────────────────────────────
  static const _banners = [
    AppAssets.bannerDiskon,
    AppAssets.bannerPromo,
    AppAssets.bannerTradisi,
  ];
  static const int _kInitialPage = 3000;
  late final PageController _pageCtrl =
      PageController(initialPage: _kInitialPage);
  int _bannerPage = _kInitialPage;
  Timer? _bannerTimer;

  int get _activeBannerIndex =>
      ((_bannerPage % _banners.length) + _banners.length) % _banners.length;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageCtrl.hasClients) return;
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 500),
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

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final picks = MockData.filterProducts(category: _category)
        .take(4)
        .toList();
    final topHeaderHeight = DcAppHeader.totalHeight(context);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppColors.ink,
      backgroundColor: AppColors.surfaceElevated,
      edgeOffset: topHeaderHeight,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
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
                  'Sentra Keramik Dinoyo, Kota Malang'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 10),
                // Hero headline — sesuai Proto_Final/Beranda.png
                Text(
                  'Tanah liat Dinoyo, dari roda\npemutar langsung ke\ntanganmu.'.tr,
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
                  'Temukan karya keramik lokal dan pengalaman kreatif dari pengrajin Dinoyo.'.tr,
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
                          onPageChanged: (i) =>
                              setState(() => _bannerPage = i),
                          itemBuilder: (context, i) {
                            final bannerIndex =
                                ((i % _banners.length) + _banners.length) %
                                    _banners.length;
                            return GestureDetector(
                              onTap: () => context.go('/products'),
                              child: Image.asset(
                                _banners[bannerIndex],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            );
                          },
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
                                onTap: () {
                                  final currentDot = _activeBannerIndex;
                                  final diff = i - currentDot;
                                  if (diff != 0 && _pageCtrl.hasClients) {
                                    _pageCtrl.animateToPage(
                                      _bannerPage + diff,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 250),
                                    width: _activeBannerIndex == i ? 20 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: _activeBannerIndex == i
                                          ? Colors.white
                                          : Colors.white
                                              .withValues(alpha: 0.55),
                                      borderRadius:
                                          BorderRadius.circular(3),
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
                    Flexible(
                      child: Text(
                        'Jelajahi Kategori'.tr,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/products'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size(44, 36),
                      ),
                      child: Text(
                        'Lihat Semua'.tr,
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
                    clipBehavior: Clip.none,
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
                // Pilihan Untukmu row — dengan "Lihat Semua" konsisten dengan Jelajahi Kategori
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Pilihan Untukmu'.tr,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/products'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size(44, 36),
                      ),
                      child: Text(
                        'Lihat Semua'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Karya keramik favorit dari pengrajin lokal.'.tr,
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
                'Tidak ada produk yang cocok.'.tr,
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
                mainAxisSpacing: 20,
                crossAxisSpacing: 14,
                childAspectRatio: 0.60,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductCard(product: picks[index]),
                childCount: picks.length,
              ),
            ),
          ),
      ],
    ),
  );
}
}
