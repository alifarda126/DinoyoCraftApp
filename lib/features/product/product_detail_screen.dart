import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/dc_cached_image.dart';
import '../../core/widgets/image_preview_dialog.dart';
import '../../core/network/api_client.dart';
import '../../data/mock_data.dart';
import '../review/presentation/modal_laporkan_ulasan.dart';
import 'presentation/modal_laporkan_produk.dart';
import 'presentation/modal_pilih_variasi.dart';

/// Halaman Detail Produk — disesuaikan dengan desain
/// Halaman_detail_produk_saat_ditekan.png.
class ProductDetailScreen extends StatefulWidget {
const   ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  late final PageController _imagePageController;
  Product? _liveProduct;

  @override
  void initState() {
    super.initState();
    _imagePageController = PageController();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    if (widget.productId.trim().isEmpty) return;
    try {
      final res = await ApiClient.get('/products/${widget.productId}/public');
      if (res['success'] == true && res['data'] is Map<String, dynamic>) {
        final p = Product.fromJson(res['data'] as Map<String, dynamic>);
        MockData.upsertProduct(p);
        if (mounted) {
          setState(() {
            _liveProduct = p;
          });
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final product = _liveProduct ??
        MockData.products.firstWhere(
          (item) => item.id == widget.productId,
          orElse: () => MockData.products.isNotEmpty
              ? MockData.products.first
              : MockData.fallbackProduct,
        );
    final totalStock = product.effectiveStock;
    final matchedStore = MockData.stores.where((s) {
      if (product.mitraId > 0 && s.id > 0) return s.id == product.mitraId;
      return s.name.trim().toLowerCase() == product.studio.trim().toLowerCase();
    }).firstOrNull;

    return AppBackScope(
      fallbackRoute: '/products',
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              _TopBar(
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/products');
                  }
                },
                onShare: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: 'https://dinoyocraft.id/product/${widget.productId}',
                    ),
                  );
                  _toast('Tautan produk disalin ke clipboard');
                },
                onReport: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final result = await showModalLaporkanProduk(
                    context,
                    productId: product.id,
                    productName: product.name,
                    productImage: product.image,
                  );
                  if (result == true && mounted) {
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
                                'Laporan berhasil dikirim. Terima kasih telah membantu menjaga komunitas DinoyoCraft.'
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
                },
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadProduct,
                color: AppColors.ink,
                backgroundColor: AppColors.surfaceElevated,
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                  // ── Gambar produk Carousel (PageView) + indikator N / Total + Fullscreen Preview ──
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          controller: _imagePageController,
                          itemCount: product.gallery.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final imagePath = product.gallery[index];
                            return GestureDetector(
                              key: Key(index == 0
                                  ? 'product_image_preview_tap'
                                  : 'product_image_preview_tap_$index'),
                              onTap: () {
                                ImagePreviewDialog.show(
                                  context,
                                  title: product.name,
                                  subtitle:
                                      '${product.studio} • Foto ${index + 1} dari ${product.gallery.length}',
                                  assetPath: imagePath,
                                );
                              },
                              child: DcCachedImage(
                                imageUrl: imagePath,
                                fit: BoxFit.cover,
                                errorWidget: Container(
                                  color: AppColors.inputBg,
                                  child: Icon(
                                    Icons.broken_image_rounded,
                                    size: 40,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Tombol / Badge "Perbesar" di kiri bawah
                        Positioned(
                          left: 12,
                          bottom: 12,
                          child: GestureDetector(
                            onTap: () {
                              final activeImage =
                                  product.gallery[_currentImageIndex];
                              ImagePreviewDialog.show(
                                context,
                                title: product.name,
                                subtitle:
                                    '${product.studio} • Foto ${_currentImageIndex + 1} dari ${product.gallery.length}',
                                assetPath: activeImage,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: .65),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.fullscreen_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Perbesar'.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Indikator "1 / 4", "2 / 4", dll di kanan bawah
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: .75),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${_currentImageIndex + 1} / ${product.gallery.length}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: _titleStyle),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                MockData.formatPrice(product.price),
                                style: _priceStyle,
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: totalStock > 0
                                      ? AppColors.surfaceSubtle
                                      : AppColors.danger.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: totalStock > 0
                                        ? AppColors.border
                                        : AppColors.danger.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Text(
                                  totalStock > 0
                                      ? '${AppText.isEnglish ? 'Stock' : 'Stok'}: $totalStock ${AppText.isEnglish ? 'items' : 'buah'}'
                                      : (AppText.isEnglish ? 'Out of stock' : 'Stok Habis'),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: totalStock > 0
                                        ? AppColors.ink
                                        : AppColors.danger,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _MetaRow(
                            rating: product.rating,
                            totalReviews: product.totalReviews,
                            soldCount: product.soldCount,
                            store: product.studio,
                          ),
                          if (product.variants.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            Text(
                              '${AppText.isEnglish ? 'Color / Glaze Variants' : 'Pilihan Warna / Glaze'} (${product.variants.length})',
                              style: _sectionStyle,
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: product.variants.map((v) {
                                return GestureDetector(
                                  onTap: () => showModalPilihVariasi(
                                    context,
                                    product: product,
                                    mode: ModalVariasiMode.keduanya,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: v.colorValue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.border,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${v.name} (${v.stock})',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: v.stock > 0
                                                ? AppColors.ink
                                                : AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(height: 22),

                          _StoreCard(
                            studio: product.studio,
                            location: matchedStore?.location.isNotEmpty == true
                                ? matchedStore!.location
                                : (product.workshopAddress.isNotEmpty
                                      ? product.workshopAddress
                                      : 'Kampung Keramik Dinoyo'),
                            avatarUrl: matchedStore?.hasCustomAvatar == true
                                ? (matchedStore!.avatar ?? matchedStore.image)
                                : null,
                            initials: matchedStore?.initials,
                            onTap: () {
                              final storeIndex = MockData.stores.indexWhere(
                                (s) =>
                                    (product.mitraId > 0 && s.id == product.mitraId) ||
                                    s.name.trim().toLowerCase() ==
                                        product.studio.trim().toLowerCase(),
                              );
                              context.push(
                                '/store/${storeIndex < 0 ? 0 : storeIndex}',
                              );
                            },
                          ),
                          const SizedBox(height: 22),

                          Text('Deskripsi Produk'.tr, style: _sectionStyle),
                          const SizedBox(height: 8),
                          Text(
                            product.description.trim().isNotEmpty
                                ? product.description.trim()
                                : (AppText.isEnglish
                                      ? 'No product description provided by the artisan.'
                                      : 'Belum ada deskripsi produk dari pengrajin.'),
                            style: _bodyStyle,
                          ),
                          const SizedBox(height: 18),

                          _SpecCard(product: product),
                          const SizedBox(height: 14),
                          const _GuaranteeCard(),
                          const SizedBox(height: 14),
                          _RatingSummary(
                            rating: product.rating,
                            totalReviews: product.totalReviews,
                            reviews: product.reviews,
                          ),
                          const SizedBox(height: 16),

                          if (product.reviews.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  AppText.isEnglish
                                      ? 'No customer reviews for this product yet.'
                                      : 'Belum ada ulasan pembeli untuk produk ini.',
                                  style: _smallGrey,
                                ),
                              ),
                            )
                          else ...[
                            for (var rIdx = 0;
                                rIdx < product.reviews.length;
                                rIdx++) ...[
                              if (rIdx > 0) const SizedBox(height: 14),
                              Builder(
                                builder: (_) {
                                  final rev = product.reviews[rIdx];
                                  return _ReviewCard(
                                    review: _Review(
                                      name: rev.userName,
                                      initials: _reviewerInitials(rev.userName),
                                      date: (rev.createdAt ?? '').length >= 10
                                          ? rev.createdAt!.substring(0, 10)
                                          : 'Baru saja',
                                      variantLabel: rev.variant.isNotEmpty
                                          ? rev.variant
                                          : 'Standar',
                                      variantProduct: product.name,
                                      text: rev.comment,
                                      helpfulCount: rev.helpfulCount,
                                      photo: rev.photoUrls.isNotEmpty
                                          ? rev.photoUrls.first
                                          : null,
                                      replyAuthor: rev.sellerReply != null
                                          ? product.studio
                                          : null,
                                      reply: rev.sellerReply,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom bar: Chat | Keranjang | Beli Langsung ──
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => context.push(
                        '/chat-room?store=${Uri.encodeComponent(product.studio)}&productId=${product.id}',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        foregroundColor: AppColors.ink,
                        side: BorderSide(color: AppColors.ink, width: 1.5),
                      ),
                      child: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: totalStock > 0
                            ? () => showModalPilihVariasi(
                                context,
                                product: product,
                                mode: ModalVariasiMode.keranjang,
                              )
                            : null,
                        icon: SvgPicture.asset(
                          AppAssets.iconCartPlus,
                          width: 19,
                          height: 19,
                          colorFilter: ColorFilter.mode(
                            totalStock > 0 ? AppColors.ink : AppColors.textMuted,
                            BlendMode.srcIn,
                          ),
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Keranjang'.tr,
                            maxLines: 1,
                            softWrap: false,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          foregroundColor: totalStock > 0
                              ? AppColors.ink
                              : AppColors.textMuted,
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            color: totalStock > 0
                                ? AppColors.ink
                                : AppColors.border,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: totalStock > 0
                              ? AppColors.darkButtonShadow
                              : const [],
                        ),
                        child: FilledButton(
                          onPressed: totalStock > 0
                              ? () => showModalPilihVariasi(
                                  context,
                                  product: product,
                                  mode: ModalVariasiMode.beliLangsung,
                                )
                              : null,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            backgroundColor: AppColors.black,
                            disabledBackgroundColor: AppColors.border,
                            foregroundColor: AppColors.white,
                            disabledForegroundColor: AppColors.textMuted,
                            elevation: 0,
                            shape: AppColors.stadiumButtonShape,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              totalStock > 0
                                  ? 'Beli Langsung'.tr
                                  : (AppText.isEnglish
                                        ? 'Out of Stock'
                                        : 'Stok Habis'),
                              maxLines: 1,
                              softWrap: false,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
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
          ],
        ),
      ),
    ),
  );
}
}

// ═══ Styles ═════════════════════════════════════════════════════════════════
final _titleStyle = GoogleFonts.plusJakartaSans(
  fontSize: 22,
  fontWeight: FontWeight.w700,
  color: AppColors.ink,
);
final _priceStyle = GoogleFonts.plusJakartaSans(
  fontSize: 26,
  fontWeight: FontWeight.w800,
  color: AppColors.ink,
);
final _sectionStyle = GoogleFonts.plusJakartaSans(
  fontSize: 17,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);
final _bodyStyle = GoogleFonts.plusJakartaSans(
  fontSize: 14,
  height: 1.6,
  color: AppColors.textSecondary,
);
final _smallGrey = GoogleFonts.plusJakartaSans(
  fontSize: 12,
  color: AppColors.textSecondary,
);

const _starColor = Color(0xFFF5A623);

// ═══ Top bar: ← ........ share ⋮ ═══════════════════════════════════════════
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onBack,
    required this.onShare,
    this.onReport,
  });

  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback? onReport;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark;

    return SizedBox(
      height: 54,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back_rounded, size: 22),
            color: AppColors.ink,
          ),
          Spacer(),
          IconButton(
            onPressed: onShare,
            icon: Icon(Icons.share_outlined, size: 20),
            color: AppColors.ink,
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
              shadowColor: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? AppColors.border : const Color(0xFFE5E5E5),
                  width: 1,
                ),
              ),
              offset: const Offset(0, 48),
              onSelected: (value) {
                if (value == 'home') {
                  context.go('/home');
                } else if (value == 'help') {
                  context.push('/help');
                } else if (value == 'report') {
                  onReport?.call();
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
                const _MenuDivider(),
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
                const _MenuDivider(),
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
                          'Laporkan Produk'.tr,
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
          SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _MenuDivider extends PopupMenuEntry<Never> {
  const _MenuDivider();

  @override
  final double height = 1;

  @override
  bool represents(Never? value) => false;

  @override
  State<_MenuDivider> createState() => _MenuDividerState();
}

class _MenuDividerState extends State<_MenuDivider> {
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

// ═══ ★ Rating • N Ulasan • Terjual M ═══════════════════════════════════════════
class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.rating,
    required this.totalReviews,
    required this.soldCount,
    required this.store,
  });

  final double rating;
  final int totalReviews;
  final int soldCount;
  final String store;

  Widget _dot() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        color: AppColors.textMuted,
        shape: BoxShape.circle,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.plusJakartaSans(
      fontSize: 13,
      color: AppColors.textSecondary,
    );
    final ratingLabel = totalReviews > 0 && rating > 0
        ? rating.toStringAsFixed(1)
        : (AppText.isEnglish ? 'New' : 'Baru');
    final reviewsLabel = '$totalReviews ${AppText.isEnglish ? 'Reviews' : 'Ulasan'}';
    final soldLabel = '${AppText.isEnglish ? 'Sold' : 'Terjual'} $soldCount';

    return Row(
      children: [
        Icon(Icons.star_rounded, size: 18, color: AppColors.ink),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            ratingLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        _dot(),
        Flexible(
          child: GestureDetector(
            onTap: () =>
                context.push('/reviews?store=${Uri.encodeComponent(store)}'),
            child: Text(
              reviewsLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        _dot(),
        Flexible(
          child: Text(
            soldLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

// ═══ Kartu toko ═════════════════════════════════════════════════════════════
class _StoreCard extends StatelessWidget {
  const _StoreCard({
    required this.studio,
    required this.location,
    this.avatarUrl,
    this.initials,
    required this.onTap,
  });

  final String studio;
  final String location;
  final String? avatarUrl;
  final String? initials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.ink, width: 1.5),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.ink, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: avatarUrl != null && avatarUrl!.isNotEmpty
              ? DcCachedImage(
                  imageUrl: avatarUrl!,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                )
              : Center(
                  child: (initials != null && initials!.isNotEmpty)
                      ? Text(
                          initials!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        )
                      : Icon(
                          Icons.storefront_outlined,
                          size: 24,
                          color: AppColors.ink,
                        ),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                studio,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 13,
                    color: AppColors.ink,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.ink,
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const StadiumBorder(),
            side: BorderSide(color: AppColors.ink, width: 1.2),
          ),
          child: Text(
            'Kunjungi Toko'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

// ═══ Spesifikasi detail (grid 2 kolom) ══════════════════════════════════════
class _SpecCard extends StatelessWidget {
  const _SpecCard({required this.product});

  final Product product;

  Widget _cell(String label, String value) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _smallGrey),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.35,
            color: AppColors.ink,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final stockText = product.effectiveStock <= 0
        ? (AppText.isEnglish ? 'Out of stock' : 'Habis')
        : '${product.effectiveStock} ${AppText.isEnglish ? 'units' : 'unit'}';
    final variantText = product.variants.isEmpty
        ? (AppText.isEnglish ? 'Standard' : 'Standar')
        : '${product.variants.length} ${AppText.isEnglish ? 'variants' : 'varian'}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink, width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Spesifikasi Detail'.tr, style: _sectionStyle),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cell('Kategori'.tr, product.category),
              const SizedBox(width: 12),
              _cell(AppText.isEnglish ? 'Available Stock' : 'Total Stok', stockText),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cell(AppText.isEnglish ? 'Color Variants' : 'Varian Warna', variantText),
              const SizedBox(width: 12),
              _cell('Berat Bersih'.tr, '${product.weightGram} gram'),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══ Garansi kemasan ════════════════════════════════════════════════════════
class _GuaranteeCard extends StatelessWidget {
  const _GuaranteeCard();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.inputBg,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.local_shipping_outlined,
                size: 18, color: AppColors.ink),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Garansi Kemasan Aman Dinoyo'.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(
            'Setiap keramik dibalut triple bubble wrap & kotak kardus tebal untuk memastikan produk sampai utuh.'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    ),
  );
}

// ═══ Ringkasan rating ═══════════════════════════════════════════════════════
class _RatingSummary extends StatelessWidget {
  const _RatingSummary({
    required this.rating,
    required this.totalReviews,
    required this.reviews,
  });

  final double rating;
  final int totalReviews;
  final List<ProductReview> reviews;

  Widget _barRow(int star, double value, String pct) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.5),
    child: Row(
      children: [
        SizedBox(
          width: 14,
          child: Text(
            '$star',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.ink,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(AppColors.black),
            ),
          ),
        ),
        SizedBox(
          width: 38,
          child: Text(
            pct,
            textAlign: TextAlign.right,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final counts = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final rev in reviews) {
      final rounded = rev.rating.round().clamp(1, 5);
      counts[rounded] = (counts[rounded] ?? 0) + 1;
    }
    final denom = reviews.isNotEmpty ? reviews.length : 1;
    final recCount = reviews.where((r) => r.rating >= 4.0).length;
    final recPct = reviews.isNotEmpty
        ? ((recCount / reviews.length) * 100).round()
        : 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Text(
                      totalReviews > 0 && rating > 0
                          ? rating.toStringAsFixed(1)
                          : '0.0',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    _Stars(
                      size: 20,
                      rating: totalReviews > 0 ? rating : 0,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalReviews ${AppText.isEnglish ? 'reviews' : 'ulasan'}',
                      style: _smallGrey,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    for (final star in [5, 4, 3, 2, 1])
                      Builder(
                        builder: (_) {
                          final frac = reviews.isNotEmpty
                              ? (counts[star] ?? 0) / denom
                              : 0.0;
                          final pct = '${(frac * 100).round()}%';
                          return _barRow(star, frac, pct);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.thumb_up_alt_outlined,
                    size: 17, color: AppColors.ink),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    reviews.isNotEmpty
                        ? (AppText.isEnglish
                              ? '$recPct% of buyers recommend this product'
                              : '$recPct% pembeli merekomendasikan produk ini')
                        : (AppText.isEnglish
                              ? 'Be the first to review this ceramic piece'
                              : 'Jadilah pembeli pertama yang mengulas produk ini'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({this.size = 15, this.rating = 5.0});
  final double size;
  final double rating;

  @override
  Widget build(BuildContext context) {
    final filledCount = rating.round().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < filledCount ? Icons.star_rounded : Icons.star_outline_rounded,
          color: i < filledCount ? _starColor : AppColors.textMuted,
          size: size,
        ),
      ),
    );
  }
}

// ═══ Ulasan ═════════════════════════════════════════════════════════════════
String? _reviewerInitials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return null;
  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

class _Review {
  const _Review({
    required this.name,
    required this.date,
    required this.variantLabel,
    required this.variantProduct,
    required this.text,
    required this.helpfulCount,
    this.initials,
    this.photo,
    this.reply,
    this.replyAuthor,
  });

  final String name;
  final String? initials;
  final String date;
  final String variantLabel;
  final String variantProduct;
  final String text;
  final int helpfulCount;
  final String? photo;
  final String? reply;
  final String? replyAuthor;
}

class _ReviewCard extends StatefulWidget {
  const _ReviewCard({required this.review});
  final _Review review;

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _helpful = false;

  _Review get review => widget.review;

  Widget _helpfulPill() {
    final active = _helpful;
    return InkWell(
      onTap: () => setState(() => _helpful = !_helpful),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.ink : Colors.transparent,
          border: Border.all(color: AppColors.border, width: 1.2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
              size: 15,
              color: active ? AppColors.white : AppColors.ink,
            ),
            SizedBox(width: 6),
            Text(
              'Membantu (${review.helpfulCount + (active ? 1 : 0)})',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: active ? AppColors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark;
    final hasPhoto = review.photo != null;
    final hasReply = review.reply != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: avatar, nama, tanggal, ⋮ ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.inputBg,
                child: review.initials != null
                    ? Text(
                        review.initials!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      )
                    : Icon(Icons.person, size: 22, color: AppColors.ink),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(review.date, style: _smallGrey),
                  ],
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
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 18,
                    color: AppColors.ink,
                  ),
                  color: AppColors.surface,
                  surfaceTintColor: Colors.transparent,
                  elevation: 6,
                  shadowColor:
                      Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color:
                          isDark ? AppColors.border : const Color(0xFFE5E5E5),
                      width: 1,
                    ),
                  ),
                  offset: const Offset(0, 36),
                  onSelected: (value) async {
                    if (value == 'copy') {
                      Clipboard.setData(ClipboardData(text: review.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          content: Text('Ulasan disalin'.tr),
                        ),
                      );
                    } else if (value == 'report') {
                      final messenger = ScaffoldMessenger.of(context);
                      final res = await showModalLaporkanUlasan(
                        context,
                        reviewerName: review.name,
                        reviewText: review.text,
                      );
                      if (res == true && context.mounted) {
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
                                    'Terima kasih, laporan ulasan berhasil dikirim.'
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
                      value: 'copy',
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.copy_rounded,
                            size: 20,
                            color: AppColors.ink,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Salin Ulasan'.tr,
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
                    const _MenuDivider(),
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
                              'Laporkan Ulasan'.tr,
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
            ],
          ),
          SizedBox(height: 10),
          const _Stars(size: 15),
          SizedBox(height: 8),

          // ── Varian ──
          Text.rich(
            TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(text: 'Varian: ${review.variantLabel} - '),
                TextSpan(
                  text: review.variantProduct,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // ── Isi ulasan ──
          Text(
            review.text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.55,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: 12),

          // ── Footer: Membantu ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _helpfulPill(),
              Flexible(
                child: Text(
                  'Apakah ulasan ini bermanfaat?'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          // ── Foto ulasan ──
          if (hasPhoto) ...[
            SizedBox(height: 12),
            GestureDetector(
              key: const Key('review_card_photo_tap'),
              onTap: () {
                ImagePreviewDialog.show(
                  context,
                  title: 'Foto Ulasan'.tr,
                  subtitle: '${review.name} • ${review.variantLabel}',
                  assetPath: review.photo!,
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: DcCachedImage(
                      imageUrl: review.photo!,
                      width: 142,
                      height: 142,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fullscreen_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Balasan penjual ──
          if (hasReply) ...[
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.storefront_outlined,
                          size: 14, color: AppColors.ink),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          review.replyAuthor ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    review.reply!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}