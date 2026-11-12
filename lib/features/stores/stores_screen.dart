import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/dc_app_header.dart';
import '../../core/widgets/dc_cached_image.dart';
import '../../data/mock_data.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    if (MockData.stores.isEmpty) {
      MockData.fetchPublicData().then((_) {
        if (mounted) setState(() {});
      });
    }
  }

  Future<void> _handleRefresh() async {
    await MockData.fetchPublicData(force: true);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final stores = MockData.filterStores(_query);
    final topHeaderHeight = DcAppHeader.totalHeight(context);

    return Scaffold(
      // Scaffold diperlukan sebagai ancestor Material untuk TextField/InkWell;
      // tanpa ini halaman melempar error rendering.
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.ink,
        backgroundColor: AppColors.surfaceElevated,
        edgeOffset: topHeaderHeight,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverPinnedDcHeader(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Temukan Toko'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Jelajahi studio pengrajin keramik Dinoyo.'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 14),
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: InputDecoration(
                    hintText: 'Cari toko...'.tr,
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        AppAssets.iconSearch,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          AppColors.textMuted,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.inputBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 12,
              // Tinggi fixed — gambar pakai AspectRatio agar konsisten
              childAspectRatio: 0.78,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final store = stores[index];
              return InkWell(
                // Index route harus mengacu ke list penuh, bukan hasil filter,
                // agar detail toko yang terbuka selalu sesuai kartu yang diklik.
                onTap: () => context.push('/store/${MockData.stores.indexOf(store)}'),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.6),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar: Expanded → mengisi sisa tinggi cell
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: DcCachedImage(
                                imageUrl: (store.banner != null && store.banner!.isNotEmpty)
                                    ? store.banner!
                                    : Store.defaultBanner,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              left: 8,
                              bottom: 8,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFF000000), Color(0xFFC0673D)],
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: store.hasCustomAvatar
                                      ? DcCachedImage(
                                          imageUrl: store.avatar ?? store.image,
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: Text(
                                            store.initials,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Area teks: tinggi menyesuaikan, tapi dibatasi
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              store.location,
                              maxLines: 1, // fix ke 1 baris agar konsisten
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.iconStar,
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  store.rating > 0
                                      ? store.rating.toStringAsFixed(1)
                                      : (AppText.isEnglish ? 'New' : 'Baru'),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: stores.length),
          ),
        ),
        ],
      ),
    ),
  );
}
}
