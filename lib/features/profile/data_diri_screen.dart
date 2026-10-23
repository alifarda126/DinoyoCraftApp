import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/services/photo_picker_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';

class DataDiriScreen extends StatefulWidget {
const   DataDiriScreen({super.key});

  @override
  State<DataDiriScreen> createState() => _DataDiriScreenState();
}

class _DataDiriScreenState extends State<DataDiriScreen> {
  late final TextEditingController _nameController = TextEditingController(
    text: 'Customer',
  );
  late final TextEditingController _usernameController = TextEditingController(
    text: 'customer',
  );
  late final TextEditingController _emailController = TextEditingController(
    text: 'customer@gmail.com',
  );
  late final TextEditingController _phoneController = TextEditingController(
    text: '+62 859-777-588-138',
  );
  late final TextEditingController _birthController = TextEditingController(
    text: '14 Agustus 1998',
  );

  bool _isMale = true;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _phoneFocus.dispose();
    for (final c in [
      _nameController,
      _usernameController,
      _emailController,
      _phoneController,
      _birthController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      // Bar simpan di slot bottomNavigationBar (bukan di dalam body): saat
      // keyboard terbuka body menyusut, tetapi bar TETAP di dasar layar dan
      // tertutup keyboard — konsisten dengan bottom nav di halaman pencarian
      // produk/toko.
      bottomNavigationBar: _buildSaveBar(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
                children: [
                  _buildTitleBlock(),
                  const SizedBox(height: 16),
                  _buildAvatarSection(),
                  const SizedBox(height: 20),
                  _buildLabelRow('Nama Lengkap'.tr, hint: 'Sesuai KTP'.tr),
                  _buildField(
                    controller: _nameController,
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                  _buildLabelRow(
                    'Username'.tr,
                    badge: 'Tersedia'.tr,
                  ),
                  _buildField(
                    controller: _usernameController,
                    icon: Icons.alternate_email_rounded,
                    prefixText: '@',
                  ),
                  const SizedBox(height: 6),
                  _buildHelper(
                    'Username profil dinoyocraft.id/@customer. Ubah 30 hari sekali.'.tr,
                  ),
                  const SizedBox(height: 14),
                  _buildLabelRow('Alamat Email'.tr),
                  _buildField(
                    controller: _emailController,
                    icon: Icons.mail_outline_rounded,
                    focusNode: _emailFocus,
                    suffix: _buildVerifiedSuffix(
                      onEdit: () => _emailFocus.requestFocus(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildLabelRow('Nomor WhatsApp / Seluler'.tr),
                  _buildField(
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    focusNode: _phoneFocus,
                    suffix: _buildVerifiedSuffix(
                      onEdit: () => _phoneFocus.requestFocus(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildLabelRow('Jenis Kelamin'.tr),
                  _buildGenderSegment(),
                  const SizedBox(height: 14),
                  _buildLabelRow('Tanggal Lahir'.tr),
                  _buildField(
                    controller: _birthController,
                    icon: Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: _selectBirthDate,
                  ),
                  const SizedBox(height: 18),
                  _buildNoticeBox(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Ubah foto profil: sheet pilih sumber (kamera/galeri) → ambil foto.
  /// Hasil disimpan ke [MockData.userProfilePhotoPath] dan [MockData.userProfilePhotoBytes]
  /// agar avatar di seluruh layar profil langsung tersinkronisasi.
  Future<void> _changeProfilePhoto() async {
    final file = await PhotoPickerService.pickWithSheet(
      context,
      title: 'Ubah Foto Profil'.tr,
      subtitle: 'Pilih sumber foto baru untuk profilmu.'.tr,
    );
    if (file == null || !mounted) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() {
      MockData.userProfilePhotoPath = file.path;
      MockData.userProfilePhotoBytes = bytes;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.black,
        content: Text(
          'Foto profil berhasil diperbarui.'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final initialDate = DateTime(1998, 8, 14);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.black,
              onPrimary: AppColors.white,
              surface: AppColors.surface,
              onSurface: AppColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      setState(() {
        _birthController.text =
            '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      });
    }
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          ),
          Expanded(
            child: Text(
              'Kelola Data Diri'.tr,
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

  Widget _buildTitleBlock() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ubah Data Diri'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Kelola informasi akun dan profil pengrajin Anda'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.borderAlt),
          ),
          child: Text(
            'ID #8821',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarImage() {
    if (MockData.userProfilePhotoBytes != null) {
      return Image.memory(
        MockData.userProfilePhotoBytes!,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _avatarPlaceholder(),
      );
    }
    if (MockData.userProfilePhotoPath != null) {
      return Image.file(
        File(MockData.userProfilePhotoPath!),
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _avatarPlaceholder(),
      );
    }
    return _avatarPlaceholder();
  }

  Widget _avatarPlaceholder() {
    return Icon(
      Icons.person_outline_rounded,
      size: 44,
      color: AppColors.ink,
    );
  }

  Widget _buildAvatarSection() {
    return Row(
      children: [
        GestureDetector(
          onTap: _changeProfilePhoto,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderAlt),
                ),
                child: _buildAvatarImage(),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _changeProfilePhoto,
                child: Text(
                  'Ubah Foto Profil'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Format JPG, PNG atau WEBP. Maksimal 5 MB.'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabelRow(
    String label, {
    String? hint,
    String? badge,
    bool verified = false,
    VoidCallback? onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          // Expanded: saat layar sempit label menyusut dengan ellipsis,
          // bukan meluap ke kanan bersama badge/hint di sebelahnya.
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
          if (hint != null) ...[
            SizedBox(width: 8),
            Flexible(
              child: Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
          if (badge != null) ...[
            SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.borderAlt),
              ),
              child: Text(
                badge,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
          if (verified) ...[
            SizedBox(width: 8),
            _buildVerifiedSuffix(onEdit: onEdit),
          ],
        ],
      ),
    );
  }

  Widget _buildVerifiedSuffix({VoidCallback? onEdit}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF50B0FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_rounded,
                  size: 11,
                  color: AppColors.ink,
                ),
                const SizedBox(width: 3),
                Text(
                  'Verif'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onEdit,
            child: Text(
              'Ubah'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    String prefixText = '',
    FocusNode? focusNode,
    Widget? suffix,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      onTap: onTap,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: AppColors.ink,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
        prefixText: prefixText,
        prefixStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        suffixIcon: suffix,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderAlt),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderAlt),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.ink),
        ),
      ),
    );
  }

  Widget _buildHelper(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 12,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSegment() {
    return Row(
      children: [
        Expanded(
          child: _genderButton(
            label: 'Laki-laki',
            iconAsset: AppAssets.iconMale,
            selected: _isMale,
            onTap: () => setState(() => _isMale = true),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _genderButton(
            label: 'Perempuan',
            iconAsset: AppAssets.iconFemale,
            selected: !_isMale,
            onTap: () => setState(() => _isMale = false),
          ),
        ),
      ],
    );
  }

  Widget _genderButton({
    required String label,
    required String iconAsset,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;

    final Color bgColor;
    final Color borderColor;
    final Color contentColor;

    if (selected) {
      bgColor = isDark ? AppColors.white : AppColors.black;
      borderColor = isDark ? AppColors.white : AppColors.black;
      contentColor = isDark ? AppColors.black : AppColors.white;
    } else {
      bgColor = AppColors.surface;
      borderColor = AppColors.borderAlt;
      contentColor = isDark ? AppColors.textSecondary : AppColors.ink;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 14,
              height: 14,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                contentColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            // Flexible + ellipsis: tombol gender bisa meluap saat layar
            // sangat sempit karena ikon + teks melebihi setengah lebar.
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: contentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeBox() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pastikan data diri sesuai dengan identitas resmi untuk '
              'kemudahan verifikasi pesanan dan pengiriman keramik di '
              'Aplikasi DinoyoCraft.'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveBar() {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        14 + (bottomInset > 0 ? bottomInset : 10),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.black,
                      content: Text(
                        'Perubahan data diri disimpan.'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  );
                  context.pop();
                },
                icon: SvgPicture.asset(
                  AppAssets.iconSave,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(
                  'Simpan Perubahan'.tr,
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
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                shape: StadiumBorder(),
              ),
              child: Text(
                'Batalkan'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
