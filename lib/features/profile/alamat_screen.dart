import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/theme/app_colors.dart';

class Alamat {
const   Alamat({
    required this.label,
    required this.recipient,
    required this.phone,
    required this.address,
    this.isPrimary = false,
    this.courierNote,
    this.verifiedPin = false,
  });

  final String label;
  final String recipient;
  final String phone;
  final String address;
  final bool isPrimary;
  final String? courierNote;
  final bool verifiedPin;

  Alamat copyWith({
    String? label,
    String? recipient,
    String? phone,
    String? address,
    bool? isPrimary,
    String? courierNote,
    bool? verifiedPin,
  }) {
    return Alamat(
      label: label ?? this.label,
      recipient: recipient ?? this.recipient,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isPrimary: isPrimary ?? this.isPrimary,
      courierNote: courierNote ?? this.courierNote,
      verifiedPin: verifiedPin ?? this.verifiedPin,
    );
  }
}

class AlamatScreen extends StatefulWidget {
const   AlamatScreen({super.key});

  @override
  State<AlamatScreen> createState() => _AlamatScreenState();
}

class _AlamatScreenState extends State<AlamatScreen> {
  Color get _destructive => AppColors.danger;

  final List<Alamat> _addresses = [
    Alamat(
      label: 'Rumah',
      recipient: 'Customer',
      phone: '+62 812-3456-7890',
      address:
          'Jl. Raya Sukun No. 128, RT 03 / RW 02, Sukun Raya, Kec. Sukun, '
          'Kota Malang, Jawa Timur 65144',
      isPrimary: true,
      courierNote:
          '"Pagar hitam depan studio keramik, titip ke satpam jika tidak '
          'ada di tempat."',
      verifiedPin: true,
    ),
    Alamat(
      label: 'Kantor',
      recipient: 'Customer (Kantor)',
      phone: '+62 812-9876-5432',
      address:
          'Kantor Dinoyo Hub, Jl. Mayjen Haryono No. 9, Dinoyo, Lowokwaru, '
          'Kota Malang, Jawa Timur 65145',
      courierNote: 'Lantai 2 divisi artisan keramik',
      verifiedPin: true,
    ),
  ];

