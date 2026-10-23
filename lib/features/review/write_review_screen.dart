import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/services/photo_picker_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/image_preview_dialog.dart';

class WriteReviewScreen extends StatefulWidget {
const   WriteReviewScreen({
    super.key,
    this.orderId = '#DNC-001',
    this.productName = 'Vas Keramik Minimalis',
    this.variant = 'Varian: Sand White Glossy 1x',
    this.studioName = 'Dinoyo Ceramic Studio',
    this.productImage = AppAssets.productVas,
    this.receivedDate = 'Diterima 12 Feb 2025',
  });

  final String orderId;
  final String productName;
  final String variant;
  final String studioName;
  final String productImage;
  final String receivedDate;

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  static const Color _amber = Color(0xFFF59E0B);

  static const List<String> _ratingLabels = [
    'Mengecewakan',
    'Kurang Baik',
    'Cukup Baik',
    'Baik',
    'Sangat Memuaskan',
  ];

  static const List<String> _likeOptions = [
    'Finishing Halus',
    'Packing Kayu Aman',
    'Warna Sesuai Foto',
    'Kualitas Tebal & Kokoh',
    'Detail Rapi',
  ];

  static const List<(String, String)> _attributes = [
    ('Kualitas Bahan & Glaze', 'Ketahanan lapisan dan kilau glasir'),
    ('Ketepatan dengan Deskripsi', 'Dimensi, warna, dan tekstur kerajinan'),
    ('Keamanan Kemasan & Ekspedisi', 'Bubble wrap tebal & proteksi benturan'),
  ];

  int _rating = 0;
  final Set<int> _likes = {};
  final List<int> _attributeRatings = [0, 0, 0];
  final TextEditingController _reviewController = TextEditingController(
    text:
        'Glasirnya sangat rapi dan tekstur tanah liat Dinoyonya terasa kokoh '
        'serta otentik. Pengemasan kayu sangat aman sampai di rumah tanpa '
        'retak sedikitpun. Recommended!',
  );

  /// Path foto ulasan hasil kamera/galeri perangkat (maksimal 5 foto).
  final List<String> _photos = [];
  static const int _maxPhotos = 5;

  /// Tambah foto: sheet pilih sumber (kamera/galeri) → ambil foto perangkat.
  Future<void> _addPhoto() async {
    final file = await PhotoPickerService.pickWithSheet(
      context,
      title: 'Tambahkan Foto Produk'.tr,
    );
    if (file == null || !mounted) return;
    setState(() => _photos.add(file.path));
  }

  bool get _canSubmit => _rating > 0 && _reviewController.text.trim().isNotEmpty;

  void _submit() {
    if (!_canSubmit) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.black,
        content: Text(
          'Ulasan berhasil dikirim. Terima kasih!',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.white,
          ),
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackScope(
      fallbackRoute: '/reviews',
      child: Scaffold(
        backgroundColor: AppColors.bg,
        // Bar kirim di slot bottomNavigationBar (bukan di dalam body): saat
        // keyboard terbuka body menyusut, tetapi bar TETAP di dasar layar dan
        // tertutup keyboard — konsisten dengan bottom nav di halaman pencarian.
        bottomNavigationBar: _buildSubmitBar(),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(
                height: 54,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/reviews');
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 19,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Beri Ulasan Produk'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                  children: [
                    _buildProductCard(),
                    SizedBox(height: 14),
                    _buildRatingCard(),
                    SizedBox(height: 14),
                    _buildAttributesCard(),
                    SizedBox(height: 14),
                    _buildWrittenReviewCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Product info card ──────────────────────────────────────────────────
  Widget _buildProductCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.productImage,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.orderId,
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
                    Flexible(
                      child: Text(
                        widget.receivedDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  widget.productName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  widget.variant,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.studioName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Overall rating card ────────────────────────────────────────────────
  Widget _buildRatingCard() {
    final hasRating = _rating > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Column(
        children: [
          Text(
            'Bagaimana kualitas keramik ini?',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Sentuh bintang untuk memberikan penilaian keseluruhan',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < _rating;
              return GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 40,
                    color: filled ? _amber : AppColors.border,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 12),
          if (hasRating) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.borderAlt),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${_ratingLabels[_rating - 1]} $_rating/5 ★',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Pilih hal yang paling kamu sukai:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (i, option) in _likeOptions.indexed)
                _buildLikeChip(i, option),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLikeChip(int index, String label) {
    final selected = _likes.contains(index);
    return OutlinedButton(
      onPressed: () => setState(() {
        selected ? _likes.remove(index) : _likes.add(index);
      }),
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? AppColors.black : AppColors.surface,
        side: BorderSide(
          color: selected ? AppColors.black : AppColors.borderAlt,
        ),
        shape: StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: Size(0, 34),
      ),
      child: Text(
        '${selected ? '✓' : '+'} $label',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? AppColors.white : AppColors.ink,
        ),
      ),
    );
  }

  // ── Attribute ratings card ─────────────────────────────────────────────
  Widget _buildAttributesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Column(
        children: [
          for (final (i, (title, desc)) in _attributes.indexed) ...[
            if (i > 0)
              Divider(
                height: 1,
                color: AppColors.divider,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          desc,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (star) {
                      final filled = star < _attributeRatings[i];
                      return GestureDetector(
                        onTap: () => setState(
                          () => _attributeRatings[i] =
                              _attributeRatings[i] == star + 1 ? star : star + 1,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Icon(
                            filled
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 19,
                            color: filled ? _amber : AppColors.border,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Written review card ────────────────────────────────────────────────
  Widget _buildWrittenReviewCard() {
    final length = _reviewController.text.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _reviewController,
            maxLength: 500,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.55,
              color: AppColors.ink,
            ),
            decoration: InputDecoration(
              hintText:
                  'Ceritakan pengalamanmu dengan produk keramik ini...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: AppColors.inputBg,
              counterText: '',
              contentPadding: const EdgeInsets.all(13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderAlt),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderAlt),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.ink),
              ),
            ),
          ),
          SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$length/500',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Tambahkan Foto Produk',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              if (_photos.length < _maxPhotos)
                GestureDetector(
                  onTap: _addPhoto,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderAlt,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tambah',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              for (final photo in _photos) ...[
                SizedBox(width: 8),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ImagePreviewDialog.show(
                          context,
                          title: 'Foto Ulasan'.tr,
                          filePath: photo,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(photo),
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 72,
                            height: 72,
                            color: AppColors.inputBg,
                            child: Icon(
                              Icons.broken_image_rounded,
                              size: 20,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => setState(() => _photos.remove(photo)),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ── Sticky submit bar ──────────────────────────────────────────────────
  Widget _buildSubmitBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: _canSubmit ? _submit : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.black,
            disabledBackgroundColor: AppColors.border,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Kirim Ulasan'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
