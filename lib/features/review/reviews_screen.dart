import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, this.storeName = 'Dinoyo Ceramic Studio'});

  final String storeName;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewItem {
  const _ReviewItem({
    required this.name,
    required this.date,
    required this.rating,
    required this.variant,
    required this.text,
    required this.helpful,
    this.photos = const [],
    this.reply,
    this.replyDate,
  });

  final String name;
  final String date;
  final int rating;
  final String variant;
  final String text;
  final int helpful;
  final List<String> photos;
  final String? reply;
  final String? replyDate;

  String get initials {
    final parts = name.split(' ');
    return parts
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
  }
}

const List<_ReviewItem> _reviews = [
  _ReviewItem(
    name: 'Mochammad Al Mizan',
    date: '12 Feb 2025',
    rating: 5,
    variant: 'Varian: Sand White Glossy - Vas Keramik Minimalis',
    text:
        'Glasirnya sangat halus dan rapi, warna aslinya lebih estetik daripada '
        'di foto. Pengemasan kayu sangat kokoh dan aman sampai rumah tanpa '
        'retak sedikitpun. Sangat bangga dengan karya pengrajin Dinoyo Malang!',
    helpful: 14,
    photos: [AppAssets.productVas, AppAssets.productCangkir],
    reply:
        '"Terima kasih banyak Mas Mizan atas apresiasinya! Semoga vas '
        'keramiknya mempercantik ruangan rumah."',
    replyDate: '13 Feb 2025',
  ),
  _ReviewItem(
    name: 'Anisa Nur Azizah',
    date: '10 Feb 2025',
    rating: 5,
    variant: 'Varian: Rustic Speckle - Cangkir Kopi Handmade',
    text:
        'Tekstur tanah liatnya terasa otentik dan berbobot pas di tangan saat '
        'minum kopi seduh manual. Finishing matte-nya nyaman banget dipegang. '
        'Recomended untuk penikmat tembikar seni.',
    helpful: 9,
  ),
  _ReviewItem(
    name: 'Rian Hidayat',
    date: '8 Feb 2025',
    rating: 4,
    variant: 'Varian: Natural Clay - Piring Artisan',
    text:
        'Piringnya kokoh dan glasirnya merata. Hanya saja warnanya sedikit '
        'lebih gelap dari foto, tapi tetap cantik dipakai sehari-hari.',
    helpful: 5,
  ),
  _ReviewItem(
    name: 'Dewi Lestari',
    date: '3 Feb 2025',
    rating: 4,
    variant: 'Varian: Speckle Grey - Mangkuk Keramik',
    text:
        'Pengiriman cepat dan packing rapi. Mangkuknya bagus, ukurannya pas '
        'untuk sarapan. Akan order lagi untuk stok ulang.',
    helpful: 3,
  ),
  _ReviewItem(
    name: 'Budi Santoso',
    date: '28 Jan 2025',
    rating: 3,
    variant: 'Varian: Sand White Glossy - Vas Keramik Minimalis',
    text:
        'Produk sesuai deskripsi, namun pengiriman agak lama karena jasa kirim. '
        'Kualitas keramiknya sendiri tidak perlu diragukan.',
    helpful: 1,
  ),
];

