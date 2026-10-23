import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';
import '../theme/app_colors.dart';

/// Layanan terpusat pemilihan foto dari kamera / galeri perangkat.
///
/// Dipakai SEMUA tombol yang mengarah ke kamera & galeri:
/// - Ubah Foto Profil (Kelola Data Diri & Pengaturan Akun)
/// - Lampiran foto di Chat & ChatBot
/// - Tambah foto pada Tulis Ulasan
///
/// Catatan izin: `image_picker` memakai aplikasi kamera sistem (intent
/// ACTION_IMAGE_CAPTURE) dan photo picker sistem untuk galeri, sehingga
/// TIDAK perlu izin runtime tambahan selama manifest tidak mendeklarasikan
/// izin CAMERA / storage.
class PhotoPickerService {
  PhotoPickerService._();

  static final ImagePicker _picker = ImagePicker();

  /// Batas ukuran foto (5 MB, sesuai ketentuan form profil).
  static const int maxBytes = 5 * 1024 * 1024;

  /// Alur lengkap: tampilkan sheet pilihan sumber → pilih foto.
  /// Mengembalikan null bila pengguna membatalkan di salah satu langkah.
  static Future<XFile?> pickWithSheet(
    BuildContext context, {
    String? title,
    String? subtitle,
  }) async {
    final source = await showSourceSheet(context, title: title, subtitle: subtitle);
    if (source == null || !context.mounted) return null;
    return pick(context, source);
  }

  /// Bottom sheet pemilihan sumber foto: Kamera atau Galeri.
  /// Mengembalikan [ImageSource] yang dipilih, null bila ditutup.
  static Future<ImageSource?> showSourceSheet(
    BuildContext context, {
    String? title,
    String? subtitle,
  }) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Pilih Sumber Foto'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              _option(
                sheetCtx,
                source: ImageSource.camera,
                icon: Icons.photo_camera_rounded,
                label: 'Kamera'.tr,
                description: 'Ambil foto baru menggunakan kamera.'.tr,
              ),
              const SizedBox(height: 10),
              _option(
                sheetCtx,
                source: ImageSource.gallery,
                icon: Icons.photo_library_rounded,
                label: 'Galeri'.tr,
                description: 'Pilih foto yang sudah ada di galeri.'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _option(
    BuildContext sheetCtx, {
    required ImageSource source,
    required IconData icon,
    required String label,
    required String description,
  }) {
    return InkWell(
      onTap: () => Navigator.of(sheetCtx).pop(source),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderAlt),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: AppColors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  /// Membuka kamera / galeri sesuai [source] dan mengembalikan foto terpilih.
  ///
  /// Foto dikompres (maks lebar 1600px, kualitas 85) dan divalidasi ≤ 5 MB.
  /// Mengembalikan null bila pengguna membatalkan; error (izin ditolak,
  /// kamera tak tersedia) ditampilkan sebagai SnackBar.
  static Future<XFile?> pick(BuildContext context, ImageSource source) async {
    XFile? file;
    try {
      file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
    } catch (e) {
      debugPrint('PhotoPickerService pick error for $source: $e');
      if (source == ImageSource.camera) {
        // Jika kamera tidak dapat dibuka (mis. di desktop Windows atau perangkat tanpa hardware kamera),
        // otomatis alihkan ke galeri/file picker agar proses tidak buntu dan bisa langsung diakses.
        try {
          if (context.mounted) {
            _toast(
              context,
              'Kamera tidak tersedia di perangkat ini. Membuka galeri foto...'.tr,
            );
          }
          file = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
            maxWidth: 1600,
          );
        } catch (fallbackError) {
          debugPrint('PhotoPickerService gallery fallback error: $fallbackError');
        }
      }

      if (file == null && context.mounted) {
        _toast(
          context,
          source == ImageSource.camera
              ? 'Tidak dapat membuka Kamera. Periksa izin kamera lalu coba lagi.'.tr
              : 'Tidak dapat membuka Galeri. Periksa izin penyimpanan lalu coba lagi.'.tr,
        );
        return null;
      }
    }
    if (file == null) return null;

    try {
      if (await file.length() > maxBytes) {
        if (context.mounted) {
          _toast(context, 'Ukuran foto maksimal 5 MB. Pilih foto yang lebih kecil.'.tr);
        }
        return null;
      }
    } catch (_) {
      // Gagal membaca ukuran — biarkan file dipakai, jangan blokir pengguna.
    }
    return file;
  }

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.black,
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
