import 'package:flutter/material.dart';

import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class WorkshopPage extends StatelessWidget {
const   WorkshopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero image
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      AppAssets.workshopHero,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => ColoredBox(color: AppColors.inputBg),
                    ),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.pageHorizontal),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter, end: Alignment.topCenter,
                          colors: [Colors.black87, Colors.transparent],
                        ),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Pengrajin Sedang Membentuk Tanah Liat',
                            style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                        Text('Kampung Keramik Dinoyo Malang',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.white, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                ],
              ),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.pageHorizontal, AppDimensions.paddingXL,
                  AppDimensions.pageHorizontal, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Workshop Keramik Dinoyo', style: AppTextStyles.sectionTitle),
                    SizedBox(height: AppDimensions.gapS),
                    Text(
                      'Rasakan pengalaman membuat keramik langsung\nbersama pengrajin lokal.',
                      style: AppTextStyles.bodySmall,
                    ),
                    SizedBox(height: AppDimensions.paddingXXL),

                    Text('Pengalaman Membuat Keramik', style: AppTextStyles.cardTitle),
                    SizedBox(height: AppDimensions.gapM),
                    Text(
                      'Luangkan waktu bersama teman atau keluarga untuk mencoba membuat keramik secara '
                      'langsung. Belajar dari pengrajin lokal, mencoba proses pembuatan keramik, dan membawa '
                      'pulang pengalaman yang berkesan dari Dinoyo.',
                      style: AppTextStyles.bodySmall,
                    ),
                    SizedBox(height: AppDimensions.paddingXXL),

                    // Info box
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ingin Ikut Workshop?', style: AppTextStyles.cardTitle),
                          SizedBox(height: AppDimensions.gapS),
                          Text(
                            'Hubungi contact person untuk mengetahui jadwal, harga, dan ketersediaan workshop.',
                            style: AppTextStyles.bodySmall,
                          ),
                          SizedBox(height: AppDimensions.paddingL),
                          SizedBox(
                            width: double.infinity,
                            height: AppDimensions.buttonHeight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: url_launcher untuk WhatsApp/kontak
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.black,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: StadiumBorder(),
                              ),
                              icon: Icon(Icons.phone_outlined, size: 18),
                              label: Text('Hubungi Kami', style: AppTextStyles.buttonLabel),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimensions.bottomNavClearance),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
