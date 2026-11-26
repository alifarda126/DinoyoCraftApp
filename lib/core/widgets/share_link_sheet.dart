import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';
import '../theme/app_colors.dart';
import '../../data/mock_data.dart';

const MethodChannel _nativeShareChannel = MethodChannel('com.dinoyocraft/share');

/// Mengubah nama produk atau toko menjadi slug URL bersih dan profesional.
String slugifyUrlSegment(String raw) {
  return raw
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}

/// Membangun URL App Link produk berdasarkan nama produk (dan ID bila ada nama kembar).
String buildProductShareUrl({
  required String productId,
  required String productName,
}) {
  final slug = slugifyUrlSegment(productName);
  if (slug.isEmpty) {
    return 'https://dinoyocraft.my.id/product/$productId';
  }
  final duplicateCount = MockData.products
      .where((p) => slugifyUrlSegment(p.name) == slug && p.id != productId)
      .length;
  if (duplicateCount > 0 && productId.trim().isNotEmpty) {
    return 'https://dinoyocraft.my.id/product/$slug-$productId';
  }
  return 'https://dinoyocraft.my.id/product/$slug';
}

/// Membangun URL App Link toko berdasarkan nama toko (dan ID bila ada nama kembar).
String buildStoreShareUrl({
  required String storeName,
  int? storeId,
  int? fallbackIndex,
}) {
  final slug = slugifyUrlSegment(storeName);
  final idSuffix = (storeId != null && storeId > 0)
      ? storeId.toString()
      : (fallbackIndex ?? 0).toString();
  if (slug.isEmpty) {
    return 'https://dinoyocraft.my.id/store/$idSuffix';
  }
  final duplicateCount = MockData.stores
      .where((s) =>
          slugifyUrlSegment(s.name) == slug &&
          (storeId == null || storeId <= 0 || s.id != storeId))
      .length;
  if (duplicateCount > 0) {
    return 'https://dinoyocraft.my.id/store/$slug-$idSuffix';
  }
  return 'https://dinoyocraft.my.id/store/$slug';
}

/// Menampilkan sheet 2 opsi berbagi tautan:
/// 1) Salin Link
/// 2) Lainnya (membuka share sheet sistem ke WhatsApp, Telegram, dll.)
Future<void> showShareLinkOptionsSheet(
  BuildContext context, {
  required String title,
  required String url,
  String? subtitle,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderAlt,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Bagikan'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: AppColors.border),
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.link_rounded, color: AppColors.ink, size: 20),
                ),
                title: Text(
                  'Salin Link'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                subtitle: Text(
                  'Salin tautan ke papan klip perangkat'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Clipboard.setData(ClipboardData(text: url));
                  messenger.hideCurrentSnackBar();
                  messenger.showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      content: Text('Tautan berhasil disalin ke clipboard'.tr),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: AppColors.border),
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.share_outlined, color: AppColors.ink, size: 20),
                ),
                title: Text(
                  'Lainnya'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                subtitle: Text(
                  'Bagikan langsung ke WhatsApp, Instagram, atau aplikasi lain'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () async {
                  Navigator.of(sheetCtx).pop();
                  final shareText = subtitle != null && subtitle.trim().isNotEmpty
                      ? '$title — $subtitle\n$url'
                      : '$title\n$url';
                  try {
                    await _nativeShareChannel.invokeMethod('shareText', {
                      'text': shareText,
                      'subject': title,
                      'chooserTitle': 'Bagikan melalui'.tr,
                    });
                  } catch (_) {
                    Clipboard.setData(ClipboardData(text: url));
                    messenger.showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('Tautan berhasil disalin ke clipboard'.tr),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
