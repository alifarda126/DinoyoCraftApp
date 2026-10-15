import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/product_card.dart';
import '../../data/mock_data.dart';

const Color _borderColor = Color(0xFFE5E5E5);
const double _padH = 24;

class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({super.key, required this.storeIndex});
  final int storeIndex;

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = MockData.stores[
        widget.storeIndex.clamp(0, MockData.stores.length - 1)];
    final products = MockData.products
        .where((product) => product.studio == store.name)
        .toList();
    final allProducts =
        products.isEmpty ? MockData.products.take(4).toList() : products;
    final shownProducts = allProducts
        .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar: back + judul (rata kiri) + ikon bantuan ──
            SizedBox(
              height: 52,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                  ),
                  Expanded(
                    child: Text(
                      'Profil Toko',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/help'),
                    icon: const Icon(
                      Icons.help_outline_rounded,
                      size: 22,
                      color: Color(0xFF404040),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 32),
                children: [
                  // ── Banner full-width + avatar yang menimpa banner ──
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AspectRatio(
                        aspectRatio: 2.9,
                        child: Image.asset(
                          store.image,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: _padH,
                        bottom: -24,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x26000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.asset(store.image, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Baris rating (kanan) di bawah banner — tap ke ulasan ──
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(_padH, 0, _padH, 6),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () => context.push(
                            '/reviews?store=${Uri.encodeComponent(store.name)}',
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFF5A623),
                                  size: 15,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  store.rating.toStringAsFixed(1),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                // TODO: ganti dengan jumlah ulasan asli jika ada di model
                                Text(
                                  ' (128 Ulasan)',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _padH),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          store.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ── Deskripsi dalam kotak berborder ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _borderColor),
                          ),
                          child: Text(
                            store.description,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              height: 1.5,
                              color: const Color(0xFF404040),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── Tombol Chat Toko ──
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: FilledButton.icon(
                            onPressed: () => context.push(
                              '/chat-room?store=${Uri.encodeComponent(store.name)}',
                            ),
                            icon: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 16,
                            ),
                            label: Text(
                              'Chat Toko',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.black,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ── Search produk toko ──
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _query = v),
                            style: GoogleFonts.plusJakartaSans(fontSize: 12),
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: const Color(0xFFF7F7F7),
                              hintText: 'Cari produk di toko ini...',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: const Color(0xFF737373),
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                size: 18,
                                color: Color(0xFFA3A3A3),
                              ),
                              suffixIcon: _query.isEmpty
                                  ? null
                                  : IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _query = '');
                                      },
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 16,
                                        color: Color(0xFFA3A3A3),
                                      ),
                                    ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: _borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.black),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Header katalog ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Katalog',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Menampilkan ${shownProducts.length} Produk',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        if (shownProducts.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                'Produk tidak ditemukan',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: shownProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.58,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 28,
                            ),
                            itemBuilder: (_, index) =>
                                ProductCard(product: shownProducts[index]),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
