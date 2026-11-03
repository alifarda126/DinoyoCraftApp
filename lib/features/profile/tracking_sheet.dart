import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_text.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';

/// Sheet pelacakan pesanan — timeline status yang DIAMBIL DARI BACKEND
/// (GET /orders/:id/tracking) dan otomatis menyegarkan diri setiap 8 detik
/// selama sheet terbuka, sehingga perubahan status dari mitra tampil
/// tanpa perlu apa pun dari user.
Future<void> showOrderTrackingSheet(BuildContext context, int orderId) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => OrderTrackingSheet(orderId: orderId),
  );
}

class OrderTrackingSheet extends StatefulWidget {
  const OrderTrackingSheet({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderTrackingSheet> createState() => _OrderTrackingSheetState();
}

class _OrderTrackingSheetState extends State<OrderTrackingSheet> {
  static const List<(String, String)> _steps = [
    ('pending', 'Pesanan Dibuat'),
    ('paid', 'Pembayaran Diterima'),
    ('packed', 'Sedang Dikemas Penjual'),
    ('shipped', 'Sedang Dikirim'),
    ('completed', 'Pesanan Diterima'),
  ];

  /// Situs resmi kurir untuk cek posisi paket. Resi otomatis tersalin ke
  /// clipboard saat chip ditekan; beberapa situs mengisinya lewat parameter.
  static const List<({String label, String urlTemplate})> _couriers = [
    (
      label: 'CekResi (auto)',
      urlTemplate: 'https://cekresi.com/?vno={resi}',
    ),
    (
      label: 'JNE',
      urlTemplate: 'https://www.jne.co.id/id/tracking/trace?awb={resi}',
    ),
    (
      label: 'J&T',
      urlTemplate: 'https://www.jet.co.id/track?billcode={resi}',
    ),
    (
      label: 'SiCepat',
      urlTemplate: 'https://www.sicepat.com/checkAwb/{resi}',
    ),
  ];

  Map<String, dynamic>? _order;
  List<Map<String, dynamic>> _timeline = [];
  bool _loading = true;
  String? _error;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _fetch();
    // OTOMATIS: segarkan timeline tiap 8 detik selama sheet terbuka.
    _pollTimer = Timer.periodic(const Duration(seconds: 8), (_) => _fetch(silent: true));
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetch({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    try {
      final res = await ApiClient.get('/orders/${widget.orderId}/tracking');
      if (res['success'] == true && res['data'] is Map<String, dynamic>) {
        final data = res['data'] as Map<String, dynamic>;
        if (!mounted) return;
        setState(() {
          _order = data;
          _timeline = (data['timeline'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .toList();
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (!silent) _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  /// Timestamp terakhir untuk sebuah status (null bila belum terjadi).
  Map<String, dynamic>? _entryFor(String status) {
    final matches = _timeline.where((t) => t['status']?.toString() == status).toList();
    return matches.isEmpty ? null : matches.last;
  }

  String _formatTime(String? iso) {
    if (iso == null) return '';
    final d = DateTime.tryParse(iso);
    if (d == null) return '';
    return '${d.day} ${_monthName(d.month)} ${d.year}, '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} WIB';
  }

  String _monthName(int m) => const [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ][m - 1];

  @override
  Widget build(BuildContext context) {
    final cancelled =
        (_order?['status']?.toString() == 'cancelled');
    final currentStatus = _order?['status']?.toString() ?? 'pending';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 14),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9999),
              color: AppColors.borderAlt,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lacak Pesanan'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        '#DNC-${widget.orderId}'
                        '${_order?['store_name'] != null ? ' • ${_order!['store_name']}' : ''}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Indikator auto-refresh
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: AppColors.surfaceSubtle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 1.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Live'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceSubtle,
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: Icon(Icons.close_rounded,
                        size: 15, color: AppColors.ink),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 16),

          // Nomor resi
          if ((_order?['tracking_number']?.toString() ?? '').isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.ink),
                  color: AppColors.surface,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Resi: ${_order!['tracking_number']}'
                        '${_order?['shipping_method'] != null ? ' • ${_order!['shipping_method']}' : ''}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                            text: _order!['tracking_number'].toString()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.black,
                            content: Text(
                              'Nomor resi disalin'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white),
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.copy_rounded, size: 17),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Cek resi di situs resmi kurir (buka browser dengan resi).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cek posisi paket di situs kurir:'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final c in _couriers) ...[
                        Expanded(
                          child: _courierChip(c),
                        ),
                        if (c != _couriers.last) const SizedBox(width: 6),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Timeline
          Flexible(
            child: _loading && _order == null
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _error != null
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(Icons.wifi_off_rounded,
                                color: AppColors.textMuted),
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _fetch,
                              icon: const Icon(Icons.refresh_rounded,
                                  size: 16),
                              label: Text('Coba Lagi'.tr),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding:
                            const EdgeInsets.fromLTRB(20, 4, 20, 28),
                        child: cancelled
                            ? _cancelledBox()
                            : Column(
                                children: [
                                  for (int i = 0; i < _steps.length; i++)
                                    _buildStep(
                                      index: i,
                                      status: _steps[i].$1,
                                      label: _steps[i].$2,
                                      isLast: i == _steps.length - 1,
                                      currentStatus: currentStatus,
                                    ),
                                  if ((_order?['items'] as List? ?? [])
                                      .isNotEmpty) ...[
                                    const SizedBox(height: 18),
                                    _buildItemsSummary(),
                                  ],
                                ],
                              ),
                      ),
          ),
        ],
      ),
    );
  }

  /// Buka situs resmi kurir di browser. Resi disalin dulu sebagai cadangan
  /// untuk situs yang tidak mengisi otomatis dari parameter URL.
  Future<void> _openCourierSite(String urlTemplate) async {
    final resi = _order?['tracking_number']?.toString() ?? '';
    if (resi.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: resi));
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.black,
          duration: const Duration(seconds: 2),
          content: Text(
            'Resi tersalin — tempel di situs kurir bila kolomnya masih kosong'.tr,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    }

    final url = urlTemplate.replaceAll('{resi}', Uri.encodeComponent(resi));
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            content: Text(
              'Tidak dapat membuka browser'.tr,
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  Widget _courierChip(({String label, String urlTemplate}) courier) {
    return GestureDetector(
      onTap: () => _openCourierSite(courier.urlTemplate),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.ink),
          color: AppColors.surface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                courier.label.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(width: 3),
            const Icon(Icons.open_in_new_rounded, size: 11),
          ],
        ),
      ),
    );
  }

  Widget _cancelledBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.danger),
        color: AppColors.surface,
      ),
      child: Column(
        children: [
          const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 34),
          const SizedBox(height: 8),
          Text(
            'Pesanan Dibatalkan'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.danger,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pesanan ini telah dibatalkan dan tidak diproses.'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required int index,
    required String status,
    required String label,
    required bool isLast,
    required String currentStatus,
  }) {
    final entry = _entryFor(status);
    final isDone = entry != null;

    // Urutan status untuk menentukan langkah aktif saat ini.
    final order_ = ['pending', 'paid', 'packed', 'shipped', 'completed'];
    final stepIdx = order_.indexOf(status);
    final currentIdx = order_.indexOf(currentStatus);
    final isCurrent = isDone && stepIdx == currentIdx;

    final dotColor = isCurrent
        ? AppColors.ink
        : isDone
            ? AppColors.ink
            : AppColors.border;
    final labelColor = isDone ? AppColors.ink : AppColors.textMuted;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Kolom garis + titik
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? dotColor : AppColors.surface,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                  child: isCurrent
                      ? const Icon(Icons.check_rounded,
                          size: 10, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDone ? AppColors.ink : AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  if (isDone) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatTime(entry['created_at']?.toString()),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (entry?['note']?.toString().isNotEmpty ?? false) ...[
                    const SizedBox(height: 2),
                    Text(
                      entry!['note'].toString(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSummary() {
    final items = (_order!['items'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        color: AppColors.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Paket'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          for (final it in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${it['product_name']} • ${it['quantity']}x',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              Text(
                'Rp ${((_order?['total_due'] ?? _order?['total_amount']) ?? 0).toString().replaceAllMapped(
                      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                      (m) => '${m[1]}.',
                    )}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
