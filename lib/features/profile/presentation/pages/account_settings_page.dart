import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

// ─── Account Settings Page (DataDiri.dart + Pengaturan.dart → 1 page) ─────────
class AccountSettingsPage extends StatefulWidget {
const   AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  // TODO: Isi dari user repository / state management
  final _nameCtrl = TextEditingController(text: 'Customer');
  final _usernameCtrl = TextEditingController(text: 'customer');
  final _emailCtrl = TextEditingController(text: 'customer@gmail.com');
  final _phoneCtrl = TextEditingController(text: '+62 859-777-588-138');

  String _gender = 'Laki-laki';
  DateTime? _birthDate = DateTime(1998, 8, 14);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.black),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal lahir';
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Kelola Data Diri', style: AppTextStyles.appBarTitle),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: save to repository
            },
            child: Text(
              'Simpan',
              style: AppTextStyles.fieldLabel.copyWith(color: AppColors.ink),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.pageHorizontal,
          AppDimensions.paddingL,
          AppDimensions.pageHorizontal,
          AppDimensions.bottomNavClearance,
        ),
        children: [
          // ── Subtitle ────────────────────────────────────────────────────
          Text(
            'Kelola informasi akun dan profil pengrajin Anda',
            style: AppTextStyles.bodySmall,
          ),
          SizedBox(height: AppDimensions.paddingXL),

          // ── Avatar Section ────────────────────────────────────────────
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.inputBg,
                  child: Text(
                    _nameCtrl.text.isNotEmpty ? _nameCtrl.text[0] : 'U',
                    style: AppTextStyles.sectionTitle,
                  ),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.black,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.camera_alt, size: 14, color: AppColors.white),
                    onPressed: () {
                      // TODO: image picker
                    },
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: AppDimensions.paddingS),
              child: Text(
                'Format JPG, PNG atau WEBP. Maksimal 5 MB.',
                style: AppTextStyles.caption,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.paddingXXL),

          // ── Form Fields ───────────────────────────────────────────────
          _FormField(
            label: 'Nama Lengkap',
            hint: 'Sesuai KTP',
            controller: _nameCtrl,
          ),
          SizedBox(height: AppDimensions.paddingXL),

          _FormField(
            label: 'Username',
            hint: 'username unik',
            controller: _usernameCtrl,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Text(
                'Tersedia',
                style: AppTextStyles.caption.copyWith(color: Colors.green),
              ),
            ),
            helper:
                'Username profil dinoyocraft.id/@${_usernameCtrl.text}. Ubah 30 hari sekali.',
          ),
          SizedBox(height: AppDimensions.paddingXL),

          _FormField(
            label: 'Alamat Email',
            hint: 'email@contoh.com',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            trailingButtons: [
              _SmallActionBtn(label: 'Verif', onTap: () {}),
              SizedBox(width: AppDimensions.gapS),
              _SmallActionBtn(label: 'Ubah', onTap: () {}),
            ],
          ),
          SizedBox(height: AppDimensions.paddingXL),

          _FormField(
            label: 'Nomor WhatsApp / Seluler',
            hint: '+62 8xx-xxx-xxx',
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            trailingButtons: [
              _SmallActionBtn(label: 'Verif', onTap: () {}),
              SizedBox(width: AppDimensions.gapS),
              _SmallActionBtn(label: 'Ubah', onTap: () {}),
            ],
          ),
          SizedBox(height: AppDimensions.paddingXL),

          // ── Jenis Kelamin ──────────────────────────────────────────────
          Text('Jenis Kelamin', style: AppTextStyles.fieldLabel),
          SizedBox(height: AppDimensions.gapS),
          Row(
            children: ['Laki-laki', 'Perempuan'].map((g) {
              final selected = g == _gender;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: g == 'Laki-laki' ? AppDimensions.gapS : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _gender = g),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      height: 48,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.black : AppColors.inputBg,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusM),
                        border: Border.all(
                          color: selected
                              ? AppColors.black
                              : AppColors.border,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        g,
                        style: AppTextStyles.fieldLabel.copyWith(
                          color:
                              selected ? AppColors.white : AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: AppDimensions.paddingXL),

          // ── Tanggal Lahir ─────────────────────────────────────────────
          Text('Tanggal Lahir', style: AppTextStyles.fieldLabel),
          SizedBox(height: AppDimensions.gapS),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
              ),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatDate(_birthDate),
                      style: AppTextStyles.fieldText,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable form field ──────────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.trailing,
    this.trailingButtons,
    this.helper,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Widget? trailing;
  final List<Widget>? trailingButtons;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyles.fieldLabel),
            if (trailing != null) ...[
              SizedBox(width: AppDimensions.gapS),
              trailing!,
            ],
            if (trailingButtons != null) ...[
              Spacer(),
              ...trailingButtons!,
            ],
          ],
        ),
        SizedBox(height: AppDimensions.gapS),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.fieldText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.fieldHint,
            filled: true,
            fillColor: AppColors.inputBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: AppDimensions.paddingM,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(
                color: AppColors.ink,
                width: 1.2,
              ),
            ),
          ),
        ),
        if (helper != null) ...[
          SizedBox(height: AppDimensions.gapXS),
          Text(helper!, style: AppTextStyles.caption),
        ],
      ],
    );
  }
}

class _SmallActionBtn extends StatelessWidget {
  const _SmallActionBtn({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Text(label, style: AppTextStyles.caption),
      ),
    );
  }
}