  void _showFeedback(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.black,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _makePrimary(int index) {
    if (index >= _addresses.length) return;
    final selected = _addresses[index];
    setState(() {
      final addr = _addresses.removeAt(index);
      _addresses.insert(0, addr.copyWith(isPrimary: true));
      for (var i = 1; i < _addresses.length; i++) {
        if (_addresses[i].isPrimary) {
          _addresses[i] = _addresses[i].copyWith(isPrimary: false);
        }
      }
    });
    _showFeedback('Alamat "${selected.label}" dijadikan alamat utama.');
  }

  void _confirmDeleteAddress(int index) {
    if (index >= _addresses.length) return;
    final addr = _addresses[index];

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Hapus Alamat?'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus alamat "${addr.label.tr}" (${addr.recipient})? Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Batal'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              setState(() {
                final wasPrimary = addr.isPrimary;
                _addresses.removeAt(index);
                // Jika yang dihapus alamat utama dan masih ada alamat lain, jadikan yang pertama sebagai utama
                if (wasPrimary && _addresses.isNotEmpty) {
                  _addresses[0] = _addresses[0].copyWith(isPrimary: true);
                }
              });
              _showFeedback('Alamat "${addr.label.tr}" berhasil dihapus.');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _destructive,
              foregroundColor: AppColors.white,
              shape: StadiumBorder(),
              elevation: 0,
            ),
            child: Text(
              'Hapus'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPinpointModal(Alamat addr) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Color(0x73000000),
      builder: (sheetCtx) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.borderAlt,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: AppColors.danger,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Titik Peta Terverifikasi'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          '${addr.label.tr} • ${addr.recipient}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(sheetCtx),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderAlt),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.gps_fixed_rounded,
                          size: 16,
                          color: AppColors.successText,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Koordinat GPS Terhubung'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.successText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      addr.address,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Latitude: -7.9423 • Longitude: 112.6105 (Sentra Dinoyo Malang)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: AppColors.darkButtonShadow,
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetCtx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: AppColors.white,
                      shape: AppColors.stadiumButtonShape,
                      elevation: 0,
                    ),
                    child: Text(
                      'Tutup'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyAddress(Alamat addr) {
    final fullText =
        '${addr.recipient} (${addr.phone})\n${addr.address}${addr.courierNote != null ? '\nCatatan: ${addr.courierNote}' : ''}';
    Clipboard.setData(ClipboardData(text: fullText));
    _showFeedback('Alamat "${addr.label}" berhasil disalin ke clipboard.');
  }

  void _openAddressFormSheet({int? editIndex, Alamat? existing}) {
    if (editIndex == null && _addresses.length >= 5) {
      _showFeedback(
        'Maksimal 5 alamat tersimpan. Hapus atau ubah alamat yang ada.',
      );
      return;
    }

    final isEditing = editIndex != null && existing != null;
    String selectedLabel = existing?.label ?? 'Rumah';
    final recipientCtrl = TextEditingController(
      text: existing?.recipient ?? 'Customer',
    );
    final phoneCtrl = TextEditingController(
      text: existing?.phone ?? '+62 812-3456-7890',
    );
    final addressCtrl = TextEditingController(text: existing?.address ?? '');
    final courierNoteCtrl = TextEditingController(
      text: existing?.courierNote?.replaceAll('"', '') ?? '',
    );
    bool isPrimary = existing?.isPrimary ?? (_addresses.isEmpty);
    bool verifiedPin = existing?.verifiedPin ?? true;
    String? errorMessage;

    final labelOptions = ['Rumah', 'Kantor', 'Apartemen', 'Studio', 'Lainnya'];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(0x73000000),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final mediaQuery = MediaQuery.of(context);
            final bottomInset = mediaQuery.viewInsets.bottom;
            final topPadding = mediaQuery.padding.top;
            final screenH = mediaQuery.size.height;
            final maxAllowedHeight = (screenH - bottomInset - topPadding - 12.0)
                .clamp(200.0, screenH * 0.88);

            return Container(
              margin: EdgeInsets.only(bottom: bottomInset),
              constraints: BoxConstraints(
                maxHeight: maxAllowedHeight,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(top: 12, bottom: 8),
                        decoration: BoxDecoration(
                          color: AppColors.borderAlt,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 12, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isEditing
                                      ? 'Ubah Alamat Pengiriman'.tr
                                      : 'Tambah Alamat Baru'.tr,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Pastikan rincian alamat tepat untuk kurir keramik'.tr,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded, size: 22),
                            onPressed: () => Navigator.pop(sheetContext),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: AppColors.divider),
                    Expanded(
                      child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.manual,
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                        children: [
                          if (errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.dangerSurface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    color: AppColors.danger,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      errorMessage!,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: AppColors.danger,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 14),
                          ],

                          // Label Alamat Chips
                          Text(
                            'LABEL ALAMAT'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: labelOptions.map((opt) {
                              final isSelected = selectedLabel == opt;
                              return ChoiceChip(
                                label: Text(opt.tr),
                                labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                selected: isSelected,
                                selectedColor: AppColors.black,
                                backgroundColor: AppColors.inputBg,
                                labelStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.ink,
                                ),
                                shape: StadiumBorder(),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.black
                                      : AppColors.borderAlt,
                                ),
                                onSelected: (_) {
                                  setModalState(() => selectedLabel = opt);
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),

                          // Nama Penerima
                          _buildFormField(
                            label: 'NAMA PENERIMA'.tr,
                            hint: 'Masukkan nama lengkap penerima'.tr,
                            controller: recipientCtrl,
                            icon: Icons.person_outline_rounded,
                          ),
                          SizedBox(height: 14),

                          // Nomor Telepon
                          _buildFormField(
                            label: 'NOMOR TELEPON / WHATSAPP'.tr,
                            hint: '+62 8xx-xxxx-xxxx',
                            controller: phoneCtrl,
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 14),

                          // Alamat Lengkap
                          _buildFormField(
                            label: 'ALAMAT LENGKAP'.tr,
                            hint:
                                'Nama jalan, nomor rumah, RT/RW, kelurahan, kecamatan, kota & kode pos'.tr,
                            controller: addressCtrl,
                            icon: Icons.location_on_outlined,
                            maxLines: 3,
                          ),
                          SizedBox(height: 14),

                          // Catatan untuk Kurir
                          _buildFormField(
                            label: 'CATATAN UNTUK KURIR (OPSIONAL)'.tr,
                            hint:
                                'cth: Pagar hitam depan studio keramik, titip satpam'.tr,
                            controller: courierNoteCtrl,
                            icon: Icons.note_outlined,
                            maxLines: 2,
                          ),
                          SizedBox(height: 16),

                          // Switch: Titik Peta GPS
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pin_drop_outlined,
                                  size: 20,
                                  color: AppColors.ink,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Verifikasi Titik Peta GPS'.tr,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                      Text(
                                        'Mempermudah kurir melacak alamat akurat'.tr,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: verifiedPin,
                                  activeThumbColor: AppColors.white,
                                  activeTrackColor: AppColors.black,
                                  inactiveThumbColor: AppColors.white,
                                  inactiveTrackColor: AppColors.border,
                                  trackOutlineColor:
                                      const WidgetStatePropertyAll<Color?>(
                                    Colors.transparent,
                                  ),
                                  onChanged: (v) =>
                                      setModalState(() => verifiedPin = v),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),

                          // Switch: Jadikan Alamat Utama
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star_outline_rounded,
                                  size: 20,
                                  color: AppColors.ink,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jadikan Alamat Utama'.tr,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                      Text(
                                        'Alamat prioritas saat checkout belanjaan'.tr,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: isPrimary,
                                  activeThumbColor: AppColors.white,
                                  activeTrackColor: AppColors.black,
                                  inactiveThumbColor: AppColors.white,
                                  inactiveTrackColor: AppColors.border,
                                  trackOutlineColor:
                                      const WidgetStatePropertyAll<Color?>(
                                    Colors.transparent,
                                  ),
                                  onChanged: (v) =>
                                      setModalState(() => isPrimary = v),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: AppColors.darkButtonShadow,
                              ),
                              child: ElevatedButton(
                              onPressed: () {
                                final r = recipientCtrl.text.trim();
                                final p = phoneCtrl.text.trim();
                                final a = addressCtrl.text.trim();
                                final note = courierNoteCtrl.text.trim();

                                if (r.isEmpty) {
                                  setModalState(() {
                                    errorMessage =
                                        'Nama penerima tidak boleh kosong.';
                                  });
                                  return;
                                }
                                if (p.isEmpty) {
                                  setModalState(() {
                                    errorMessage =
                                        'Nomor telepon tidak boleh kosong.';
                                  });
                                  return;
                                }
                                if (a.isEmpty) {
                                  setModalState(() {
                                    errorMessage =
                                        'Alamat lengkap tidak boleh kosong.';
                                  });
                                  return;
                                }

                                final newAddress = Alamat(
                                  label: selectedLabel,
                                  recipient: r,
                                  phone: p,
                                  address: a,
                                  isPrimary: isPrimary,
                                  courierNote: note.isNotEmpty
                                      ? '"$note"'
                                      : null,
                                  verifiedPin: verifiedPin,
                                );

                                setState(() {
                                  if (isEditing) {
                                    if (isPrimary) {
                                      _addresses.removeAt(editIndex);
                                      for (
                                        var i = 0;
                                        i < _addresses.length;
                                        i++
                                      ) {
                                        _addresses[i] = _addresses[i].copyWith(
                                          isPrimary: false,
                                        );
                                      }
                                      _addresses.insert(0, newAddress);
                                    } else {
                                      _addresses[editIndex] = newAddress;
                                    }
                                  } else {
                                    if (isPrimary || _addresses.isEmpty) {
                                      for (
                                        var i = 0;
                                        i < _addresses.length;
                                        i++
                                      ) {
                                        _addresses[i] = _addresses[i].copyWith(
                                          isPrimary: false,
                                        );
                                      }
                                      _addresses.insert(
                                        0,
                                        newAddress.copyWith(isPrimary: true),
                                      );
                                    } else {
                                      _addresses.add(newAddress);
                                    }
                                  }
                                });

                                Navigator.pop(sheetContext);
                                _showFeedback(
                                  isEditing
                                      ? 'Alamat "${newAddress.label}" berhasil diperbarui.'
                                      : 'Alamat "${newAddress.label}" berhasil ditambahkan.',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.black,
                                foregroundColor: AppColors.white,
                                shape: AppColors.stadiumButtonShape,
                                elevation: 0,
                              ),
                              child: Text(
                                isEditing
                                    ? 'Simpan Perubahan'.tr
                                    : 'Simpan Alamat Baru'.tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
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
          },
        );
      },
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: maxLines > 1
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: maxLines > 1 ? 8 : 0),
                child: Icon(icon, size: 18, color: AppColors.textSecondary),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  keyboardType: keyboardType,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.ink,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: hint,
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewPad = MediaQuery.viewPaddingOf(context).bottom;
    final pad = MediaQuery.paddingOf(context).bottom;
    final bottomInset = viewPad > 0 ? viewPad : pad;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.fromLTRB(20, 4, 20, 145 + bottomInset),
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Alamat Pengiriman Terdaftar'.tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.inputBg,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: AppColors.borderAlt),
                            ),
                            child: Text(
                              '${_addresses.length} ${'dari 5 alamat'.tr}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      if (_addresses.isEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Column(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: AppColors.inputBg,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_off_outlined,
                                  size: 32,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Belum Ada Alamat Tersimpan'.tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Tambahkan alamat pengiriman untuk memudahkan proses pembelian tembikar dan keramik Dinoyo.'.tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        for (final (i, addr) in _addresses.indexed)
                          _buildAddressCard(i, addr),
                      ],
                    ],
                  ),
                  // Frosted sticky footer
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        14,
                        20,
                        14 + bottomInset,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bg.withValues(alpha: 0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 6,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: AppColors.darkButtonShadow,
                              ),
                              child: FilledButton.icon(
                                onPressed: () => _openAddressFormSheet(),
                                icon: Icon(Icons.add_rounded, size: 18),
                                label: Text(
                                  'Tambah Alamat Baru'.tr,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.black,
                                  shape: AppColors.stadiumButtonShape,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Maksimal 5 alamat tersimpan untuk kemudahan checkout.'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
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

  Widget _buildHeader() {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/profile');
              }
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          ),
          Expanded(
            child: Text(
              'Kelola Alamat'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAddressCard(int index, Alamat addr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: addr.isPrimary ? AppColors.black : AppColors.borderAlt,
          width: addr.isPrimary ? 2 : 1,
        ),
        boxShadow: addr.isPrimary
            ? [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges row
          Row(
            children: [
              if (addr.isPrimary) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.home_rounded,
                        size: 12,
                        color: AppColors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Utama'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
              ],
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderAlt),
                ),
                child: Text(
                  addr.label.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Spacer(),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onSelected: (val) {
                  switch (val) {
                    case 'edit':
                      _openAddressFormSheet(
                        editIndex: index,
                        existing: addr,
                      );
                      break;
                    case 'primary':
                      _makePrimary(index);
                      break;
                    case 'copy':
                      _copyAddress(addr);
                      break;
                    case 'delete':
                      _confirmDeleteAddress(index);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (!addr.isPrimary)
                    PopupMenuItem(
                      value: 'primary',
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_outline_rounded,
                            size: 18,
                            color: AppColors.ink,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Jadikan Utama'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: AppColors.ink,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Ubah Alamat'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'copy',
                    child: Row(
                      children: [
                        Icon(
                          Icons.copy_rounded,
                          size: 18,
                          color: AppColors.ink,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Salin Alamat'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: _destructive,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Hapus Alamat'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _destructive,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          // Recipient
          Text(
            addr.recipient,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: 2),
          Text(
            addr.phone,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            addr.address,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.5,
              color: AppColors.ink,
            ),
          ),
          // Courier note
          if (addr.courierNote != null) ...[
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderAlt),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catatan untuk kurir:'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    addr.courierNote!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 12),
          // Bottom actions
          if (addr.isPrimary)
            Row(
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () => _showPinpointModal(addr),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              addr.verifiedPin
                                  ? 'Titik Peta\nTerverifikasi'.tr
                                  : 'Atur Titik\nPeta GPS'.tr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                height: 1.3,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                OutlinedButton(
                  onPressed: () => _openAddressFormSheet(
                    editIndex: index,
                    existing: addr,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.borderAlt),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: Text(
                    'Ubah Alamat'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                SizedBox(width: 6),
                IconButton(
                  onPressed: () => _confirmDeleteAddress(index),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: _destructive,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => _makePrimary(index),
                    child: Text(
                      'Jadikan Alamat Utama'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (addr.verifiedPin) ...[
                      InkWell(
                        onTap: () => _showPinpointModal(addr),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                    OutlinedButton(
                      onPressed: () => _openAddressFormSheet(
                        editIndex: index,
                        existing: addr,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.borderAlt),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(0, 38),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        'Ubah'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _confirmDeleteAddress(index),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _destructive),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(0, 38),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        'Hapus'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _destructive,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
