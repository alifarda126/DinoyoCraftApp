import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_text.dart';
import '../../../core/theme/app_colors.dart';

/// Helper untuk menampilkan modal bottom sheet pelaporan toko.
Future<bool?> showModalLaporkanToko(
  BuildContext context, {
  required String storeName,
  String? storeImage,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x73000000),
    builder: (_) => ModalLaporkanToko(
      storeName: storeName,
      storeImage: storeImage,
    ),
  );
}

/// Modal Bottom Sheet interaktif untuk melaporkan toko yang bermasalah.
class ModalLaporkanToko extends StatefulWidget {
  const ModalLaporkanToko({
    super.key,
    required this.storeName,
    this.storeImage,
  });

  final String storeName;
  final String? storeImage;

  @override
  State<ModalLaporkanToko> createState() => _ModalLaporkanTokoState();
}

class _ModalLaporkanTokoState extends State<ModalLaporkanToko> {
  static const List<String> _reasons = [
    'Melanggar ketentuan harga (price dumping)',
    'Foto produk menggunakan gambar curian',
    'Toko terindikasi penipuan atau pesanan fiktif',
    'Menjual produk tiruan atau pelanggaran hak cipta',
    'Penyalahgunaan data pribadi pembeli',
    'Lainnya',
  ];

  String? _selectedReason = 'Melanggar ketentuan harga (price dumping)';
  final TextEditingController _customReasonController = TextEditingController();
  final FocusNode _customReasonFocus = FocusNode();
  String? _errorMessage;

  @override
  void dispose() {
    _customReasonController.dispose();
    _customReasonFocus.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() {
      _errorMessage = null;
    });

    if (_selectedReason == null) {
      setState(() {
        _errorMessage = 'Pilih salah satu alasan pelaporan'.tr;
      });
      return;
    }

    if (_selectedReason == 'Lainnya' &&
        _customReasonController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Harap tuliskan alasan pelaporan'.tr;
      });
      _customReasonFocus.requestFocus();
      return;
    }

    // Berhasil divalidasi, tutup modal dan kirim sinyal sukses
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final screenH = mediaQuery.size.height;
    final maxAllowedHeight =
        (screenH - bottomInset - mediaQuery.padding.top - 16.0)
            .clamp(250.0, screenH * 0.90);

    final isDark = AppColors.isDark;

    return Container(
      margin: EdgeInsets.only(bottom: bottomInset),
      constraints: BoxConstraints(
        maxHeight: maxAllowedHeight,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 32,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag Handle ──
            Center(
              child: Container(
                width: 44,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.border : const Color(0xFFD5D5D5),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),

            // ── Header Modal ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.danger.withValues(alpha: 0.2)
                          : const Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.flag_rounded,
                      color: AppColors.danger,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Laporkan Toko'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.storeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColors.ink,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: AppColors.border),

            // ── Scrollable Body ──
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Beri tahu kami masalah apa yang Anda temukan pada toko ini untuk membantu menjaga persaingan sehat dan keamanan berbelanja di DinoyoCraft.'
                          .tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        height: 1.45,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Pilih Alasan Pelaporan'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Daftar Alasan Pelaporan
                    ..._reasons.map((reason) {
                      final isSelected = _selectedReason == reason;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                _selectedReason = reason;
                                _errorMessage = null;
                              });
                              if (reason == 'Lainnya') {
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () => _customReasonFocus.requestFocus(),
                                );
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark
                                        ? AppColors.danger.withValues(alpha: 0.15)
                                        : const Color(0xFFFFF4F4))
                                    : AppColors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.danger
                                      : (isDark
                                          ? AppColors.border
                                          : const Color(0xFFE5E5E5)),
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.danger
                                            : AppColors.textSecondary,
                                        width: isSelected ? 6 : 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      reason.tr,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? (isDark
                                                ? Colors.white
                                                : const Color(0xFFB71C1C))
                                            : AppColors.ink,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    // Input Alasan Kustom Jika "Lainnya" Dipilih
                    if (_selectedReason == 'Lainnya') ...[
                      const SizedBox(height: 8),
                      Text(
                        'Tuliskan alasan pelaporan Anda'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _customReasonController,
                        focusNode: _customReasonFocus,
                        maxLines: 3,
                        maxLength: 250,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.ink,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Tuliskan alasan pelaporan toko secara rinci...'
                                  .tr,
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: AppColors.textMuted,
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceSubtle,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? AppColors.border
                                  : const Color(0xFFE0E0E0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? AppColors.border
                                  : const Color(0xFFE0E0E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.danger,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                        },
                      ),
                    ],

                    // Pesan Error jika validasi gagal
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 15,
                            color: AppColors.danger,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Divider(height: 1, thickness: 1, color: AppColors.border),

            // ── Bottom Action Buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.ink,
                        shape: const StadiumBorder(),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.border
                              : const Color(0xFFCCCCCC),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Batal'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: AppColors.darkButtonShadow,
                      ),
                      child: FilledButton(
                        onPressed: _onSubmit,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.black,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: AppColors.stadiumButtonShape,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Kirim Laporan'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
