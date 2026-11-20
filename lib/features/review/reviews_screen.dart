import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/dc_cached_image.dart';
import '../../core/widgets/image_preview_dialog.dart';
import 'presentation/modal_laporkan_ulasan.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({
    super.key,
    this.storeName = 'Dinoyo Ceramic Studio',
    this.productId,
    this.mitraId,
  });

  final String storeName;
  final String? productId;
  final int? mitraId;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewItem {
  const _ReviewItem({
    required this.id,
    required this.name,
    required this.date,
    required this.rating,
    required this.variant,
    required this.text,
    required this.helpful,
    this.avatarUrl,
    this.photos = const [],
    this.reply,
    this.replyDate,
    this.storeName,
  });

  final String id;
  final String name;
  final String date;
  final int rating;
  final String variant;
  final String text;
  final int helpful;
  final String? avatarUrl;
  final List<String> photos;
  final String? reply;
  final String? replyDate;
  final String? storeName;

  String get initials {
    final cleaned = name.trim();
    if (cleaned.isEmpty) return 'U';
    final parts = cleaned.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  bool _loading = true;
  List<_ReviewItem> _reviews = [];
  double _avgRating = 0.0;
  int _totalReviews = 0;

  int? _filterRating;
  final Set<String> _markedHelpful = {};

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  String _formatDate(dynamic raw) {
    if (raw == null) return 'Baru saja';
    final parsed = DateTime.tryParse(raw.toString())?.toLocal();
    if (parsed == null) return raw.toString();
    return '${parsed.day} ${_months[parsed.month - 1]} ${parsed.year}';
  }

  Future<void> _fetchReviews() async {
    setState(() => _loading = true);
    try {
      final hasProduct =
          widget.productId != null && widget.productId!.trim().isNotEmpty;
      final endpoint = hasProduct
          ? '/reviews/product/${widget.productId!.trim()}'
          : '/reviews/store?store=${Uri.encodeComponent(widget.storeName)}'
              '${widget.mitraId != null ? '&mitra_id=${widget.mitraId}' : ''}';

      final res = await ApiClient.get(endpoint);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      final rawList = data['reviews'] as List<dynamic>? ?? [];

      final items = rawList.whereType<Map>().map((raw) {
        final r = Map<String, dynamic>.from(raw);
        final rawPhotos = r['photo_urls'];
        final photos = <String>[];
        if (rawPhotos is List) {
          for (final p in rawPhotos) {
            final resolved = ApiClient.resolveImageUrl(p?.toString());
            if (resolved.isNotEmpty) photos.add(resolved);
          }
        }
        final variantRaw = (r['variant'] ?? '').toString().trim();
        final prodName = (r['product_name'] ?? '').toString().trim();
        String variantLabel = '';
        if (variantRaw.isNotEmpty && prodName.isNotEmpty) {
          variantLabel = variantRaw.toLowerCase().startsWith('varian')
              ? '$variantRaw - $prodName'
              : 'Varian: $variantRaw - $prodName';
        } else if (variantRaw.isNotEmpty) {
          variantLabel = variantRaw.toLowerCase().startsWith('varian')
              ? variantRaw
              : 'Varian: $variantRaw';
        } else if (prodName.isNotEmpty) {
          variantLabel = prodName;
        } else {
          variantLabel = 'Varian Standar';
        }

        final sellerReply = (r['seller_reply'] ?? '').toString().trim();
        final rawAvatar = (r['user_avatar'] ?? '').toString().trim();

        return _ReviewItem(
          id: (r['id'] ?? '').toString(),
          name: (r['user_name'] ?? 'Pelanggan').toString(),
          avatarUrl:
              rawAvatar.isNotEmpty ? ApiClient.resolveImageUrl(rawAvatar) : null,
          date: _formatDate(r['created_at']),
          rating: (num.tryParse('${r['rating'] ?? 5}') ?? 5).round().clamp(1, 5),
          variant: variantLabel,
          text: (r['comment'] ?? '').toString().trim().isNotEmpty
              ? (r['comment']).toString().trim()
              : 'Pembeli memberikan penilaian bintang tanpa komentar tertulis.',
          helpful: (num.tryParse('${r['helpful_count'] ?? 0}') ?? 0).toInt(),
          photos: photos,
          reply: sellerReply.isNotEmpty ? sellerReply : null,
          replyDate: sellerReply.isNotEmpty ? _formatDate(r['replied_at']) : null,
          storeName: (r['store_name'] ?? widget.storeName).toString(),
        );
      }).toList();

      if (!mounted) return;
      final total = items.length;
      final avg = total > 0
          ? items.fold<int>(0, (acc, e) => acc + e.rating) / total
          : (num.tryParse('${data['avgRating'] ?? 0}') ?? 0).toDouble();

      setState(() {
        _reviews = items;
        _totalReviews = total;
        _avgRating = double.parse(avg.toStringAsFixed(1));
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _toggleHelpful(_ReviewItem review) async {
    final already = _markedHelpful.contains(review.id);
    setState(() {
      if (already) {
        _markedHelpful.remove(review.id);
      } else {
        _markedHelpful.add(review.id);
      }
    });
    if (!already && int.tryParse(review.id) != null) {
      try {
        await ApiClient.patch('/reviews/${review.id}/helpful', {});
      } catch (_) {}
    }
  }

  /// Penampil foto ulasan full-screen dengan zoom.
  void _openPhotoViewer(BuildContext context, String photo, [_ReviewItem? item]) {
    ImagePreviewDialog.show(
      context,
      title: 'Foto Ulasan'.tr,
      subtitle: item != null ? '${item.name} • ${item.variant}' : null,
      assetPath: photo,
    );
  }

  int _countFor(int rating) =>
      _reviews.where((r) => r.rating == rating).length;

  List<_ReviewItem> get _filtered => _filterRating == null
      ? _reviews
      : _reviews.where((r) => r.rating == _filterRating).toList();

  @override
  Widget build(BuildContext context) {
    final total = _reviews.length;
    final histogram = <int, double>{
      for (final star in [5, 4, 3, 2, 1])
        star: total > 0 ? _countFor(star) / total : 0.0,
    };
    final hasProduct =
        widget.productId != null && widget.productId!.trim().isNotEmpty;

    return AppBackScope(
      fallbackRoute: '/home',
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
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
                          context.go('/home');
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 19,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        hasProduct ? 'Ulasan Produk'.tr : 'Ulasan Toko'.tr,
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
                child: _loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.ink,
                          strokeWidth: 2.5,
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.ink,
                        onRefresh: _fetchReviews,
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                          children: [
                            _buildTitleBlock(),
                            SizedBox(height: 14),
                            _buildSummaryCard(histogram),
                            SizedBox(height: 16),
                            _buildFilterChips(),
                            SizedBox(height: 6),
                            if (_filtered.isEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 18),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 36,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.borderAlt),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.rate_review_outlined,
                                      size: 36,
                                      color: AppColors.textMuted,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _filterRating != null
                                          ? 'Belum ada ulasan dengan bintang $_filterRating'
                                              .tr
                                          : 'Belum ada ulasan untuk ditampilkan'
                                              .tr,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ..._filtered.map(_buildReviewCard),
                          ],
                        ),
                      ),
              ),
            ],
          ),
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
                'Ulasan Pelanggan'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(height: 2),
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
            'Terverifikasi'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(Map<int, double> histogram) {
    final recommendedCount = _reviews.where((r) => r.rating >= 4).length;
    final recommendPercent = _totalReviews > 0
        ? ((recommendedCount / _totalReviews) * 100).round()
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
                      _totalReviews > 0 ? _avgRating.toStringAsFixed(1) : '0.0',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 4),
                    _starRow(_avgRating.round(), size: 18),
                    SizedBox(height: 4),
                    Text(
                      '$_totalReviews ${'ulasan'.tr}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
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
          SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.thumb_up_alt_rounded,
                  size: 15,
                  color: AppColors.ink,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _totalReviews > 0
                        ? '$recommendPercent% ${'pembeli merekomendasikan produk studio ini'.tr}'
                        : 'Jadilah pembeli pertama yang memberikan ulasan'.tr,
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
          SizedBox(width: 8),
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
          SizedBox(width: 8),
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
        separatorBuilder: (_, _) => SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (rating, count) = chips[i];
          final active = _filterRating == rating;
          return OutlinedButton(
            onPressed: () => setState(() => _filterRating = rating),
            style: OutlinedButton.styleFrom(
              backgroundColor: active ? AppColors.black : AppColors.surface,
              side: BorderSide(
                color: active ? AppColors.black : AppColors.borderAlt,
              ),
              shape: StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              minimumSize: Size(0, 38),
            ),
            child: Text(
              rating == null
                  ? '${'Semua'.tr} ($count)'
                  : '${'Bintang'.tr} $rating ($count)',
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
    final isDark = AppColors.isDark;
    final marked = _markedHelpful.contains(review.id);

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer row
          Row(
            children: [
              if (review.avatarUrl != null && review.avatarUrl!.isNotEmpty)
                ClipOval(
                  child: DcCachedImage(
                    imageUrl: review.avatarUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
              else
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
              SizedBox(width: 10),
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
                        reviewId: review.id,
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
                    const _ReviewMenuDivider(),
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
          _starRow(review.rating, size: 15),
          SizedBox(height: 6),
          Text(
            review.variant,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            review.text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.55,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: 12),
          // Helpful row
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _toggleHelpful(review),
                icon: Icon(
                  marked
                      ? Icons.thumb_up_alt_rounded
                      : Icons.thumb_up_alt_outlined,
                  size: 13,
                  color: marked ? AppColors.white : AppColors.textSecondary,
                ),
                label: Text(
                  '${'Membantu'.tr} (${review.helpful + (marked ? 1 : 0)})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: marked ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: marked ? AppColors.black : AppColors.surface,
                  side: BorderSide(color: AppColors.borderAlt),
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size(0, 32),
                ),
              ),
              Spacer(),
              Flexible(
                child: Text(
                  'Apakah ulasan ini bermanfaat?'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          // Photos
          if (review.photos.isNotEmpty) ...[
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final photo in review.photos) ...[
                    GestureDetector(
                      key: Key('reviews_screen_photo_tap_${review.id}_$photo'),
                      onTap: () => _openPhotoViewer(context, photo, review),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: DcCachedImage(
                              imageUrl: photo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 6,
                            bottom: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: .6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.fullscreen_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ],
          // Store reply
          if (review.reply != null) ...[
            SizedBox(height: 12),
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
                      Icon(
                        Icons.storefront_rounded,
                        size: 14,
                        color: AppColors.ink,
                      ),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          review.storeName ?? widget.storeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '  •  ${review.replyDate}',
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
                  SizedBox(height: 6),
                  Text(
                    review.reply!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.5,
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

class _ReviewMenuDivider extends PopupMenuEntry<Never> {
  const _ReviewMenuDivider();

  @override
  final double height = 1;

  @override
  bool represents(Never? value) => false;

  @override
  State<_ReviewMenuDivider> createState() => _ReviewMenuDividerState();
}

class _ReviewMenuDividerState extends State<_ReviewMenuDivider> {
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
