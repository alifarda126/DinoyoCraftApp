import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';
import '../assets.dart';
import '../theme/app_colors.dart';

class DinoyoSticker {
  const DinoyoSticker({
    required this.assetPath,
    required this.title,
  });

  final String assetPath;
  final String title;
}

class StickerPickerSheet extends StatelessWidget {
  const StickerPickerSheet({
    super.key,
    required this.onSelected,
  });

  final ValueChanged<DinoyoSticker> onSelected;

  static const List<DinoyoSticker> stickers = [
    DinoyoSticker(
      assetPath: AppAssets.stickerClayHalo,
      title: 'Halo!',
    ),
    DinoyoSticker(
      assetPath: AppAssets.stickerClayThumbsup,
      title: 'Mantap 👍',
    ),
    DinoyoSticker(
      assetPath: AppAssets.stickerClayPacking,
      title: 'Packing Aman',
    ),
    DinoyoSticker(
      assetPath: AppAssets.stickerClayLove,
      title: 'Suka Banget ❤️',
    ),
    DinoyoSticker(
      assetPath: AppAssets.stickerClayCrafting,
      title: 'Workshop',
    ),
    DinoyoSticker(
      assetPath: AppAssets.stickerClayTanya,
      title: 'Tanya Dulu',
    ),
    DinoyoSticker(
      assetPath: AppAssets.stickerClayDiskon,
      title: 'Ada Diskon?',
    ),
    DinoyoSticker(
      assetPath: AppAssets.stickerClayMakasih,
      title: 'Terima Kasih',
    ),
  ];

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<DinoyoSticker> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) => SafeArea(
        top: false,
        child: StickerPickerSheet(
          onSelected: (sticker) {
            Navigator.of(sheetCtx).pop();
            onSelected(sticker);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stiker Si Clay'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Mascot Tembikar DinoyoCraft'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                  tooltip: 'Tutup'.tr,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: AppColors.divider),

          // Grid Stiker
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stickers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final sticker = stickers[index];
                return InkWell(
                  onTap: () => onSelected(sticker),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderAlt.withValues(alpha: 0.35),
                      ),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              sticker.assetPath,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => Icon(
                                Icons.image_not_supported_rounded,
                                color: AppColors.textMuted,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sticker.title.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Pack Bar (mirip Shopee sticker pack bar)
          Divider(height: 1, color: AppColors.divider),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surface,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderAlt),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      AppAssets.stickerClayHalo,
                      width: 26,
                      height: 26,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Si Clay Keramik (8 Stiker)'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Ketuk untuk kirim'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
