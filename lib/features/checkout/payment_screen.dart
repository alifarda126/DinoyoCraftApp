import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/dc_bottom_nav.dart';
import '../../data/mock_data.dart';
import '../profile/profile_screen.dart';

/// Argumen data transaksi untuk Halaman Pembayaran.
class PaymentArgs {
  const PaymentArgs({
    required this.orderId,
    required this.items,
    required this.qtys,
    required this.subtotal,
    required this.shippingFee,
    required this.serviceFee,
    required this.total,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.recipientName,
    required this.recipientPhone,
    required this.recipientAddress,
    this.note,
  });

  final String orderId;
  final List<CartItem> items;
  final List<int> qtys;
  final int subtotal;
  final int shippingFee;
  final int serviceFee;
  final int total;
  final String paymentMethod; // 'QRIS', 'VA', 'E-Wallet'
  final String shippingMethod;
  final String recipientName;
  final String recipientPhone;
  final String recipientAddress;
  final String? note;

  /// Fallback bawaan jika dibuka tanpa argumen dari router.
  factory PaymentArgs.fallback() {
    final now = DateTime.now();
    final items = MockData.mockCart;
    final qtys = items.map((e) => e.qty).toList();
    int subtotal = 0;
    for (var i = 0; i < items.length; i++) {
      subtotal += items[i].product.price * qtys[i];
    }
    const shippingFee = 15000;
    const serviceFee = 2000;
    return PaymentArgs(
      orderId:
          'DC-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${1000 + (now.millisecondsSinceEpoch % 9000)}',
      items: items,
      qtys: qtys,
      subtotal: subtotal,
      shippingFee: shippingFee,
      serviceFee: serviceFee,
      total: subtotal + shippingFee + serviceFee,
      paymentMethod: 'QRIS',
      shippingMethod: 'Regular',
      recipientName: 'Customer',
      recipientPhone: '0859-777-588-138',
      recipientAddress:
          'Jl. Sawiji Sari No.14, Kel. Mulyorejo, Kec. Sukun, Kota Malang, Jawa Timur 65147',
    );
  }
}

