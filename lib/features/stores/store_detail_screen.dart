import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/product_card.dart';
import '../../data/mock_data.dart';
import 'presentation/modal_laporkan_toko.dart';

Color get _borderColor => AppColors.border;
const double _padH = 24;

class StoreDetailScreen extends StatefulWidget {
const   StoreDetailScreen({super.key, required this.storeIndex});
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
    final isDark = AppColors.isDark;
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

    return AppBackScope(
      fallbackRoute: '/stores',
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              // ── App bar: back + judul (rata kiri) + titik 3 ──
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/stores');
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                    ),
                    Expanded(
                      child: Text(
                        'Profil Toko'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                        highlightColor: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.black.withValues(alpha: 0.03),
                      ),
                      child: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_rounded, size: 21),
                        color: AppColors.surface,
                        surfaceTintColor: Colors.transparent,
                        elevation: 6,
                        shadowColor: Colors.black
                            .withValues(alpha: isDark ? 0.4 : 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.border
                                : const Color(0xFFE5E5E5),
                            width: 1,
                          ),
                        ),
                        offset: const Offset(0, 48),
                        onSelected: (value) async {
                          if (value == 'home') {
                            context.go('/home');
                          } else if (value == 'share') {
                            Clipboard.setData(
                              ClipboardData(
                                text:
                                    'https://dinoyocraft.id/store/${widget.storeIndex}',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                content: Text(
                                  'Tautan profil toko disalin ke clipboard'.tr,
                                ),
                              ),
                            );
                          } else if (value == 'help') {
                            context.push('/help');
                          } else if (value == 'report') {
                            final messenger = ScaffoldMessenger.of(context);
                            final res = await showModalLaporkanToko(
                              context,
                              storeName: store.name,
                              storeImage: store.image,
                            );
                            if (res == true && mounted) {
                              messenger.showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.isDark
                                      ? const Color(0xFF2E2E2E)
                                      : const Color(0xFF1F1F1F),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFF4CAF50),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Terima kasih, laporan toko berhasil dikirim dan akan segera ditinjau oleh tim DinoyoCraft.'
                                              .tr,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'home',
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  size: 20,
                                  color: AppColors.ink,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Kembali ke Halaman Beranda'.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const _StoreMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'share',
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.share_outlined,
                                  size: 20,
                                  color: AppColors.ink,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Bagikan Toko'.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const _StoreMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'help',
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.help_outline_rounded,
                                  size: 20,
                                  color: AppColors.ink,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Butuh Bantuan'.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const _StoreMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'report',
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag_outlined,
                                  size: 20,
                                  color: AppColors.danger,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Laporkan Toko'.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.danger,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
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
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.surface, width: 3),
                            boxShadow: [
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
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFF5A623),
                                  size: 15,
                                ),
                                SizedBox(width: 3),
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
                        SizedBox(height: 8),
                        Text(
                          store.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 10),

                        // ── Deskripsi dalam kotak berborder ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _borderColor),
                          ),
                          child: Text(
                            store.description,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              height: 1.5,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        // ── Tombol Chat Toko ──
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: FilledButton.icon(
                            onPressed: () => context.push(
                              '/chat-room?store=${Uri.encodeComponent(store.name)}',
                            ),
                            icon: Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 16,
                            ),
                            label: Text(
                              'Chat Toko'.tr,
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
                        SizedBox(height: 10),

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
                              fillColor: AppColors.surfaceSubtle,
                              hintText: 'Cari produk di toko ini...'.tr,
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textZinc,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: 18,
                                color: AppColors.textMuted,
                              ),
                              suffixIcon: _query.isEmpty
                                  ? null
                                  : IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _query = '');
                                      },
                                      icon: Icon(
                                        Icons.close_rounded,
                                        size: 16,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: _borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: AppColors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // ── Header katalog ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Katalog'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${'Menampilkan'.tr} ${shownProducts.length} ${'Produk'.tr}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),

                        if (shownProducts.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                'Produk tidak ditemukan'.tr,
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
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: shownProducts.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
    ),
    );
  }
}

class _StoreMenuDivider extends PopupMenuEntry<Never> {
  const _StoreMenuDivider();

  @override
  final double height = 1;

  @override
  bool represents(Never? value) => false;

  @override
  State<_StoreMenuDivider> createState() => _StoreMenuDividerState();
}

class _StoreMenuDividerState extends State<_StoreMenuDivider> {
  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark ? AppColors.border : const Color(0xFFF0F0F0),
      ),
    );
  }
}
