import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_session.dart';
import '../../core/services/pusher_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/dc_bottom_nav.dart';
import '../../core/widgets/dc_cached_image.dart';
import '../../data/mock_data.dart';
import '../payment/data/datasources/payment_remote_datasource.dart';
import '../payment/data/models/payment_model.dart';
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
    this.backendMethod,
    this.expiryTime,
    this.orderCreatedAt,
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
  final String? backendMethod; // 'qris', 'bca_va', 'mandiri_bill', 'bri_va', 'bni_va', 'permata_va', 'gopay', 'shopeepay'
  final String? expiryTime;
  final String? orderCreatedAt;

  static String groupFromBackendMethod(String? code) {
    final c = (code ?? '').toLowerCase();
    if (c == 'bca_va' ||
        c == 'bni_va' ||
        c == 'bri_va' ||
        c == 'permata_va' ||
        c == 'mandiri_bill') {
      return 'VA';
    }
    if (c == 'gopay' || c == 'shopeepay') {
      return 'E-Wallet';
    }
    return 'QRIS';
  }

  static String bankFromBackendMethod(String? code) {
    switch ((code ?? '').toLowerCase()) {
      case 'mandiri_bill':
        return 'Mandiri';
      case 'bri_va':
        return 'BRI';
      case 'bni_va':
        return 'BNI';
      case 'permata_va':
        return 'Permata';
      case 'bca_va':
      default:
        return 'BCA';
    }
  }

  static String walletFromBackendMethod(String? code) {
    switch ((code ?? '').toLowerCase()) {
      case 'shopeepay':
        return 'ShopeePay';
      case 'gopay':
      default:
        return 'GoPay';
    }
  }

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
      backendMethod: 'qris',
    );
  }
}