/// Tampilan Lanjutan Checkout — Halaman Pembayaran (Saat Pembayaran).
/// Menampilkan hitung mundur batas pembayaran, kode QRIS / nomor VA / E-wallet,
/// petunjuk transfer, rincian pesanan, dan verifikasi status pembayaran.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, this.args});

  final PaymentArgs? args;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final PaymentArgs _data;
  late String _currentMethod; // 'QRIS', 'VA', 'E-Wallet'
  String _selectedVaBank = 'BCA';
  String _selectedVaTab = 'm-Banking';
  String _selectedEWallet = 'GoPay';
  bool _isDetailsExpanded = false;

  // Hitung mundur batas waktu pembayaran (24 jam)
  static const int _initialCountdownSeconds = 24 * 3600 - 15; // ~23:59:45
  late int _remainingSeconds;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _data = widget.args ?? PaymentArgs.fallback();
    _currentMethod = _data.paymentMethod;
    _remainingSeconds = _initialCountdownSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedCountdown {
    final hours = (_remainingSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes =
        ((_remainingSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$hours : $minutes : $seconds';
  }

  String get _deadlineText {
    final target = DateTime.now().add(Duration(seconds: _remainingSeconds));
    const dayNames = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final dayStr = dayNames[target.weekday - 1];
    final monthStr = monthNames[target.month - 1];
    final hourStr = target.hour.toString().padLeft(2, '0');
    final minStr = target.minute.toString().padLeft(2, '0');
    return '$dayStr, ${target.day} $monthStr ${target.year}, $hourStr:$minStr WIB';
  }

  void _copyToClipboard(String text, String successMsg) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.black,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                successMsg,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onBackPressed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Batalkan Pembayaran?'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Pesanan Anda tetap tersimpan dan dapat dilanjutkan pembayarannya sebelum batas waktu berakhir melalui menu Riwayat Pesanan.'
              .tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Lanjut Bayar'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: Text(
              'Bayar Nanti'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      ProfileScreen.selectedTabNotifier.value = 'Belum Bayar';
      context.go('/profile?tab=Belum Bayar');
    }
  }

  Future<void> _checkPaymentStatus() async {
    // Tampilkan loading modal simulasi verifikasi pembayaran
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Memverifikasi Pembayaran...'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Menghubungkan ke gateway pembayaran'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(); // Tutup loading

    // Tampilkan Modal Pembayaran Berhasil
    _showPaymentSuccessDialog();
  }

  void _showPaymentSuccessDialog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetCtx) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.borderAlt,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Icon Sukses Animatif
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.isDark
                        ? const Color(0x334ADE80)
                        : const Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.isDark
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFF22C55E),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 44,
                      color: AppColors.isDark
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFF16A34A),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Text(
                  'Pembayaran Berhasil!'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Terima kasih! Pesanan Anda telah diverifikasi otomatis dan diteruskan ke pengrajin untuk segera dikemas.'
                      .tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Card Rincian Bukti Transaksi
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderAlt),
                  ),
                  child: Column(
                    children: [
                      _buildReceiptRow(
                        'Total Dibayar'.tr,
                        MockData.formatPrice(_data.total),
                        isBold: true,
                        valueColor: AppColors.ink,
                      ),
                      const SizedBox(height: 10),
                      _buildReceiptRow(
                        'No. Pesanan'.tr,
                        _data.orderId,
                      ),
                      const SizedBox(height: 8),
                      _buildReceiptRow(
                        'Metode Pembayaran'.tr,
                        _currentMethod == 'QRIS'
                            ? 'QRIS Instant'
                            : _currentMethod == 'VA'
                                ? 'Virtual Account ($_selectedVaBank)'
                                : 'E-Wallet ($_selectedEWallet)',
                      ),
                      const SizedBox(height: 8),
                      _buildReceiptRow(
                        'Status Pesanan'.tr,
                        'Dikemas Penjual'.tr,
                        valueColor: const Color(0xFFD97706),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Aksi: Lihat Status Pesanan
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(sheetCtx);
                      context.go('/profile');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'Lihat Status Pesanan'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Tombol Kembali ke Beranda
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(sheetCtx);
                      context.go('/home');
                    },
                    child: Text(
                      'Kembali ke Beranda'.tr,
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
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
            color: valueColor ?? AppColors.ink,
          ),
        ),
      ],
    );
  }

  // ═══ Header AppBar ════════════════════════════════════════════════════════
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      leading: IconButton(
        onPressed: _onBackPressed,
        icon: SvgPicture.asset(
          AppAssets.iconBack,
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
        ),
      ),
      title: Text(
        'Pembayaran'.tr,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.push('/help'),
          icon: Icon(
            Icons.help_outline_rounded,
            size: 22,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: AppColors.border),
      ),
    );
  }

  // ═══ 1. Banner Batas Waktu Pembayaran (Countdown) ═════════════════════════
  Widget _buildCountdownCard() {
    final isDark = AppColors.isDark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF261E0A) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF594514) : const Color(0xFFFDE68A),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF452F04)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFFB45309)
                        : const Color(0xFFF59E0B),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD97706),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Menunggu Pembayaran'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.access_time_filled_rounded,
                size: 20,
                color: const Color(0xFFD97706),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Selesaikan pembayaran dalam'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formattedCountdown,
            style: GoogleFonts.robotoMono(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Batas akhir: $_deadlineText'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ═══ 2. Card Nominal Tagihan & Order ID ══════════════════════════════════
  Widget _buildTotalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Pembayaran'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    MockData.formatPrice(_data.total),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => _copyToClipboard(
                  _data.total.toString(),
                  'Nominal total pembayaran disalin!'.tr,
                ),
                icon: const Icon(Icons.copy_rounded, size: 14),
                label: Text(
                  'Salin'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.ink,
                  side: BorderSide(color: AppColors.borderAlt),
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: const Size(0, 32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: AppColors.border),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'No. Pesanan'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    _data.orderId,
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => _copyToClipboard(
                      _data.orderId,
                      'Nomor pesanan disalin!'.tr,
                    ),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
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

  // ═══ 3. Selector Metode Pembayaran (Bisa diubah jika diinginkan) ═════════
  Widget _buildPaymentMethodTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PILIHAN METODE PEMBAYARAN'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildMethodPill(
                title: 'QRIS Instant',
                icon: Icons.qr_code_scanner_rounded,
                method: 'QRIS',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMethodPill(
                title: 'Virtual Account',
                icon: Icons.account_balance_rounded,
                method: 'VA',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMethodPill(
                title: 'E-Wallet',
                icon: Icons.smartphone_rounded,
                method: 'E-Wallet',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodPill({
    required String title,
    required IconData icon,
    required String method,
  }) {
    final isSelected = _currentMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _currentMethod = method),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.ink,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBankAsset(String bank) {
    switch (bank) {
      case 'BCA':
        return AppAssets.paymentBca;
      case 'Mandiri':
        return AppAssets.paymentMandiri;
      case 'BRI':
        return AppAssets.paymentBri;
      case 'BNI':
      default:
        return AppAssets.paymentBni;
    }
  }

  Widget _buildEWalletLogo(String wallet, {double height = 12}) {
    switch (wallet) {
      case 'GoPay':
        return SvgPicture.asset(AppAssets.paymentGopay,
            height: height * 0.9, fit: BoxFit.contain);
      case 'OVO':
        return SvgPicture.asset(AppAssets.paymentOvo,
            height: height, width: height, fit: BoxFit.contain);
      case 'ShopeePay':
        return SvgPicture.asset(AppAssets.paymentShopeepay,
            height: height, fit: BoxFit.contain);
      case 'DANA':
      default:
        return SvgPicture.asset(AppAssets.paymentDana,
            height: height * 0.9, fit: BoxFit.contain);
    }
  }

  // ═══ 4A. Tampilan Pembayaran QRIS ═════════════════════════════════════════
  Widget _buildQrisSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header QRIS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 24,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.paymentQris,
                      height: 14,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pembayaran Nasional',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderAlt),
                ),
                child: Text(
                  'GPN / QRIS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Merchant & NMID Info
          Text(
            'DinoyoCraft Official Store',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'NMID: ID1020261031988 • Sentra Dinoyo Malang',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Tampilan QR Code Bersih & Realistis
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: _QrisCodePainter(
                  seed: _data.orderId.hashCode ^ _data.total,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          Text(
            'Pindai QR menggunakan aplikasi m-Banking atau e-Wallet apapun (BCA, Mandiri, BRI, GoPay, OVO, ShopeePay, DANA)'
                .tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Tombol Aksi QRIS
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: Row(
                          children: [
                            const Icon(Icons.download_done_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Kode QR berhasil disimpan ke galeri perangkat!'
                                    .tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: Text(
                    'Simpan QR'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    side: BorderSide(color: AppColors.borderAlt),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showQuickAppsSheet,
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: Text(
                    'Buka Aplikasi'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    side: BorderSide(color: AppColors.borderAlt),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showQuickAppsSheet() {
    final apps = [
      {'name': 'GoPay', 'type': 'E-Wallet', 'icon': AppAssets.paymentGopay},
      {'name': 'BCA Mobile', 'type': 'm-Banking', 'icon': AppAssets.paymentBca},
      {'name': 'Livin\' by Mandiri', 'type': 'm-Banking', 'icon': AppAssets.paymentMandiri},
      {'name': 'BRImo', 'type': 'm-Banking', 'icon': AppAssets.paymentBri},
      {'name': 'BNI Mobile', 'type': 'm-Banking', 'icon': AppAssets.paymentBni},
      {'name': 'OVO', 'type': 'E-Wallet', 'icon': AppAssets.paymentOvo},
      {'name': 'ShopeePay', 'type': 'E-Wallet', 'icon': AppAssets.paymentShopeepay},
      {'name': 'DANA', 'type': 'E-Wallet', 'icon': AppAssets.paymentDana},
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                  'Buka Aplikasi Pembayaran'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilih aplikasi untuk menyelesaikan transaksi pembayaran QRIS'
                      .tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                for (final app in apps) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          app['icon']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    title: Text(
                      app['name']!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    subtitle: Text(
                      app['type']!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14),
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Membuka ${app['name']} (Simulasi aplikasi terpasang)...'
                                .tr,
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, color: AppColors.borderAlt),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══ 4B. Tampilan Pembayaran Virtual Account (VA) ═════════════════════════
  Widget _buildVaSection() {
    final banks = ['BCA', 'Mandiri', 'BRI', 'BNI'];
    final vaNumbers = {
      'BCA': '8277 0859 7775 8813',
      'Mandiri': '8808 0859 7775 8813',
      'BRI': '1280 0859 7775 8813',
      'BNI': '9881 0859 7775 8813',
    };
    final currentVa = vaNumbers[_selectedVaBank] ?? '8277 0859 7775 8813';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PILIH BANK VIRTUAL ACCOUNT'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final bank in banks) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: OutlinedButton(
                      onPressed: () => setState(() => _selectedVaBank = bank),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _selectedVaBank == bank
                            ? AppColors.black
                            : AppColors.surface,
                        foregroundColor: _selectedVaBank == bank
                            ? Colors.white
                            : AppColors.ink,
                        side: BorderSide(
                          color: _selectedVaBank == bank
                              ? AppColors.black
                              : AppColors.border,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 18,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: SvgPicture.asset(
                              _getBankAsset(bank),
                              height: 11,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bank,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 18),

          // Nomor VA Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderAlt),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: const Color(0xFFE2E8F0)),
                          ),
                          child: SvgPicture.asset(
                            _getBankAsset(_selectedVaBank),
                            height: 12,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'No. Virtual Account $_selectedVaBank',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Verifikasi Otomatis'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        currentVa,
                        style: GoogleFonts.robotoMono(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _copyToClipboard(
                        currentVa.replaceAll(' ', ''),
                        'Nomor VA $_selectedVaBank berhasil disalin!'.tr,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: const Size(0, 32),
                      ),
                      child: Text(
                        'Salin'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Nama Rekening: DinoyoCraft - ${_data.recipientName}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab Petunjuk Transfer
          Row(
            children: [
              for (final tab in ['m-Banking', 'ATM', 'i-Banking']) ...[
                GestureDetector(
                  onTap: () => setState(() => _selectedVaTab = tab),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedVaTab == tab
                          ? AppColors.ink
                          : AppColors.inputBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tab,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _selectedVaTab == tab
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Instruksi Langkah
          _buildVaInstructions(_selectedVaBank, _selectedVaTab),
        ],
      ),
    );
  }

  Widget _buildVaInstructions(String bank, String channel) {
    List<String> steps;
    if (channel == 'ATM') {
      steps = [
        'Masukkan kartu ATM $bank dan PIN Anda.',
        'Pilih menu Transaksi Lainnya > Transfer > ke Rekening $bank Virtual Account.',
        'Masukkan nomor Virtual Account $bank di atas lalu tekan Benar.',
        'Periksa nama tagihan DinoyoCraft dan total nominal, lalu konfirmasi pembayaran.',
      ];
    } else if (channel == 'i-Banking') {
      steps = [
        'Login ke akun Internet Banking $bank Anda.',
        'Pilih menu Pembayaran / Transfer > Virtual Account.',
        'Masukkan nomor Virtual Account $bank Anda.',
        'Periksa rincian pembayaran DinoyoCraft lalu masukkan kode otentikasi / token.',
      ];
    } else {
      steps = [
        'Buka aplikasi mobile banking $bank Anda.',
        'Pilih menu Transfer atau Pembayaran > Virtual Account.',
        'Masukkan nomor Virtual Account di atas.',
        'Pastikan nama merchant DinoyoCraft dan nominal tagihan sesuai.',
        'Masukkan PIN m-Banking Anda untuk menyelesaikan pembayaran.',
      ];
    }

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 2, right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderAlt),
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    steps[i].tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.45,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ═══ 4C. Tampilan Pembayaran E-Wallet ══════════════════════════════════════
  Widget _buildEWalletSection() {
    final wallets = ['GoPay', 'OVO', 'ShopeePay', 'DANA'];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PILIH DOMPET DIGITAL (E-WALLET)'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final w in wallets) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: OutlinedButton(
                      onPressed: () => setState(() => _selectedEWallet = w),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _selectedEWallet == w
                            ? AppColors.black
                            : AppColors.surface,
                        foregroundColor: _selectedEWallet == w
                            ? Colors.white
                            : AppColors.ink,
                        side: BorderSide(
                          color: _selectedEWallet == w
                              ? AppColors.black
                              : AppColors.border,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 18,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: _buildEWalletLogo(w, height: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            w,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderAlt),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: const Color(0xFFE2E8F0)),
                          ),
                          child:
                              _buildEWalletLogo(_selectedEWallet, height: 12),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nomor Ponsel Akun $_selectedEWallet',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Instan'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _data.recipientPhone,
                      style: GoogleFonts.robotoMono(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              'Notifikasi pembayaran $_selectedEWallet telah dikirim ke ponsel Anda.'
                                  .tr,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.ink,
                        side: BorderSide(color: AppColors.borderAlt),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        minimumSize: const Size(0, 30),
                      ),
                      child: Text(
                        'Kirim Notif'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Text(
            'Buka aplikasi $_selectedEWallet di ponsel Anda dan konfirmasikan pembayaran sebelum batas waktu berakhir.'
                .tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ═══ 5. Rincian Pesanan (Collapsible Dropdown) ═════════════════════════════
  Widget _buildOrderDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header Expandable
          InkWell(
            onTap: () => setState(
              () => _isDetailsExpanded = !_isDetailsExpanded,
            ),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 20,
                    color: AppColors.ink,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Rincian Pesanan (${_data.items.length} Barang)'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  Icon(
                    _isDetailsExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // Isi yang di-expand
          if (_isDetailsExpanded) ...[
            Divider(height: 1, thickness: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daftar Produk
                  for (var i = 0; i < _data.items.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            _data.items[i].product.image,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _data.items[i].product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_data.qtys[i]}x • ${_data.items[i].variant ?? 'Standard'}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          MockData.formatPrice(
                            _data.items[i].product.price * _data.qtys[i],
                          ),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 14),
                  Divider(height: 1, thickness: 1, color: AppColors.border),
                  const SizedBox(height: 12),

                  // Detail Penerima & Ongkir
                  Text(
                    'Penerima: ${_data.recipientName} (${_data.recipientPhone})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _data.recipientAddress,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pengiriman: ${_data.shippingMethod}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Divider(height: 1, thickness: 1, color: AppColors.border),
                  const SizedBox(height: 10),

                  // Rincian Biaya
                  _buildCostRow('Subtotal Produk'.tr, _data.subtotal),
                  const SizedBox(height: 4),
                  _buildCostRow('Biaya Pengiriman'.tr, _data.shippingFee),
                  const SizedBox(height: 4),
                  _buildCostRow('Biaya Layanan'.tr, _data.serviceFee),
                  const SizedBox(height: 8),
                  _buildCostRow(
                    'Total Pembayaran'.tr,
                    _data.total,
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, int amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isTotal ? 13 : 11,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.ink : AppColors.textSecondary,
          ),
        ),
        Text(
          MockData.formatPrice(amount),
          style: GoogleFonts.plusJakartaSans(
            fontSize: isTotal ? 14 : 11,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? AppColors.ink : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ═══ 6. Sticky Bottom Action Bar ══════════════════════════════════════════
  Widget _buildBottomBar() {
    final bottomPad = DcBottomNav.getBottomPadding(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPad),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _checkPaymentStatus,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Cek Status Pembayaran'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: TextButton(
                  onPressed: _onBackPressed,
                  child: Text(
                    'Bayar Nanti'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
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

  // ═══ BUILD UTAMA ═════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return AppBackScope(
      onBack: _onBackPressed,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                children: [
                  _buildCountdownCard(),
                  const SizedBox(height: 12),
                  _buildTotalCard(),
                  const SizedBox(height: 16),
                  _buildPaymentMethodTabs(),
                  const SizedBox(height: 12),

                  // Tampilan Spesifik Sesuai Metode
                  if (_currentMethod == 'QRIS') ...[
                    _buildQrisSection(),
                  ] else if (_currentMethod == 'VA') ...[
                    _buildVaSection(),
                  ] else ...[
                    _buildEWalletSection(),
                  ],

                  const SizedBox(height: 14),
                  _buildOrderDetailsCard(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }
}

/// CustomPainter untuk menggambar QR Code QRIS yang tajam dan otentik.
class _QrisCodePainter extends CustomPainter {
  _QrisCodePainter({required this.seed});

  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final blackPaint = Paint()
      ..color = const Color(0xFF111827)
      ..style = PaintingStyle.fill;

    const moduleCount = 29;
    final moduleSize = size.width / moduleCount;

    // Helper draw square module
    void drawModule(int r, int c) {
      canvas.drawRect(
        Rect.fromLTWH(
          c * moduleSize,
          r * moduleSize,
          moduleSize,
          moduleSize,
        ),
        blackPaint,
      );
    }

    // Helper draw Finder Pattern (tiga sudut: 7x7)
    void drawFinderPattern(int startR, int startC) {
      for (var r = 0; r < 7; r++) {
        for (var c = 0; c < 7; c++) {
          final isOuterBorder = r == 0 || r == 6 || c == 0 || c == 6;
          final isInnerCenter = (r >= 2 && r <= 4) && (c >= 2 && c <= 4);
          if (isOuterBorder || isInnerCenter) {
            drawModule(startR + r, startC + c);
          }
        }
      }
    }

    // 1. Finder patterns at 3 corners
    drawFinderPattern(0, 0); // Top-Left
    drawFinderPattern(0, moduleCount - 7); // Top-Right
    drawFinderPattern(moduleCount - 7, 0); // Bottom-Left

    // 2. Alignment pattern (5x5) near bottom right
    const alignR = moduleCount - 9;
    const alignC = moduleCount - 9;
    for (var r = 0; r < 5; r++) {
      for (var c = 0; c < 5; c++) {
        final isBorder = r == 0 || r == 4 || c == 0 || c == 4;
        final isCenter = r == 2 && c == 2;
        if (isBorder || isCenter) {
          drawModule(alignR + r, alignC + c);
        }
      }
    }

    // 3. Timing patterns
    for (var i = 8; i < moduleCount - 8; i++) {
      if (i % 2 == 0) {
        drawModule(6, i); // Horizontal
        drawModule(i, 6); // Vertical
      }
    }

    // 4. Data Modules deterministik berbasis seed
    final rnd = Random(seed);
    for (var r = 0; r < moduleCount; r++) {
      for (var c = 0; c < moduleCount; c++) {
        // Skip finder patterns + margins
        final inTL = r < 8 && c < 8;
        final inTR = r < 8 && c >= moduleCount - 8;
        final inBL = r >= moduleCount - 8 && c < 8;
        final inAlign = (r >= alignR - 1 && r <= alignR + 5) &&
            (c >= alignC - 1 && c <= alignC + 5);
        final inCenter = (r >= 11 && r <= 17) && (c >= 11 && c <= 17);
        final inTiming = r == 6 || c == 6;

        if (inTL || inTR || inBL || inAlign || inCenter || inTiming) {
          continue;
        }

        // Probabilitas modul hitam
        if (rnd.nextBool()) {
          drawModule(r, c);
        }
      }
    }

    // 5. Logo DinoyoCraft di tengah QR
    final centerRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: moduleSize * 7,
      height: moduleSize * 7,
    );
    final badgeRRect = RRect.fromRectAndRadius(
      centerRect,
      const Radius.circular(8),
    );

    // Background badge putih & shadow
    canvas.drawRRect(badgeRRect, Paint()..color = Colors.white);
    canvas.drawRRect(
      badgeRRect,
      Paint()
        ..color = const Color(0xFFE5E7EB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Inner icon badge hitam
    final innerCenter = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: moduleSize * 4.6,
      height: moduleSize * 4.6,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(innerCenter, const Radius.circular(6)),
      Paint()..color = const Color(0xFF1E293B),
    );

    // Huruf "D" khas DinoyoCraft di tengah
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'DC',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          fontFamily: 'Roboto',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _QrisCodePainter oldDelegate) =>
      oldDelegate.seed != seed;
}

