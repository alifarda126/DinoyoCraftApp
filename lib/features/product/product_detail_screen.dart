import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
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
  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final product = MockData.products.firstWhere(
      (item) => item.id == widget.productId,
      orElse: () => MockData.products.first,
    );

    // Harga coret (mock) — sekitar 30% di atas harga jual.
    final originalPrice = ((product.price * 1.3) / 1000).round() * 1000;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              onBack: () => context.pop(),
              onShare: () {
                Clipboard.setData(
                  ClipboardData(
                    text: 'https://dinoyocraft.id/product/${widget.productId}',
                  ),
                );
                _toast('Tautan produk disalin ke clipboard');
              },
              onMore: () => _toast('Menu lainnya (mock)'),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // ── Gambar produk + indikator 1/4 ──
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(product.image, fit: BoxFit.cover),
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
                              '1 / 4',
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
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              MockData.formatPrice(product.price),
                              style: _priceStyle,
                            ),
                            SizedBox(width: 10),
                            Text(
                              MockData.formatPrice(originalPrice),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        _MetaRow(rating: product.rating, store: product.studio),
                        SizedBox(height: 22),

                        _StoreCard(
                          studio: product.studio,
                          onTap: () {
                            final storeIndex = MockData.stores
                                .indexWhere((s) => s.name == product.studio);
                            context.push(
                              '/store/${storeIndex < 0 ? 0 : storeIndex}',
                            );
                          },
                        ),
                        SizedBox(height: 22),

                        Text('Deskripsi Produk'.tr, style: _sectionStyle),
                        SizedBox(height: 8),
                        Text(
                          'Vas keramik stoneware buatan tangan pengrajin lokal '
                          'Dinoyo. Dibakar pada suhu tinggi 1.250°C '
                          'menghasilkan material yang padat, tahan air, dan '
                          'awet. Tekstur matte halus dengan sentuhan hangat '
                          'alami, cocok untuk dekorasi meja, bunga kering, '
                          'maupun interior minimalis.',
                          style: _bodyStyle,
                        ),
                        SizedBox(height: 18),

                        const _SpecCard(),
                        SizedBox(height: 14),
                        const _GuaranteeCard(),
                        SizedBox(height: 14),
                        const _RatingSummary(rating: 4.9),
                        SizedBox(height: 16),

                        _ReviewCard(
                          review: _Review(
                            name: 'Customer',
                            date: '12 Feb 2025',
                            variantLabel: 'Sand White Glossy',
                            variantProduct: product.name,
                            text:
                                'Glasirnya sangat halus dan rapi, warna aslinya '
                                'lebih estetik daripada di foto. Pengemasan kayu '
                                'sangat kokoh dan aman sampai rumah tanpa retak '
                                'sedikitpun. Sangat bangga dengan karya pengrajin '
                                'Dinoyo Malang!',
                            helpfulCount: 14,
                            photo: product.image,
                            replyAuthor: 'Dinoyo Ceramic Studio',
                            replyDate: '13 Feb 2025',
                            reply:
                                '"Terima kasih banyak Kak Customer atas apresiasinya! '
                                'Semoga vas keramiknya mempercantik ruangan rumah."',
                          ),
                        ),
                        SizedBox(height: 14),
                        const _ReviewCard(
                          review: _Review(
                            name: 'Rian Hidayat',
                            initials: 'RH',
                            date: '8 Feb 2025',
                            variantLabel: 'Earth Terracotta',
                            variantProduct: 'Mangkuk Saji Wabi-Sabi',
                            text:
                                'Barang sampai dengan selamat di Surabaya. '
                                'Packing bubble wrap tebal lapis tiga. Bentuk '
                                'mangkuknya unik bergaya wabi-sabi natural. Pasti '
                                'bakal order lagi buat koleksi dapur.',
                            helpfulCount: 5,
                            footerOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom bar: Chat | Keranjang | Beli Langsung ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 12,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 46,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () => context.push(
                        '/chat-room?store=${Uri.encodeComponent(product.studio)}',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: CircleBorder(),
                        foregroundColor: AppColors.ink,
                        side: BorderSide(color: AppColors.ink, width: 1.5),
                      ),
                      child: Icon(Icons.chat_bubble_outline_rounded, size: 20),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: () => showModalPilihVariasi(
                          context,
                          product: product,
                          mode: ModalVariasiMode.keranjang,
                        ),
                        icon: Icon(Icons.shopping_cart_outlined, size: 17),
                        label: Text(
                          'Keranjang'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.ink,
                          shape: StadiumBorder(),
                          side: BorderSide(
                            color: AppColors.ink,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: AppColors.darkButtonShadow,
                        ),
                        child: FilledButton(
                          onPressed: () => showModalPilihVariasi(
                            context,
                            product: product,
                            mode: ModalVariasiMode.beliLangsung,
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: AppColors.stadiumButtonShape,
                          ),
                          child: Text(
                            'Beli Langsung'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
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
    required this.onMore,
  });

  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) => SizedBox(
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
        IconButton(
          onPressed: onMore,
          icon: Icon(Icons.more_vert_rounded, size: 21),
          color: AppColors.ink,
        ),
        SizedBox(width: 4),
      ],
    ),
  );
}

