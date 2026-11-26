import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  Color get _destructive => AppColors.danger;
  Color get _bannerBg => AppColors.dangerSurface;
  Color get _bannerText => AppColors.dangerText;

  static const List<String> _reasons = [
    'Sudah jarang membeli keramik',
    'Ingin membuat akun baru',
    'Kekhawatiran privasi & keamanan data',
    'Lainnya',
  ];

  final Set<int> _selectedReasons = {};
  bool _confirmed = false;
  bool _obscurePassword = true;
  bool _loadingStatus = true;
  bool _submitting = false;
  bool _hasPassword = true;
  bool _hasActiveOrders = false;
  int _activeOrdersCount = 0;
  String _accountEmail = '';
  Map<String, dynamic>? _pendingRequest;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otherReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _accountEmail = AuthSession.user?['email']?.toString() ?? '';
    _hasPassword = AuthSession.user?['has_password'] != false;
    _fetchDeletionStatus();
  }

  Future<void> _fetchDeletionStatus() async {
    setState(() => _loadingStatus = true);
    try {
      final res = await ApiClient.get('/moderation/account-deletion/me');
      if (res['success'] == true && res['data'] is Map<String, dynamic>) {
        final data = res['data'] as Map<String, dynamic>;
        if (!mounted) return;
        setState(() {
          _accountEmail = data['email']?.toString() ?? _accountEmail;
          _hasPassword = data['has_password'] == true;
          _hasActiveOrders = data['has_active_orders'] == true;
          _activeOrdersCount =
              int.tryParse('${data['active_orders_count'] ?? 0}') ?? 0;
          _pendingRequest = data['pending_request'] is Map<String, dynamic>
              ? data['pending_request'] as Map<String, dynamic>
              : null;
          _loadingStatus = false;
        });
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingStatus = false);
  }

  bool get _hasValidReason {
    if (_selectedReasons.isEmpty) return false;
    if (_selectedReasons.contains(3) &&
        _selectedReasons.length == 1 &&
        _otherReasonController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  bool get _canDelete {
    if (_submitting || _hasActiveOrders || !_confirmed || !_hasValidReason) {
      return false;
    }
    final input = _passwordController.text.trim();
    if (_hasPassword) return input.isNotEmpty;
    return input.toLowerCase() == _accountEmail.trim().toLowerCase() &&
        input.isNotEmpty;
  }

  String _composeReasonText() {
    final chosen = <String>[];
    for (final idx in _selectedReasons) {
      if (idx >= 0 && idx < _reasons.length) {
        if (idx == 3 && _otherReasonController.text.trim().isNotEmpty) {
          chosen.add('Lainnya: ${_otherReasonController.text.trim()}');
        } else {
          chosen.add(_reasons[idx]);
        }
      }
    }
    return chosen.isEmpty ? 'Permintaan penghapusan akun pengguna' : chosen.join('; ');
  }

  Future<void> _confirmDelete() async {
    if (!_canDelete) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Ajukan Hapus Akun?'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Permohonan penghapusan akun Anda akan dikirim ke tim Admin DinoyoCraft untuk ditinjau. Jika disetujui, akun akan dinonaktifkan secara permanen.'
              .tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batalkan'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: _destructive,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Kirim Pengajuan'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    setState(() => _submitting = true);
    try {
      final payload = <String, dynamic>{
        'reason': _composeReasonText(),
        if (_hasPassword)
          'password': _passwordController.text
        else
          'confirm_email': _passwordController.text.trim(),
      };
      final res = await ApiClient.post('/moderation/account-deletion', payload);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.black,
          content: Text(
            res['message']?.toString() ??
                'Pengajuan penghapusan akun berhasil dikirim ke Admin.'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.white,
            ),
          ),
        ),
      );
      _passwordController.clear();
      await _fetchDeletionStatus();
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: _destructive,
          content: Text(
            msg,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.white,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _cancelPendingRequest() async {
    setState(() => _submitting = true);
    try {
      final res = await ApiClient.delete('/moderation/account-deletion/me');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.black,
          content: Text(
            res['message']?.toString() ??
                'Pengajuan penghapusan akun berhasil dibatalkan.'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.white,
            ),
          ),
        ),
      );
      await _fetchDeletionStatus();
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: _destructive,
          content: Text(
            msg,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.white,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackScope(
      fallbackRoute: '/settings',
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              SizedBox(
                height: 54,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/settings');
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 19,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Hapus Akun'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: _loadingStatus
                    ? const Center(child: CircularProgressIndicator())
                    : _pendingRequest != null
                        ? _buildPendingStatusView()
                        : _buildRequestForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingStatusView() {
    final reason = _pendingRequest?['reason']?.toString() ?? '-';
    final createdRaw = _pendingRequest?['created_at']?.toString() ?? '';
    final dt = DateTime.tryParse(createdRaw)?.toLocal();
    final dateLabel = dt != null
        ? '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
        : 'Baru saja';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderAlt),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.hourglass_top_rounded,
                      color: Color(0xFFD97706),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menunggu Peninjauan Admin'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Diajukan pada $dateLabel',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 14),
              Text(
                'Alasan yang diajukan:'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                reason,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  height: 1.5,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Tim Admin DinoyoCraft sedang meninjau permohonan penghapusan akun Anda. Selama belum diproses, Anda masih dapat membatalkan pengajuan ini.'
                    .tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  height: 1.55,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _submitting ? null : _cancelPendingRequest,
                  icon: const Icon(Icons.undo_rounded, size: 18),
                  label: Text(
                    _submitting
                        ? 'Memproses...'.tr
                        : 'Batalkan Pengajuan Hapus Akun'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    side: BorderSide(color: AppColors.ink),
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestForm() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 30),
      children: [
        _buildWarningBanner(),
        if (_hasActiveOrders) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  size: 20,
                  color: Color(0xFFB45309),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Anda masih memiliki $_activeOrdersCount pesanan aktif yang sedang berjalan. Selesaikan atau batalkan pesanan tersebut terlebih dahulu sebelum mengajukan penghapusan akun.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.5,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        Text(
          'Pilih alasan penghapusan akun'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Masukan kamu sangat berharga untuk kemajuan perajin keramik lokal Dinoyo.'
              .tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        for (final (i, reason) in _reasons.indexed) _buildReasonCard(i, reason),
        if (_selectedReasons.contains(3)) ...[
          const SizedBox(height: 6),
          TextField(
            controller: _otherReasonController,
            maxLines: 2,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: AppColors.ink,
            ),
            decoration: InputDecoration(
              hintText: 'Tuliskan alasan lainnya...'.tr,
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderAlt),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderAlt),
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        _buildConfirmationCard(),
        const SizedBox(height: 20),
        Text(
          _hasPassword
              ? 'Masukkan Kata Sandi untuk Konfirmasi'.tr
              : 'Ketik Email Akun untuk Konfirmasi'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: _hasPassword ? _obscurePassword : false,
          keyboardType: _hasPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          onChanged: (_) => setState(() {}),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.ink,
          ),
          decoration: InputDecoration(
            hintText: _hasPassword
                ? 'Masukkan kata sandi akunmu'.tr
                : (_accountEmail.isNotEmpty
                    ? _accountEmail
                    : 'Ketik alamat email akun Google Anda'),
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
            prefixIcon: Icon(
              _hasPassword
                  ? Icons.lock_outline_rounded
                  : Icons.mail_outline_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            suffixIcon: _hasPassword
                ? IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
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
        ),
        const SizedBox(height: 6),
        Text(
          _hasPassword
              ? 'Verifikasi keamanan untuk memastikan ini benar-benar pemilik akun.'
                  .tr
              : 'Akun Anda login melalui Google. Ketik persis alamat email ($_accountEmail) untuk konfirmasi keamanan.'
                  .tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton.icon(
            onPressed: _canDelete ? _confirmDelete : null,
            icon: _submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: AppColors.white,
                  ),
            label: Text(
              _submitting
                  ? 'Mengirim Pengajuan...'.tr
                  : 'Ajukan Penghapusan Akun'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: _destructive,
              disabledBackgroundColor: _destructive.withValues(alpha: 0.4),
              shape: const StadiumBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bannerBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 26,
                color: _bannerText,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Apakah kamu yakin ingin menghapus akun?'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _bannerText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(text: 'Tindakan ini bersifat '.tr),
                TextSpan(
                  text: 'permanen setelah disetujui Admin'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextSpan(
                  text:
                      '. Seluruh akses akun, data profil, serta riwayat belanja DinoyoCraft kamu akan dinonaktifkan.'
                          .tr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonCard(int index, String reason) {
    final selected = _selectedReasons.contains(index);

    return InkWell(
      onTap: () => setState(() {
        selected ? _selectedReasons.remove(index) : _selectedReasons.add(index);
      }),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.ink : AppColors.borderAlt,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 18,
              color: selected ? AppColors.ink : AppColors.textMuted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                reason.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationCard() {
    return InkWell(
      onTap: () => setState(() => _confirmed = !_confirmed),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _confirmed ? AppColors.ink : AppColors.borderAlt,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _confirmed ? AppColors.ink : AppColors.surface,
                border: Border.all(
                  color: _confirmed ? AppColors.ink : AppColors.textMuted,
                  width: 1.4,
                ),
              ),
              child: _confirmed
                  ? Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: AppColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Saya mengerti konsekuensi penghapusan akun DinoyoCraft ini dan menyatakan bahwa keputusan ini bersifat final.'
                    .tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  height: 1.55,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
