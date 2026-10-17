import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/dc_app_header.dart';
import '../../core/widgets/product_card.dart';
import '../../data/mock_data.dart';

class ProductsScreen extends StatefulWidget {
const   ProductsScreen({super.key, this.initialCategory = 'Semua'});

  final String initialCategory;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late String _category;
  String _query = '';

  @override
  void initState() {
    super.initState();
    final cat = widget.initialCategory;
    _category = MockData.categories.contains(cat) ? cat : 'Semua';
  }

  @override
  void didUpdateWidget(covariant ProductsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategory != widget.initialCategory) {
      final cat = widget.initialCategory;
      _category = MockData.categories.contains(cat) ? cat : 'Semua';
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = MockData.filterProducts(category: _category, query: _query);

    return Scaffold(
      // Scaffold diperlukan sebagai ancestor Material untuk TextField;
      // tanpa ini halaman melempar error rendering.
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
        SliverPinnedDcHeader(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produk Keramik',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 14),
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Cari produk atau studio...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        AppAssets.iconSearch,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          AppColors.textMuted,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.inputBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                SizedBox(height: 14),
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
                        onTap: () => setState(() => _category = cat),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(product: items[index]),
              childCount: items.length,
            ),
          ),
        ),
        ],
      ),
    );
  }
}