class _ReviewsScreenState extends State<ReviewsScreen> {
  /// Penampil foto ulasan full-screen dengan zoom.
  void _openPhotoViewer(BuildContext context, String photo) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogCtx) => Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                maxScale: 4,
                child: Image.asset(photo, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(dialogCtx).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int? _filterRating;
  final Set<String> _markedHelpful = {};

  int _countFor(int rating) =>
      _reviews.where((r) => r.rating == rating).length;

  List<_ReviewItem> get _filtered => _filterRating == null
      ? _reviews
      : _reviews.where((r) => r.rating == _filterRating).toList();

  @override
  Widget build(BuildContext context) {
    final histogram = {
      5: 0.92,
      4: 0.06,
      3: 0.02,
      2: 0.0,
      1: 0.0,
    };

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 54,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 19,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Ulasan Toko',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                children: [
                  _buildTitleBlock(),
                  const SizedBox(height: 14),
                  _buildSummaryCard(histogram),
                  const SizedBox(height: 16),
                  _buildFilterChips(),
                  const SizedBox(height: 6),
                  ..._filtered.map(_buildReviewCard),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBlock() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ulasan Pelanggan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.storeName,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.borderAlt),
          ),
          child: Text(
            'Terverifikasi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4C4546),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(Map<int, double> histogram) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4.9',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _starRow(5, size: 18),
                    const SizedBox(height: 4),
                    Text(
                      '128 ulasan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  children: histogram.entries
                      .map((e) => _buildHistogramRow(e.key, e.value))
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.thumb_up_alt_rounded,
                  size: 15,
                  color: AppColors.ink,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '98% pembeli merekomendasikan produk studio ini',
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

  Widget _buildHistogramRow(int star, double fraction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 10,
            child: Text(
              '$star',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: SizedBox(
                height: 8,
                child: Stack(
                  children: [
                    Container(color: AppColors.inputBg),
                    FractionallySizedBox(
                      widthFactor: fraction,
                      child: Container(color: AppColors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 32,
            child: Text(
              '${(fraction * 100).round()}%',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final chips = <(int?, int)>[
      (null, _reviews.length),
      for (final rating in [5, 4, 3]) (rating, _countFor(rating)),
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (rating, count) = chips[i];
          final active = _filterRating == rating;
          return OutlinedButton(
            onPressed: () => setState(() => _filterRating = rating),
            style: OutlinedButton.styleFrom(
              backgroundColor: active ? AppColors.black : AppColors.white,
              side: BorderSide(
                color: active ? AppColors.black : AppColors.borderAlt,
              ),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              minimumSize: const Size(0, 38),
            ),
            child: Text(
              rating == null
                  ? 'Semua ($count)'
                  : 'Bintang $rating ($count)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? AppColors.white : AppColors.ink,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewCard(_ReviewItem review) {
    final marked = _markedHelpful.contains(review.name);

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.inputBg,
                child: Text(
                  review.initials,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      review.date,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                onSelected: (value) {
                  if (value == 'copy') {
                    Clipboard.setData(ClipboardData(text: review.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ulasan disalin')),
                    );
                  } else if (value == 'report') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Terima kasih, laporan ulasan dikirim.'),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => const [
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
          const SizedBox(height: 10),
          _starRow(review.rating, size: 15),
          const SizedBox(height: 6),
          Text(
            review.variant,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review.text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.55,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          // Helpful row
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() {
                  marked
                      ? _markedHelpful.remove(review.name)
                      : _markedHelpful.add(review.name);
                }),
                icon: Icon(
                  marked
                      ? Icons.thumb_up_alt_rounded
                      : Icons.thumb_up_alt_outlined,
                  size: 13,
                  color: marked ? AppColors.white : const Color(0xFF4C4546),
                ),
                label: Text(
                  'Membantu (${review.helpful + (marked ? 1 : 0)})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: marked ? AppColors.white : const Color(0xFF4C4546),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: marked ? AppColors.black : AppColors.white,
                  side: const BorderSide(color: AppColors.borderAlt),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: const Size(0, 32),
                ),
              ),
              const Spacer(),
              Text(
                'Apakah ulasan ini bermanfaat?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          // Photos
          if (review.photos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                for (final photo in review.photos) ...[
                  GestureDetector(
                    onTap: () => _openPhotoViewer(context, photo),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        photo,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ],
          // Store reply
          if (review.reply != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderAlt),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.storefront_rounded,
                        size: 14,
                        color: AppColors.ink,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.storeName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        '  •  ${review.replyDate}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.reply!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.5,
                      color: const Color(0xFF4C4546),
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

  Widget _starRow(int rating, {double size = 15}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: AppColors.ink,
        );
      }),
    );
  }
}
