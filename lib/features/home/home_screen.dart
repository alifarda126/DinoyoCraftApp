import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    final picks = MockData.filterProducts(category: _category)
        .take(4)
        .toList();

    return CustomScrollView(
      slivers: [
        const SliverPinnedDcHeader(),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 8),
                // Sub-headline — sesuai Proto_Final/Beranda.png
                Text(
                  'Temukan karya keramik lokal dan pengalaman kreatif dari pengrajin Dinoyo.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                // Promo banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      AppAssets.promoBanner,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
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
                        minimumSize: const Size(44, 36),
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
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: MockData.categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final cat = MockData.categories[i];
                      final active = cat == _category;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: active,
                        onSelected: (_) {
                          setState(() => _category = cat);
                          if (cat != 'Semua') {
                            context.go('/products?category=$cat');
                          }
                        },
                        selectedColor: AppColors.black,
                        backgroundColor: AppColors.inputBg,
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active ? AppColors.white : AppColors.ink,
                        ),
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
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
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.go('/products'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(44, 40),
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
                const SizedBox(height: 12),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 14,
                childAspectRatio: 0.58,
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
