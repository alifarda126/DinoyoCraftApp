import 'package:flutter/material.dart';

import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class StoreItem {
  const StoreItem({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.imagePath,
  });
  final String id;
  final String name;
  final String address;
  final double rating;
  final String imagePath;
}

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});
  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  String _query = '';

  static const _stores = [
    StoreItem(id: '1', name: 'Dinoyo Ceramic Studio', address: 'Jl. MT Haryono, Dinoyo, Malang', rating: 4.9, imagePath: AppAssets.storeDinoyo),
    StoreItem(id: '2', name: 'Karya Tanah', address: 'Kampung Keramik Dinoyo, Malang', rating: 4.9, imagePath: AppAssets.storeRuangTanah),
    StoreItem(id: '3', name: 'Ruang Tanah', address: 'Jl. Keramik No. 12, Dinoyo', rating: 4.9, imagePath: AppAssets.storeDinoyo),
    StoreItem(id: '4', name: 'Dinoyo Craft House', address: 'Jl. Simpang Gajayana, Malang', rating: 4.9, imagePath: AppAssets.storeRuangTanah),
  ];

  List<StoreItem> get _filtered => _query.isEmpty
      ? _stores
      : _stores.where((s) => s.name.toLowerCase().contains(_query.toLowerCase()) || s.address.toLowerCase().contains(_query.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverPadding(padding: EdgeInsets.only(top: 0)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppDimensions.pageHorizontal, 56, AppDimensions.pageHorizontal, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Temukan Toko', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppDimensions.gapS),
                Text('Kenali toko dan pengrajin keramik lokal di Dinoyo.', style: AppTextStyles.bodySmall),
                const SizedBox(height: AppDimensions.paddingL),
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Cari toko atau pengrajin...',
                    hintStyle: AppTextStyles.fieldHint,
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                    filled: true,
                    fillColor: AppColors.inputBg,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusL), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingL),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppDimensions.pageHorizontal, 0, AppDimensions.pageHorizontal, AppDimensions.bottomNavClearance),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _StoreTile(
                store: _filtered[i],
                onTap: () {
                  // TODO: context.push('/store/${_filtered[i].id}')
                },
              ),
              childCount: _filtered.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _StoreTile extends StatelessWidget {
  const _StoreTile({required this.store, required this.onTap});
  final StoreItem store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              child: Image.asset(store.imagePath, width: 64, height: 64, fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(color: AppColors.inputBg, child: const SizedBox(width: 64, height: 64))),
            ),
            const SizedBox(width: AppDimensions.gapM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.name, style: AppTextStyles.subTitle),
                  Text(store.address, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(store.rating.toStringAsFixed(1), style: AppTextStyles.ratingBadge),
                  ]),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