/// Tampilan Lanjutan Checkout — Halaman Pembayaran (Saat Pembayaran).
/// Menampilkan hitung mundur batas pembayaran, kode QRIS / nomor VA / E-wallet
/// Midtrans Sandbox, petunjuk transfer, rincian pesanan, dan verifikasi status.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, this.args});

  final PaymentArgs? args;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with WidgetsBindingObserver {
  late final PaymentArgs _data;
  late String _currentMethod; // 'QRIS', 'VA', 'E-Wallet'
  String _selectedVaBank = 'BCA';
  String _selectedVaTab = 'm-Banking';
  String _selectedEWallet = 'GoPay';
  bool _isDetailsExpanded = false;

  // ── Pembayaran REAL via backend (Midtrans Core API Sandbox) ─────────────────
  final PaymentRemoteDatasourceImpl _paymentDs = PaymentRemoteDatasourceImpl();
  PaymentModel? _paymentInfo;
  bool _payLoading = false;
  String? _payError;
  Timer? _statusPollTimer;
  StreamSubscription<Map<String, dynamic>>? _orderEventSub;
  bool _paidNotified = false;
  bool _isTerminalState = false;
  String _terminalStatus = '';

  String get _activeBackendMethod {
    if (_currentMethod == 'VA') {
      switch (_selectedVaBank) {
        case 'Mandiri':
          return 'mandiri_bill';
        case 'BRI':
          return 'bri_va';
        case 'BNI':
          return 'bni_va';
        case 'Permata':
          return 'permata_va';
        case 'BCA':
        default:
          return 'bca_va';
      }
    }
    if (_currentMethod == 'E-Wallet') {
      return _selectedEWallet == 'ShopeePay' ? 'shopeepay' : 'gopay';
    }
    return 'qris';
  }

  /// Nominal yang HARUS dibayar — prioritas nilai resmi dari backend
  /// (sudah termasuk service fee), fallback ke hitungan lokal.
  int get _totalToPay {
    final tp = _paymentInfo?.totalPay ?? 0;
    if (tp > 0) return tp.round();
    return _data.total;
  }

  /// URL gambar QR asli dari Midtrans Core API bila tersedia.
  String? get _qrImageUrl {
    final direct = _paymentInfo?.qrImageUrl;
    if (direct != null &&
        (direct.startsWith('http://') || direct.startsWith('https://'))) {
      return direct;
    }
    final qr = _paymentInfo?.qrString;
    if (qr != null && (qr.startsWith('http://') || qr.startsWith('https://'))) {
      return qr;
    }
    return null;
  }

  bool get _isRealOrder => (int.tryParse(_data.orderId) ?? 0) > 0;

  void _syncSelectionFromBackendMethod(String? backendCode) {
    if (backendCode == null || backendCode.isEmpty) return;
    _currentMethod = PaymentArgs.groupFromBackendMethod(backendCode);
    if (_currentMethod == 'VA') {
      _selectedVaBank = PaymentArgs.bankFromBackendMethod(backendCode);
    } else if (_currentMethod == 'E-Wallet') {
      _selectedEWallet = PaymentArgs.walletFromBackendMethod(backendCode);
    }
  }

  Future<void> _initRealPayment() async {
    final orderId = int.tryParse(_data.orderId);
    if (orderId == null || orderId <= 0) {
      // Dibuka tanpa pesanan real (mode pratinjau UI).
      return;
    }
    final requestedMethod = _activeBackendMethod;
    setState(() {
      _payLoading = true;
      _payError = null;
    });
    try {
      final info = await _paymentDs.createOrderPayment(
        orderId: orderId,
        paymentMethod: requestedMethod,
      );
      if (!mounted) return;
      setState(() {
        _paymentInfo = info;
        _payLoading = false;
        _syncSelectionFromBackendMethod(info.paymentMethod);
        _syncCountdownFromPayment(info);
      });

      if (info.isPaid) {
        _handlePaidConfirmed();
      } else if (info.isTerminal) {
        _handleTerminalStatus(info.status);
      } else {
        _startStatusPolling(orderId);
      }
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      try {
        final st = await _paymentDs.checkPaymentStatus(orderId);
        if (!mounted) return;
        final payStatus = st['payment_status']?.toString() ?? '';
        final orderStatus = st['order_status']?.toString() ?? '';
        final stExpiry = st['expiry_time']?.toString();
        if (payStatus == 'paid' ||
            orderStatus == 'paid' ||
            orderStatus == 'packed' ||
            orderStatus == 'shipped' ||
            orderStatus == 'completed') {
          setState(() {
            _payLoading = false;
            _payError = null;
          });
          _handlePaidConfirmed();
          return;
        }
        if (payStatus == 'expired' ||
            payStatus == 'cancelled' ||
            orderStatus == 'cancelled') {
          setState(() {
            _payLoading = false;
            _payError = null;
          });
          _handleTerminalStatus(
            payStatus.isNotEmpty ? payStatus : orderStatus,
          );
          return;
        }
        if (stExpiry != null && stExpiry.isNotEmpty) {
          final parsed = DateTime.tryParse(stExpiry)?.toLocal();
          if (parsed != null) {
            final diff = parsed.difference(DateTime.now()).inSeconds;
            _remainingSeconds = diff > 0 ? diff : 0;
          }
        }
      } catch (_) {
        if (msg.toLowerCase().contains('sudah dibayar')) {
          setState(() {
            _payLoading = false;
            _payError = null;
          });
          _handlePaidConfirmed();
          return;
        }
      }
      if (!mounted) return;
      setState(() {
        _payError = msg;
        _payLoading = false;
      });
    }
  }

  void _syncCountdownFromPayment(PaymentModel info) {
    final exp = info.expiryDateTime;
    if (exp == null) return;
    final diff = exp.difference(DateTime.now()).inSeconds;
    if (diff <= 0) {
      _remainingSeconds = 0;
      _isTerminalState = true;
      _terminalStatus = 'expired';
      _countdownTimer?.cancel();
    } else {
      _remainingSeconds = diff;
    }
  }

  void _startStatusPolling(int orderId) {
    _statusPollTimer?.cancel();
    _statusPollTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final status = await _paymentDs.checkPaymentStatus(orderId);
        final payStatus = status['payment_status']?.toString() ??
            status['order_status']?.toString() ??
            'pending';
        if ((payStatus == 'paid' || payStatus == 'success') && !_paidNotified) {
          timer.cancel();
          if (mounted) _handlePaidConfirmed();
        } else if ((payStatus == 'expired' ||
                payStatus == 'cancelled' ||
                payStatus == 'failed') &&
            !_isTerminalState) {
          timer.cancel();
          if (mounted) _handleTerminalStatus(payStatus);
        }
      } catch (_) {
        // Polling gagal sementara — coba lagi di tick berikutnya.
      }
    });
  }

  void _handlePaidConfirmed() {
    if (_paidNotified) return;
    _paidNotified = true;
    _statusPollTimer?.cancel();
    _countdownTimer?.cancel();
    ProfileScreen.refreshNotifier.value++;
    _showPaidSuccess();
  }

  void _handleTerminalStatus(String status) {
    _statusPollTimer?.cancel();
    _countdownTimer?.cancel();
    ProfileScreen.refreshNotifier.value++;
    setState(() {
      _isTerminalState = true;
      _terminalStatus = status;
      if (status == 'expired') {
        _remainingSeconds = 0;
      }
    });
  }

  void _initRealtimeListener() {
    final uid = AuthSession.user?['id']?.toString() ?? '';
    if (uid.isNotEmpty) {
      PusherService.instance.subscribeToUserOrders(uid);
    }
    _orderEventSub = PusherService.instance.orderEventStream.listen((event) {
      if (!mounted) return;
      final eventOrderId = event['order_id']?.toString();
      if (eventOrderId != null && eventOrderId != _data.orderId) return;
      final evName = event['event']?.toString();
      final status = event['status']?.toString() ?? '';
      if (evName == 'order-paid' || status == 'paid' || status == 'success') {
        _handlePaidConfirmed();
      } else if (status == 'cancelled' ||
          status == 'expired' ||
          status == 'failed') {
        _handleTerminalStatus(status);
      }
    });
  }

  void _showPaidSuccess() {
    _statusPollTimer?.cancel();
    _countdownTimer?.cancel();
    _showPaymentSuccessDialog();
  }

  // Hitung mundur batas waktu pembayaran (default 24 jam, disinkronkan dengan expiry_time BE)
  static const int _initialCountdownSeconds = 24 * 3600;
  late int _remainingSeconds;
  Timer? _countdownTimer;

  static int _parseInitialRemainingSeconds(
    String? expiryTime,
    String? orderCreatedAt,
  ) {
    DateTime? target;
    if (expiryTime != null && expiryTime.trim().isNotEmpty) {
      target = DateTime.tryParse(expiryTime.trim())?.toLocal();
    }
    if (target == null &&
        orderCreatedAt != null &&
        orderCreatedAt.trim().isNotEmpty) {
      final created = DateTime.tryParse(orderCreatedAt.trim())?.toLocal();
      if (created != null) {
        target = created.add(const Duration(seconds: _initialCountdownSeconds));
      }
    }
    if (target == null) return _initialCountdownSeconds;
    final diff = target.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _data = widget.args ?? PaymentArgs.fallback();
    if (_data.backendMethod != null && _data.backendMethod!.isNotEmpty) {
      _syncSelectionFromBackendMethod(_data.backendMethod);
    } else {
      _currentMethod = _data.paymentMethod;
    }
    _remainingSeconds = _parseInitialRemainingSeconds(
      _data.expiryTime,
      _data.orderCreatedAt,
    );
    _startTimer();
    _initRealtimeListener();
    _initRealPayment();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        mounted &&
        _isRealOrder &&
        !_paidNotified &&
        !_isTerminalState) {
      _syncStatusOnce();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    _statusPollTimer?.cancel();
    _orderEventSub?.cancel();
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
        if (_isRealOrder && !_paidNotified && !_isTerminalState) {
          _syncStatusOnce();
        }
      }
    });
  }

  Future<void> _syncStatusOnce() async {
    final orderId = int.tryParse(_data.orderId);
    if (orderId == null || orderId <= 0) return;
    try {
      final res = await _paymentDs.checkPaymentStatus(orderId);
      if (!mounted) return;
      final st = res['payment_status']?.toString() ??
          res['order_status']?.toString() ??
          'pending';
      if (st == 'paid' || st == 'success') {
        _handlePaidConfirmed();
      } else if (st == 'expired' || st == 'cancelled' || st == 'failed') {
        _handleTerminalStatus(st);
      }
    } catch (_) {}
  }

  String get _formattedCountdown {
    final hours = (_remainingSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes =
        ((_remainingSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$hours : $minutes : $seconds';
  }

  String get _deadlineText {
    final target = _paymentInfo?.expiryDateTime?.toLocal() ??
        DateTime.now().add(Duration(seconds: _remainingSeconds));
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
    if (_isTerminalState || _paidNotified) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/profile');
      }
      return;
    }

    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Keluar dari Pembayaran?'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Anda bisa menyimpan pesanan untuk dibayar nanti sebelum batas waktu berakhir, atau membatalkan pesanan sekarang.'
              .tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          if (_isRealOrder)
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'cancel'),
              child: Text(
                'Batalkan Pesanan'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: AppColors.danger,
                ),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'stay'),
            child: Text(
              'Lanjut Bayar'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, 'later'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
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

    if (!mounted) return;
    if (choice == 'later') {
      ProfileScreen.selectedTabNotifier.value = 'Belum Bayar';
      ProfileScreen.refreshNotifier.value++;
      context.go('/profile?tab=Belum Bayar');
    } else if (choice == 'cancel') {
      await _cancelCurrentOrder();
    }
  }

  Future<void> _cancelCurrentOrder() async {
    final orderId = int.tryParse(_data.orderId);
    if (orderId == null || orderId <= 0) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await _paymentDs.cancelPayment(orderId);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      _handleTerminalStatus('cancelled');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Pesanan #${_data.orderId} berhasil dibatalkan.'.tr),
        ),
      );
      context.go('/profile');
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  Future<void> _checkPaymentStatus() async {
    final orderId = int.tryParse(_data.orderId);
    if (orderId == null || orderId <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Mode pratinjau tanpa pesanan nyata. Buat pesanan dari Keranjang untuk menguji Midtrans Sandbox.'
                .tr,
          ),
        ),
      );
      return;
    }

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
                'Memeriksa Pembayaran...'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Menghubungkan ke Midtrans Sandbox'.tr,
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

    try {
      final res = await _paymentDs.checkPaymentStatus(orderId);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      final payStatus = res['payment_status']?.toString() ??
          res['order_status']?.toString() ??
          'pending';
      if (payStatus == 'paid' || payStatus == 'success') {
        _handlePaidConfirmed();
      } else if (payStatus == 'expired' ||
          payStatus == 'cancelled' ||
          payStatus == 'failed') {
        _handleTerminalStatus(payStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.danger,
            content: Text(
              payStatus == 'expired'
                  ? 'Batas waktu pembayaran sudah kedaluwarsa.'.tr
                  : 'Pembayaran telah dibatalkan atau gagal.'.tr,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.black,
            content: Text(
              'Pembayaran belum terkonfirmasi. Selesaikan transaksi di kanal pembayaran lalu cek kembali.'
                  .tr,
              style: GoogleFonts.plusJakartaSans(color: Colors.white),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
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
                        MockData.formatPrice(_totalToPay),
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
                                ? (_selectedVaBank == 'Mandiri'
                                    ? 'Mandiri Bill Payment'
                                    : 'Virtual Account ($_selectedVaBank)')
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
                      ProfileScreen.selectedTabNotifier.value = 'Dikemas';
                      ProfileScreen.refreshNotifier.value++;
                      context.go('/profile?tab=Dikemas');
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

  // ═══ 1. Banner Batas Waktu Pembayaran (Countdown / Terminal Status) ═══════
  Widget _buildCountdownCard() {
    final isDark = AppColors.isDark;
    if (_isTerminalState) {
      final isExpired = _terminalStatus == 'expired';
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D1215) : const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFECACA),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isExpired ? Icons.timer_off_rounded : Icons.cancel_rounded,
              color: AppColors.danger,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isExpired
                        ? 'Waktu Pembayaran Habis'.tr
                        : 'Pesanan Dibatalkan'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.danger,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isExpired
                        ? 'Tagihan telah kedaluwarsa dan stok produk telah dikembalikan.'
                            .tr
                        : 'Transaksi dibatalkan. Anda dapat membuat pesanan baru kapan saja.'
                            .tr,
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
      );
    }

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
                    MockData.formatPrice(_totalToPay),
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
                  _totalToPay.toString(),
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

  /// Konten QR: utamakan data ASLI dari Midtrans Core API agar bisa discan & dibayar.
  /// 1) qr_image_url / qr_string berupa URL gambar -> Image.network
  /// 2) qr_string data URI base64                   -> Image.memory
  /// 3) qr_string payload EMVCo QRIS               -> QR sungguhan via qr_flutter
  /// 4) mode pratinjau (tanpa order nyata)         -> pola ilustrasi
  Widget _buildQrContent() {
    final qr = _paymentInfo?.qrString ?? '';

    if (_qrImageUrl != null) {
      return Image.network(
        _qrImageUrl!,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => qr.isNotEmpty
            ? QrImageView(
                data: qr,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
              )
            : _qrUnavailableFallback(),
      );
    }

    if (qr.startsWith('data:image')) {
      try {
        final base64Part = qr.split(',').last;
        return Image.memory(
          base64Decode(base64Part),
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => _qrUnavailableFallback(),
        );
      } catch (_) {}
    }

    if (qr.isNotEmpty) {
      return QrImageView(
        data: qr,
        version: QrVersions.auto,
        size: 200,
        backgroundColor: Colors.white,
        errorStateBuilder: (_, _) => _qrUnavailableFallback(),
      );
    }

    if (_isRealOrder) {
      return _qrUnavailableFallback();
    }
    return _IllustrativeQr(seed: _data.orderId.hashCode ^ _totalToPay);
  }

  Widget _qrUnavailableFallback() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.qr_code_2_rounded, size: 42, color: AppColors.textMuted),
        const SizedBox(height: 8),
        Text(
          'Kode QR belum tersedia'.tr,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        TextButton.icon(
          onPressed: _initRealPayment,
          icon: const Icon(Icons.refresh_rounded, size: 15),
          label: Text('Muat Ulang'.tr,
              style: GoogleFonts.plusJakartaSans(fontSize: 11)),
        ),
      ],
    );
  }

  void _onSelectMethodGroup(String method) {
    if (_isTerminalState || _paidNotified) return;
    if (_payLoading && _isRealOrder) return;
    if (_currentMethod == method) return;
    setState(() => _currentMethod = method);
    if (_isRealOrder) {
      _initRealPayment();
    }
  }

  void _onSelectVaBank(String bank) {
    if (_isTerminalState || _paidNotified) return;
    if (_payLoading && _isRealOrder) return;
    if (_selectedVaBank == bank) return;
    setState(() => _selectedVaBank = bank);
    if (_isRealOrder) {
      _initRealPayment();
    }
  }

  void _onSelectEWallet(String wallet) {
    if (_isTerminalState || _paidNotified) return;
    if (_payLoading && _isRealOrder) return;
    if (_selectedEWallet == wallet) return;
    setState(() => _selectedEWallet = wallet);
    if (_isRealOrder) {
      _initRealPayment();
    }
  }

  String _formatVaNumber(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '-';
    final clean = raw.replaceAll(RegExp(r'\s+'), '');
    if (clean.length <= 4) return clean;
    final buffer = StringBuffer();
    for (var i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(clean[i]);
    }
    return buffer.toString();
  }

  Future<void> _openDeeplink(String? url, {required String appName}) async {
    final trimmed = url?.trim() ?? '';
    if (trimmed.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Tautan aplikasi $appName belum tersedia. Gunakan QR atau coba muat ulang.'
                .tr,
          ),
        ),
      );
      return;
    }
    final resolvedUrl = trimmed.startsWith('/')
        ? '${ApiClient.baseHost}$trimmed'
        : trimmed;
    final uri = Uri.tryParse(resolvedUrl);
    if (uri != null) {
      try {
        final launched =
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (launched) return;
      } catch (_) {}
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Tidak dapat membuka aplikasi $appName di perangkat ini. Pindai QR atau gunakan Simulator Midtrans Sandbox.'
              .tr,
        ),
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
      onTap: () => _onSelectMethodGroup(method),
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

  Widget _buildBankLeading(String bank, {double height = 11}) {
    switch (bank) {
      case 'BCA':
        return SvgPicture.asset(AppAssets.paymentBca,
            height: height, fit: BoxFit.contain);
      case 'Mandiri':
        return SvgPicture.asset(AppAssets.paymentMandiri,
            height: height, fit: BoxFit.contain);
      case 'BRI':
        return SvgPicture.asset(AppAssets.paymentBri,
            height: height, fit: BoxFit.contain);
      case 'BNI':
        return SvgPicture.asset(AppAssets.paymentBni,
            height: height, fit: BoxFit.contain);
      case 'Permata':
      default:
        return Icon(Icons.account_balance_rounded,
            size: height + 1, color: const Color(0xFF0F172A));
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

  Widget _buildChargeStatusPlaceholder({double height = 120}) {
    if (_payLoading) {
      return SizedBox(
        height: height,
        child: const Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Column(
        children: [
          Icon(Icons.wifi_off_rounded, size: 28, color: AppColors.textMuted),
          const SizedBox(height: 8),
          Text(
            _payError ?? 'Gagal memuat data pembayaran.'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextButton.icon(
            onPressed: _initRealPayment,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text('Coba Lagi'.tr,
                style: GoogleFonts.plusJakartaSans(fontSize: 12)),
          ),
        ],
      ),
    );
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
                  'Midtrans QRIS',
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
            _paymentInfo?.gatewayOrderId != null
                ? 'Ref: ${_paymentInfo!.gatewayOrderId}'
                : 'Sentra Kerajinan Keramik Dinoyo Malang',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
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
              child: _payLoading
                  ? const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      ),
                    )
                  : _payError != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wifi_off_rounded,
                                size: 32, color: AppColors.textMuted),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                _payError!,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: _initRealPayment,
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: Text(
                                'Coba Lagi'.tr,
                                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                              ),
                            ),
                          ],
                        )
                      : _buildQrContent(),
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
          if ((_paymentInfo?.deeplinkUrl ?? '').isNotEmpty &&
              !_payLoading &&
              _payError == null) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openDeeplink(
                  _paymentInfo!.deeplinkUrl,
                  appName: 'QRIS Midtrans',
                ),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: Text(
                  'Bayar QRIS (Sandbox)'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ] else
            const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final qrPayload = _paymentInfo?.qrString;
                    if (qrPayload != null &&
                        qrPayload.isNotEmpty &&
                        !qrPayload.startsWith('http')) {
                      _copyToClipboard(
                        qrPayload,
                        'Payload QRIS disalin! Anda juga bisa screenshot QR di atas.'
                            .tr,
                      );
                    } else {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.black,
                          content: Text(
                            'Silakan screenshot gambar QR di atas untuk diunggah dari galeri.'
                                .tr,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5, color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.qr_code_rounded, size: 16),
                  label: Text(
                    'Salin / Panduan QR'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
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
                  onPressed: () {
                    if (_paymentInfo?.deeplinkUrl != null) {
                      _openDeeplink(_paymentInfo!.deeplinkUrl, appName: 'QRIS');
                    } else {
                      _showQuickAppsSheet();
                    }
                  },
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
      {
        'name': 'Livin\' by Mandiri',
        'type': 'm-Banking',
        'icon': AppAssets.paymentMandiri
      },
      {'name': 'BRImo', 'type': 'm-Banking', 'icon': AppAssets.paymentBri},
      {'name': 'BNI Mobile', 'type': 'm-Banking', 'icon': AppAssets.paymentBni},
      {'name': 'OVO', 'type': 'E-Wallet', 'icon': AppAssets.paymentOvo},
      {
        'name': 'ShopeePay',
        'type': 'E-Wallet',
        'icon': AppAssets.paymentShopeepay
      },
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
            child: SingleChildScrollView(
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
                    'Cara Bayar Lewat Aplikasi'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Screenshot QRIS di atas lalu pindai atau unggah gambar QR lewat menu Scan di aplikasi berikut:'
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
                      trailing:
                          const Icon(Icons.qr_code_scanner_rounded, size: 16),
                      onTap: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              'Buka ${app['name']}, pilih menu Scan QR lalu arahkan atau unggah QRIS di atas.'
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
          ),
        );
      },
    );
  }

  // ═══ 4B. Tampilan Pembayaran Virtual Account (VA) ═════════════════════════
  Widget _buildVaSection() {
    const banks = ['BCA', 'Mandiri', 'BRI', 'BNI', 'Permata'];
    final isMandiriBill = _selectedVaBank == 'Mandiri';
    final rawVa = _paymentInfo?.vaNumber;
    final deeplink = _paymentInfo?.deeplinkUrl;
    final billerCode = _paymentInfo?.billerCode ?? '';
    final formattedVa = _isRealOrder
        ? _formatVaNumber(rawVa)
        : 'Buat pesanan dari keranjang untuk VA Midtrans';

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final bank in banks) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      onPressed: () => _onSelectVaBank(bank),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
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
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: _buildBankLeading(bank, height: 11),
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
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_isRealOrder && (_payLoading || _payError != null))
            _buildChargeStatusPlaceholder()
          else ...[
            // Nomor VA / Mandiri Bill Card
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
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: _buildBankLeading(_selectedVaBank, height: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isMandiriBill
                                ? 'Mandiri Bill (Multipayment)'
                                : 'No. Virtual Account $_selectedVaBank',
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
                  if (isMandiriBill && billerCode.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Kode Perusahaan (Biller Code)'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          billerCode,
                          style: GoogleFonts.robotoMono(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => _copyToClipboard(
                            billerCode,
                            'Kode Perusahaan Mandiri disalin!'.tr,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            side: BorderSide(color: AppColors.borderAlt),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            minimumSize: const Size(0, 28),
                          ),
                          child: Text('Salin'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(height: 1, color: AppColors.borderAlt),
                  ],
                  const SizedBox(height: 8),
                  if (isMandiriBill)
                    Text(
                      'Kode Pembayaran (Bill Key)'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          formattedVa,
                          style: GoogleFonts.robotoMono(
                            fontSize: _isRealOrder ? 16 : 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      if (rawVa != null && rawVa.isNotEmpty)
                        ElevatedButton(
                          onPressed: () => _copyToClipboard(
                            rawVa.replaceAll(RegExp(r'\s+'), ''),
                            isMandiriBill
                                ? 'Bill Key Mandiri berhasil disalin!'.tr
                                : 'Nomor VA $_selectedVaBank berhasil disalin!'
                                    .tr,
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
                    'Nama Tagihan: DinoyoCraft - ${_data.recipientName}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (deeplink != null && deeplink.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openDeeplink(
                          deeplink,
                          appName: isMandiriBill
                              ? 'Mandiri Bill'
                              : 'VA $_selectedVaBank',
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: Text(
                          (isMandiriBill
                                  ? 'Bayar Mandiri Bill (Sandbox)'
                                  : 'Bayar VA $_selectedVaBank (Sandbox)')
                              .tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mode Sandbox: tekan tombol di atas untuk langsung diarahkan ke pembayaran Midtrans tanpa salin nomor VA secara manual.'
                          .tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
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

          _buildVaInstructions(_selectedVaBank, _selectedVaTab),
        ],
      ),
    );
  }

  Widget _buildVaInstructions(String bank, String channel) {
    List<String> steps;
    if (bank == 'Mandiri') {
      if (channel == 'ATM') {
        steps = [
          'Masukkan kartu ATM Mandiri dan PIN Anda.',
          'Pilih Bayar/Beli > Lainnya > Lainnya > Multi Payment.',
          'Masukkan Kode Perusahaan (${_paymentInfo?.billerCode ?? '70012'}) lalu tekan Benar.',
          'Masukkan Kode Pembayaran (Bill Key) di atas dan konfirmasi nominal tagihan.',
        ];
      } else if (channel == 'i-Banking') {
        steps = [
          'Login ke Internet Banking Mandiri.',
          'Pilih Pembayaran > Multi Payment > Penyedia Jasa Midtrans (${_paymentInfo?.billerCode ?? '70012'}).',
          'Masukkan Kode Pembayaran (Bill Key) Anda.',
          'Periksa detail tagihan dan konfirmasi transaksi.',
        ];
      } else {
        steps = [
          'Buka aplikasi Livin\' by Mandiri di ponsel Anda.',
          'Pilih menu Bayar > Cari/masukkan Kode Perusahaan ${_paymentInfo?.billerCode ?? '70012'}.',
          'Masukkan Kode Pembayaran (Bill Key) di atas.',
          'Pastikan total tagihan sesuai lalu masukkan PIN Livin\' Anda.',
        ];
      }
    } else if (channel == 'ATM') {
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

  // ═══ 4C. Tampilan Pembayaran E-Wallet (GoPay & ShopeePay Core API) ════════
  Widget _buildEWalletSection() {
    const wallets = ['GoPay', 'ShopeePay'];
    final deeplink = _paymentInfo?.deeplinkUrl;
    final hasQr = _selectedEWallet == 'GoPay' &&
        (_qrImageUrl != null || (_paymentInfo?.qrString?.isNotEmpty ?? false));

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
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton(
                      onPressed: () => _onSelectEWallet(w),
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: _buildEWalletLogo(w, height: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            w,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
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
          const SizedBox(height: 8),
          Text(
            'Untuk pembayaran via OVO atau DANA, silakan gunakan tab QRIS Instant di atas.'
                .tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          if (_isRealOrder && (_payLoading || _payError != null))
            _buildChargeStatusPlaceholder()
          else ...[
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
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: _buildEWalletLogo(_selectedEWallet,
                                height: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_selectedEWallet via Midtrans',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
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
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openDeeplink(
                        deeplink,
                        appName: _selectedEWallet,
                      ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: Text(
                        'Buka Aplikasi $_selectedEWallet'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),
                  if (hasQr) ...[
                    const SizedBox(height: 14),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: SizedBox(
                          width: 170,
                          height: 170,
                          child: _buildQrContent(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tekan tombol di atas untuk langsung diarahkan ke aplikasi $_selectedEWallet dan konfirmasikan pembayaran sebelum batas waktu berakhir.'
                  .tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
          ],
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
                          child: _data.items[i].product.image
                                  .startsWith('http')
                              ? DcCachedImage(
                                  imageUrl: _data.items[i].product.image,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorWidget: Icon(
                                    Icons.image_outlined,
                                    size: 22,
                                    color: AppColors.textMuted,
                                  ),
                                )
                              : Image.asset(
                                  _data.items[i].product.image,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Icon(
                                    Icons.image_outlined,
                                    size: 22,
                                    color: AppColors.textMuted,
                                  ),
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

                  // Rincian Biaya — diturunkan dari Total Pembayaran resmi
                  // (_totalToPay = nominal gateway yang tercetak di QR),
                  // sehingga baris-baris ini MUSTAHIL beda dengan angka atas.
                  _buildCostRow('Subtotal Produk'.tr, _data.subtotal),
                  const SizedBox(height: 4),
                  _buildCostRow('Biaya Pengiriman'.tr, _data.shippingFee),
                  const SizedBox(height: 4),
                  _buildCostRow(
                    'Biaya Layanan'.tr,
                    (_totalToPay - _data.subtotal - _data.shippingFee)
                        .clamp(0, _totalToPay),
                  ),
                  const SizedBox(height: 8),
                  _buildCostRow(
                    'Total Pembayaran'.tr,
                    _totalToPay,
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
          child: _isTerminalState
              ? SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: () => context.go('/home'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'Belanja Lagi'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed:
                            (_payLoading && _isRealOrder) ? null : _checkPaymentStatus,
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
                          'Bayar Nanti / Batalkan'.tr,
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
                  if (!_isTerminalState) ...[
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
/// QR ilustrasi untuk mode demo (tanpa data gateway) — TIDAK bisa discan.
class _IllustrativeQr extends StatelessWidget {
  const _IllustrativeQr({this.seed = 0});

  final int seed;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _QrisCodePainter(seed: seed));
  }
}

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

