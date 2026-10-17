import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

// â”€â”€â”€ Placeholder Model (ganti dengan entity dari domain layer) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class ProductDetailArgs {
const   ProductDetailArgs({
    required this.id,
    required this.name,
    required this.studio,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imagePath,
    this.description = '',
    this.material = '',
    this.finishing = '',
    this.weight = '',
    this.dimensions = '',
  });

  final String id;
  final String name;
  final String studio;
  final int price;
  final double rating;
  final int reviewCount;
  final String imagePath;
  final String description;
  final String material;
  final String finishing;
  final String weight;
  final String dimensions;
}

// â”€â”€â”€ Product Detail Page â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
/// Halaman detail produk.
/// Menerima [args] agar bisa dipakai untuk semua tipe produk (cangkir, vas, dll).
/// Panggil via: Navigator.push / context.push('/product/:id')
class ProductDetailPage extends StatelessWidget {
  // TODO: Saat pakai go_router, terima id sebagai param dan fetch dari repository
const   ProductDetailPage({super.key, required this.args});

  final ProductDetailArgs args;

  String _formatPrice(int price) {
    final formatted = price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // â”€â”€ Hero Image dengan back button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.bg,
            leading: _CircleBackBtn(),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            flexibleSpace: FlexibleSpaceBar(
              background: _ProductHeroImage(imagePath: args.imagePath),
            ),
          ),

          // â”€â”€ Detail Content â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.pageHorizontal,
                AppDimensions.paddingXL,
                AppDimensions.pageHorizontal,
                AppDimensions.bottomNavClearance,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating Row
                  _RatingRow(
                    rating: args.rating,
                    reviewCount: args.reviewCount,
                  ),
                  SizedBox(height: AppDimensions.gapS),

                  // Product Name
                  Text(args.name, style: AppTextStyles.sectionTitle),
                  SizedBox(height: AppDimensions.gapM),

                  // Studio Row
                  _StudioRow(
                    studioName: args.studio,
                    onVisitTap: () {
                      // TODO: context.push('/store/:id')
                    },
                  ),
                  Divider(height: 32, color: AppColors.border),

                  // Deskripsi
                  _SectionBlock(
                    title: 'Deskripsi Produk',
                    child: Text(args.description, style: AppTextStyles.bodySmall),
                  ),
                  SizedBox(height: AppDimensions.paddingXL),

                  // Spesifikasi
                  _SectionBlock(
                    title: 'Spesifikasi Detail',
                    child: Column(
                      children: [
                        _SpecRow(label: 'Bahan Utama', value: args.material),
                        _SpecRow(label: 'Finishing', value: args.finishing),
                        _SpecRow(label: 'Berat Bersih', value: args.weight),
                        _SpecRow(label: 'Dimensi Produk', value: args.dimensions),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingXL),

                  // Jaminan
                  _GuaranteeChip(),
                  Divider(height: 32, color: AppColors.border),

                  // Ulasan preview
                  _ReviewPreviewSection(
                    reviewCount: args.reviewCount,
                    rating: args.rating,
                    onSeeAll: () {
                      // TODO: context.push('/review/${args.id}')
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // â”€â”€ Bottom Action Bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      bottomNavigationBar: _BottomActionBar(
        price: _formatPrice(args.price),
        onAddToCart: () {
          // TODO: show DcVariantSheet bottom sheet
        },
        onBuyNow: () {
          // TODO: context.push('/checkout')
        },
      ),
    );
  }
}

// â”€â”€â”€ Sub-widgets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _CircleBackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: AppColors.white,
        shape: CircleBorder(),
        elevation: 2,
        shadowColor: Colors.black12,
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: () => Navigator.of(context).maybePop(),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.arrow_back, size: 20, color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}

class _ProductHeroImage extends StatelessWidget {
  const _ProductHeroImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.inputBg,
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star_rounded, size: 16, color: Colors.amber),
        SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.ratingBadge,
        ),
        SizedBox(width: 6),
        Text(
          '($reviewCount Ulasan)',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

class _StudioRow extends StatelessWidget {
  const _StudioRow({required this.studioName, required this.onVisitTap});

  final String studioName;
  final VoidCallback onVisitTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.inputBg,
          child: Icon(Icons.store_outlined, size: 18, color: AppColors.textMuted),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(studioName, style: AppTextStyles.subTitle),
            ],
          ),
        ),
        TextButton(
          onPressed: onVisitTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            side: BorderSide(color: AppColors.border),
            shape: StadiumBorder(),
          ),
          child: Text('Kunjungi Toko', style: AppTextStyles.seeAll),
        ),
      ],
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.cardTitle),
        SizedBox(height: AppDimensions.gapS),
        child,
      ],
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: AppTextStyles.caption),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuaranteeChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined, size: 16, color: AppColors.ink),
          SizedBox(width: 8),
          Text(
            'Garansi Kemasan Aman Dinoyo',
            style: AppTextStyles.fieldLabel,
          ),
        ],
      ),
    );
  }
}

class _ReviewPreviewSection extends StatelessWidget {
  const _ReviewPreviewSection({
    required this.reviewCount,
    required this.rating,
    required this.onSeeAll,
  });

  final int reviewCount;
  final double rating;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$reviewCount Ulasan', style: AppTextStyles.cardTitle),
            Spacer(),
            TextButton(
              onPressed: onSeeAll,
              child: Text('Lihat Semua', style: AppTextStyles.seeAll),
            ),
          ],
        ),
        // Placeholder review item
        _ReviewItem(
          initials: 'CU',
          name: 'Customer',
          date: '12 Feb 2025',
          rating: 5,
          comment: 'Sangat kokoh dan aman sampai rumah tanpa kerusakan. Kualitas sangat memuaskan!',
          helpfulCount: 12,
        ),
        _ReviewItem(
          initials: 'RH',
          name: 'Rian Hidayat',
          date: '8 Feb 2025',
          rating: 5,
          comment: 'Kerajinan yang bagus sekali, sesuai dengan foto.',
          helpfulCount: 5,
        ),
      ],
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({
    required this.initials,
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
    required this.helpfulCount,
  });

  final String initials;
  final String name;
  final String date;
  final int rating;
  final String comment;
  final int helpfulCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.inputBg,
                child: Text(initials, style: AppTextStyles.fieldLabel),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    Text(date, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: i < rating ? Colors.amber : AppColors.border,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.gapS),
          Text(comment, style: AppTextStyles.bodySmall),
          SizedBox(height: AppDimensions.gapS),
          Text(
            'Membantu $helpfulCount orang',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.price,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  final String price;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontal,
        AppDimensions.paddingL,
        AppDimensions.pageHorizontal,
        AppDimensions.paddingL + bottomPad,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Harga', style: AppTextStyles.caption),
              Text(price, style: AppTextStyles.price),
            ],
          ),
          SizedBox(width: AppDimensions.paddingL),
          Expanded(
            child: SizedBox(
              height: AppDimensions.buttonHeight,
              child: OutlinedButton(
                onPressed: onAddToCart,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.border),
                  shape: StadiumBorder(),
                ),
                child: Text('Keranjang', style: AppTextStyles.seeAll),
              ),
            ),
          ),
          SizedBox(width: AppDimensions.paddingS),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: onBuyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: StadiumBorder(),
                ),
                child: Text('Beli Langsung', style: AppTextStyles.buttonLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
