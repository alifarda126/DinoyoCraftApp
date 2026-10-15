import 'package:flutter/material.dart';

import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class StoreDetailPage extends StatefulWidget {
  const StoreDetailPage({super.key, this.storeId = '1'});
  final String storeId;
  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  String _query = '';

  // TODO: Ambil dari store repository berdasarkan storeId
  static const _storeName = 'Dinoyo Ceramic Studio';
  static const _storeDesc =
      'Studio keramik keluarga yang melestarikan seni tembikar Dinoyo sejak 1985. '
      'Menyediakan perlengkapan makan stoneware, vas hias, hingga suvenir keramik '
      'buatan tangan langsung dari tungku pembakaran lokal.';
  static const _rating = 4.9;
  static const _reviewCount = 128;

  static const _products = [
    (name: 'Vas Minimalis', price: 85000, image: AppAssets.productVas, hot: false),
    (name: 'Cangkir Handmade', price: 65000, image: AppAssets.productCangkir, hot: true),
    (name: 'Piring Artisan', price: 95000, image: AppAssets.productPiring, hot: false),
    (name: 'Mangkuk Ramen', price: 85000, image: AppAssets.productMangkukRamen, hot: false),
  ];

  String _fmt(int price) => 'Rp${price.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}';

  List<({String name, int price, String image, bool hot})> get _filtered =>
      _query.isEmpty ? _products : _products.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.bg,
            leading: _CircleBackBtn(),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(AppAssets.storeDinoyo, fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.inputBg)),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.pageHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating
                  Row(children: [
                    const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(_rating.toStringAsFixed(1), style: AppTextStyles.ratingBadge),
                    const SizedBox(width: 6),
                    Text('($_reviewCount Ulasan)', style: AppTextStyles.caption),
                  ]),
                  const SizedBox(height: AppDimensions.gapS),
                  Text(_storeName, style: AppTextStyles.sectionTitle),
                  const SizedBox(height: AppDimensions.gapM),
                  Text(_storeDesc, style: AppTextStyles.bodySmall),
                  const SizedBox(height: AppDimensions.paddingL),

                  // Action buttons
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () { /* TODO: navigate to store profile */ },
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), shape: const StadiumBorder()),
                        icon: const Icon(Icons.storefront_outlined, size: 16, color: AppColors.ink),
                        label: Text('Profil Toko', style: AppTextStyles.seeAll),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.gapS),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () { /* TODO: context.push('/chat/store') */ },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.black, foregroundColor: AppColors.white, elevation: 0, shape: const StadiumBorder()),
                        icon: const Icon(Icons.chat_bubble_outline, size: 16),
                        label: Text('Chat Toko', style: AppTextStyles.buttonLabel),
                      ),
                    ),
                  ]),
                  const SizedBox(height: AppDimensions.paddingL),

                  // Search in store
                  TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Cari produk di toko ini...',
                      hintStyle: AppTextStyles.fieldHint,
                      prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                      filled: true, fillColor: AppColors.inputBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusL), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),

                  Row(children: [
                    Text('Katalog', style: AppTextStyles.cardTitle),
                    const Spacer(),
                    Text('Menampilkan ${_filtered.length} Produk', style: AppTextStyles.caption),
                  ]),
                  const SizedBox(height: AppDimensions.paddingM),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppDimensions.pageHorizontal, 0, AppDimensions.pageHorizontal, AppDimensions.bottomNavClearance),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 14, childAspectRatio: 0.62),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final p = _filtered[i];
                  return _StoreProductCard(name: p.name, price: _fmt(p.price), imagePath: p.image, isHot: p.hot,
                    onTap: () { /* TODO: context.push('/product/...') */ });
                },
                childCount: _filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Material(
      color: AppColors.white, shape: const CircleBorder(), elevation: 2, shadowColor: Colors.black12,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.of(context).maybePop(),
        child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back, size: 20, color: AppColors.ink)),
      ),
    ),
  );
}

class _StoreProductCard extends StatelessWidget {
  const _StoreProductCard({required this.name, required this.price, required this.imagePath, required this.isHot, required this.onTap});
  final String name, price, imagePath;
  final bool isHot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Stack(children: [
            ClipRRect(borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              child: ColoredBox(color: AppColors.inputBg,
                child: Image.asset(imagePath, width: double.infinity, height: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Center(child: Icon(Icons.image_not_supported_outlined, color: AppColors.textMuted))))),
            if (isHot)
              Positioned(top: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.local_fire_department, size: 10, color: Colors.orangeAccent),
                    const SizedBox(width: 3),
                    Text('Hot', style: AppTextStyles.badge),
                  ]),
                )),
          ]),
        ),
      ),
      const SizedBox(height: AppDimensions.gapS),
      Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.subTitle),
      Text(price, style: AppTextStyles.price),
    ],
  );
}
