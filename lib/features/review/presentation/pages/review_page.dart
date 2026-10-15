import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ReviewItem {
  const ReviewItem({required this.initials, required this.name, required this.date, required this.rating, required this.comment, required this.helpfulCount});
  final String initials, name, date, comment;
  final int rating, helpfulCount;
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key, this.storeName = 'Dinoyo Ceramic Studio', this.overallRating = 4.9, this.totalReviews = 128});
  final String storeName;
  final double overallRating;
  final int totalReviews;
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int? _filterStar;

  static const _ratingBreakdown = [0.92, 0.06, 0.02, 0.0, 0.0]; // bintang 5→1

  static const _reviews = [
    ReviewItem(initials: 'MA', name: 'Mochammad Al Mizan', date: '12 Feb 2025', rating: 5, comment: 'Sangat kokoh dan aman sampai rumah tanpa kerusakan. Kualitas sangat memuaskan!', helpfulCount: 12),
    ReviewItem(initials: 'RH', name: 'Rian Hidayat', date: '8 Feb 2025', rating: 5, comment: 'Kerajinan yang bagus sekali, sesuai dengan foto. Recommended!', helpfulCount: 5),
    ReviewItem(initials: 'FS', name: 'Fitria Sari', date: '2 Feb 2025', rating: 4, comment: 'Produk cantik, pengiriman cepat. Sedikit berbeda dari gambar tapi masih oke.', helpfulCount: 3),
  ];

  List<ReviewItem> get _filtered => _filterStar == null ? _reviews : _reviews.where((r) => r.rating == _filterStar).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg, elevation: 0, scrolledUnderElevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ink), onPressed: () => Navigator.of(context).maybePop()),
        title: Text('Ulasan Toko', style: AppTextStyles.appBarTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppDimensions.pageHorizontal, AppDimensions.paddingL, AppDimensions.pageHorizontal, AppDimensions.bottomNavClearance),
        children: [
          // Store header
          Row(children: [
            Text(widget.storeName, style: AppTextStyles.cardTitle),
            const SizedBox(width: AppDimensions.gapS),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(AppDimensions.radiusS)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.verified_outlined, size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('Terverifikasi', style: AppTextStyles.caption),
              ]),
            ),
          ]),
          const SizedBox(height: AppDimensions.paddingL),

          // Rating overview
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.overallRating.toStringAsFixed(1), style: AppTextStyles.heroHeadline),
              Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, size: 16, color: i < widget.overallRating.round() ? Colors.amber : AppColors.border))),
              const SizedBox(height: 4),
              Text('${widget.totalReviews} ulasan', style: AppTextStyles.caption),
            ]),
            const SizedBox(width: AppDimensions.paddingXXL),
            Expanded(
              child: Column(children: List.generate(5, (i) {
                final starNum = 5 - i;
                final pct = _ratingBreakdown[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(children: [
                    Text('$starNum', style: AppTextStyles.caption),
                    const SizedBox(width: 4),
                    const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(value: pct, backgroundColor: AppColors.inputBg, color: AppColors.black, minHeight: 6),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(width: 32, child: Text('${(pct * 100).toInt()}%', style: AppTextStyles.caption)),
                  ]),
                );
              })),
            ),
          ]),
          const SizedBox(height: AppDimensions.gapS),
          Text('${((_ratingBreakdown[0]) * 100).toInt()}% pembeli merekomendasikan produk studio ini', style: AppTextStyles.bodySmall),
          const Divider(height: 28, color: AppColors.border),

          // Filter chips
          SizedBox(
            height: 36,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              _FilterChip(label: 'Semua (${_reviews.length})', active: _filterStar == null, onTap: () => setState(() => _filterStar = null)),
              const SizedBox(width: AppDimensions.gapS),
              ...List.generate(5, (i) {
                final star = 5 - i;
                final count = _reviews.where((r) => r.rating == star).length;
                return Padding(
                  padding: const EdgeInsets.only(right: AppDimensions.gapS),
                  child: _FilterChip(label: 'Bintang $star ($count)', active: _filterStar == star, onTap: () => setState(() => _filterStar = star)),
                );
              }),
            ]),
          ),
          const SizedBox(height: AppDimensions.paddingL),

          // Review items
          ..._filtered.map((r) => _ReviewTile(review: r)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.black : AppColors.inputBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: active ? AppColors.white : AppColors.ink, fontWeight: FontWeight.w600)),
    ),
  );
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});
  final ReviewItem review;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimensions.paddingXL),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        CircleAvatar(radius: 18, backgroundColor: AppColors.inputBg, child: Text(review.initials, style: AppTextStyles.fieldLabel)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(review.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          Text(review.date, style: AppTextStyles.caption),
        ])),
        Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, size: 14, color: i < review.rating ? Colors.amber : AppColors.border))),
      ]),
      const SizedBox(height: AppDimensions.gapS),
      Text(review.comment, style: AppTextStyles.bodySmall),
      const SizedBox(height: AppDimensions.gapS),
      Text('Membantu ${review.helpfulCount} orang', style: AppTextStyles.caption),
    ]),
  );
}