// ═══ ★ 4.9 • 128 Ulasan • Terjual 340+ ══════════════════════════════════════
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.rating, required this.store});
  final double rating;
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
    return Row(
      children: [
        Icon(Icons.star_rounded, size: 18, color: AppColors.ink),
        SizedBox(width: 3),
        Flexible(
          child: Text(
            rating.toStringAsFixed(1),
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
              '128 Ulasan'.tr,
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
          child: Text('Terjual 340+'.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style),
        ),
      ],
    );
  }
}

// ═══ Kartu toko ═════════════════════════════════════════════════════════════
class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.studio, required this.onTap});
  final String studio;
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
          child: Icon(
            Icons.storefront_outlined,
            size: 24,
            color: AppColors.ink,
          ),
        ),
        SizedBox(width: 12),
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
              SizedBox(height: 3),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 13,
                    color: AppColors.ink,
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      'Kampung Keramik Dinoyo',
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
        SizedBox(width: 8),
        OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.ink,
            minimumSize: Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: StadiumBorder(),
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
  const _SpecCard();

  Widget _cell(String label, String value) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _smallGrey),
        SizedBox(height: 3),
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
  Widget build(BuildContext context) => Container(
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
        SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cell('Bahan Utama'.tr, 'Tanah Liat Dinoyo (Stoneware)'.tr),
            SizedBox(width: 12),
            _cell('Finishing'.tr, 'Matte Glaze Alami'.tr),
          ],
        ),
        SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cell('Dimensi Produk'.tr, 'T 18cm × D 9cm'),
            SizedBox(width: 12),
            _cell('Berat Bersih'.tr, '600 gram'),
          ],
        ),
      ],
    ),
  );
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
  const _RatingSummary({required this.rating});
  final double rating;

  static const _bars = [
    (5, 0.92, '92%'),
    (4, 0.06, '6%'),
    (3, 0.02, '2%'),
    (2, 0.0, '0%'),
    (1, 0.0, '0%'),
  ];

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
  Widget build(BuildContext context) => Container(
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
                    rating.toStringAsFixed(1),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const _Stars(size: 20),
                  SizedBox(height: 4),
                  Text('128 ulasan', style: _smallGrey),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  for (final b in _bars) _barRow(b.$1, b.$2, b.$3),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
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
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  '98% pembeli merekomendasikan produk ini'.tr,
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

class _Stars extends StatelessWidget {
  const _Stars({this.size = 15});
  final double size;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
      (_) => Icon(Icons.star_rounded, color: _starColor, size: size),
    ),
  );
}

// ═══ Ulasan ═════════════════════════════════════════════════════════════════
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
    this.replyDate,
    this.footerOnly = false,
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
  final String? replyDate;

  /// true → footer sederhana "Membantu N orang" (tanpa teks "Apakah ulasan...").
  final bool footerOnly;
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
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: 18,
                  color: AppColors.ink,
                ),
                onSelected: (value) {
                  if (value == 'copy') {
                    Clipboard.setData(ClipboardData(text: review.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ulasan disalin')),
                    );
                  } else if (value == 'report') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Terima kasih, laporan ulasan dikirim.'),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'copy',
                    height: 40,
                    child: Text('Salin Ulasan'),
                  ),
                  PopupMenuItem(
                    value: 'report',
                    height: 40,
                    child: Text('Laporkan Ulasan'),
                  ),
                ],
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
          if (review.footerOnly) ...[
            Divider(height: 1, thickness: 1, color: AppColors.border),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _helpfulPill(),
                Flexible(
                  child: Text(
                    'Membantu ${review.helpfulCount} orang',
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
          ] else
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                review.photo!,
                width: 142,
                height: 142,
                fit: BoxFit.cover,
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
                      SizedBox(width: 6),
                      Text(
                        '• ${review.replyDate ?? ''}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppColors.textSecondary,
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