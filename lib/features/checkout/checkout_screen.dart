import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../data/mock_data.dart';

import 'payment_screen.dart';

export '../../data/mock_data.dart' show CartItem;
export 'payment_screen.dart' show PaymentArgs, PaymentScreen;

/// Halaman Checkout — disesuaikan dengan desain CO.png.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.directBuyItems});

  final List<CartItem>? directBuyItems;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _shipping = 'Regular';
  String _payment = 'QRIS';
  final TextEditingController _noteCtrl = TextEditingController();

  // Daftar alamat tersimpan (index 0 = alamat utama)
  final List<_Address> _addresses = [
    _Address(
      name: 'Customer',
      phone: '0859-777-588-138',
      address:
          'Jl. Sawiji Sari No.14, Kel. Mulyorejo, Kec. Sukun, Kota Malang, Jawa Timur 65147',
    ),
  ];
  int _selected = 0;

  _Address get _currentAddress => _addresses[_selected];

  /// Badge kecil berisi label alamat (RUMAH/KANTOR/...) di kartu alamat.
  Widget _labelBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  bool get _isDirectBuy => widget.directBuyItems != null;
  late List<CartItem> _items;
  late List<int> _qtys;

  @override
  void initState() {
    super.initState();
    _initItems();
  }

  void _initItems() {
    _items = widget.directBuyItems != null
        ? List<CartItem>.from(widget.directBuyItems!)
        : MockData.mockCart;
    _qtys = _items.map((item) => item.qty).toList();
  }

  @override
  void didUpdateWidget(covariant CheckoutScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.directBuyItems != oldWidget.directBuyItems) {
      _initItems();
    }
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  int get _subtotal {
    int total = 0;
    for (var i = 0; i < _items.length; i++) {
      total += _items[i].product.price * _qtys[i];
    }
    return total;
  }

  int get _shippingFee {
    switch (_shipping) {
      case 'Hemat':
        return 10000;
      case 'Express':
        return 25000;
      default: // Regular
        return 15000;
    }
  }

  static const int _serviceFee = 2000;

  int get _total => _items.isEmpty ? 0 : _subtotal + _shippingFee + _serviceFee;

  String _shippingLabel() {
    switch (_shipping) {
      case 'Hemat':
        return 'Hemat';
      case 'Express':
        return 'Express';
      default:
        return 'Reguler';
    }
  }

  // ═══ Alamat: tambah / ubah / pilih ═════════════════════════════════════
  Future<_Address?> _showAddressForm({_Address? existing}) {
    return showModalBottomSheet<_Address>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(0x73000000),
      builder: (_) => _AddressForm(existing: existing),
    );
  }

  Future<void> _addAddress() async {
    final result = await _showAddressForm();
    if (result == null || !mounted) return;
    _applyNewAddress(result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alamat baru ditambahkan')),
    );
  }

  /// Simpan hasil form: alamat utama masuk ke indeks 0, lainnya di akhir.
  void _applyNewAddress(_Address result) {
    setState(() {
      if (result.isPrimary) {
        _addresses.insert(0, result);
        _selected = 0;
      } else {
        _addresses.add(result);
        _selected = _addresses.length - 1;
      }
    });
  }

  Future<void> _showAddressPicker() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          return SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.8,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Pilih Alamat Pengiriman'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: Icon(Icons.close_rounded, size: 22),
                          color: AppColors.ink,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _addresses.length,
                        separatorBuilder: (_, _) => SizedBox(height: 10),
                        itemBuilder: (itemCtx, i) {
                          final a = _addresses[i];
                          final sel = i == _selected;
                          final isDark =
                              Theme.of(itemCtx).brightness == Brightness.dark ||
                                  AppColors.isDark;
                          return InkWell(
                            onTap: () {
                              setState(() => _selected = i);
                              Navigator.of(ctx).pop();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                              decoration: BoxDecoration(
                                color: sel
                                    ? (isDark
                                        ? const Color(0xFF282828)
                                        : AppColors.surface)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: sel
                                      ? (isDark ? Colors.white : AppColors.black)
                                      : AppColors.border,
                                  width: sel ? 1.5 : 1,
                                ),
                                boxShadow: (sel && isDark)
                                    ? [
                                        BoxShadow(
                                          color: Colors.white.withValues(alpha: 0.08),
                                          blurRadius: 8,
                                          spreadRadius: 0.5,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Icon(
                                      sel
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      size: 20,
                                      color: sel
                                          ? (isDark ? Colors.white : AppColors.black)
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                a.name,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.ink,
                                                ),
                                              ),
                                            ),
                                            if (i == 0) ...[
                                              SizedBox(width: 8),
                                              const _Badge('UTAMA'),
                                            ],
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                left: 8,
                                              ),
                                              child: _labelBadge(a.label),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          a.phone,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          a.address,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            height: 1.45,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final edited = await _showAddressForm(
                                        existing: a,
                                      );
                                      if (edited == null || !mounted) return;
                                      setState(() {
                                        _addresses[i] = edited;
                                        if (edited.isPrimary && i != 0) {
                                          _addresses.removeAt(i);
                                          _addresses.insert(0, edited);
                                          if (_selected == i) {
                                            _selected = 0;
                                          } else if (i < _selected) {
                                            _selected++;
                                          }
                                        }
                                      });
                                      setSheet(() {});
                                    },
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                    ),
                                    color: AppColors.ink,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final result = await _showAddressForm();
                          if (result == null || !mounted) return;
                          _applyNewAddress(result);
                          if (ctx.mounted) Navigator.of(ctx).pop();
                        },
                        icon: Icon(Icons.add, size: 18),
                        label: Text(
                          'Tambah Alamat Baru'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.ink,
                          shape: StadiumBorder(),
                          side: BorderSide(
                            color: AppColors.ink,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Konfirmasi hapus produk saat qty tinggal 1 dan tombol minus ditekan.
  Future<void> _confirmRemoveItem(int index) async {
    final product = _items[index].product;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Hapus Produk?'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${product.name}" '
          'dari pesanan?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text('Batal'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text('Hapus'.tr),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _items.removeAt(index);
      _qtys.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${product.name}" dihapus dari pesanan')),
    );
  }

  Future<void> _pay() async {
    final now = DateTime.now();
    final args = PaymentArgs(
      orderId:
          'DC-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${1000 + (now.millisecondsSinceEpoch % 9000)}',
      items: List<CartItem>.from(_items),
      qtys: List<int>.from(_qtys),
      subtotal: _subtotal,
      shippingFee: _shippingFee,
      serviceFee: _serviceFee,
      total: _total,
      paymentMethod: _payment,
      shippingMethod: _shipping,
      recipientName: _currentAddress.name,
      recipientPhone: _currentAddress.phone,
      recipientAddress: _currentAddress.address,
      note: _noteCtrl.text.trim().isNotEmpty ? _noteCtrl.text.trim() : null,
    );

    try {
      context.push('/checkout/payment', extra: args);
    } catch (_) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PaymentScreen(args: args),
        ),
      );
    }
  }

  // ═══ AppBar: ← Checkout ........ (?) ═══════════════════════════════════
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
        icon: SvgPicture.asset(
          AppAssets.iconBack,
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
        ),
      ),
      title: Text(
        'Checkout'.tr,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.push('/help'),
          icon: Icon(
            Icons.help_outline_rounded,
            color: AppColors.textMuted,
            size: 22,
          ),
        ),
        SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: AppColors.border),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalQty = _qtys.fold<int>(0, (s, q) => s + q);

    return AppBackScope(
      fallbackRoute: '/home',
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                // ─── Alamat Pengiriman ──────────────────────────────────
                _SectionHeader(
                  icon: Icons.location_on_outlined,
                  title: 'Alamat Pengiriman'.tr,
                ),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              _currentAddress.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          if (_selected == 0) ...[
                            SizedBox(width: 8),
                            const _Badge('UTAMA'),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _labelBadge(_currentAddress.label),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: _showAddressPicker,
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 14,
                                    color: AppColors.ink,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Ubah Alamat'.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 6),
                          Text(
                            _currentAddress.phone,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _currentAddress.address,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _DashedBorder(
                        radius: 8,
                        color: AppColors.textMuted,
                        child: Material(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: _addAddress,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 14,
                                    color: AppColors.ink,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Tambah Alamat Baru'.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22),

                // ─── Produk yang Dibeli ─────────────────────────────────
                _SectionHeader(
                  icon: Icons.inventory_2_outlined,
                  title: '${'Produk yang Dibeli'.tr} ($totalQty)',
                  trailing: Text(
                    '${_items.length} Penjual Terpilih',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                if (_items.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 40,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(height: 10),
                        Text(
                          _isDirectBuy
                              ? 'Tidak ada produk'
                              : 'Keranjangmu kosong',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _isDirectBuy
                              ? 'Pilih produk untuk melanjutkan checkout.'
                              : 'Tambahkan produk dari halaman Keranjang.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ...List.generate(_items.length, (i) {
                  final item = _items[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _Card(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item.product.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                width: 80,
                                height: 80,
                                color: AppColors.inputBg,
                                child: Icon(
                                  Icons.image_outlined,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.storefront_outlined,
                                      size: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item.product.studio,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.variant != null &&
                                    item.variant!.isNotEmpty) ...[
                                  SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.inputBg,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    child: Text(
                                      'Variasi: ${item.variant}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        MockData.formatPrice(
                                          item.product.price,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                    ),
                                    _QtyStepper(
                                      qty: _qtys[i],
                                      onMinus: _qtys[i] > 1
                                          ? () => setState(() => _qtys[i]--)
                                          : () => _confirmRemoveItem(i),
                                      onPlus: () =>
                                          setState(() => _qtys[i]++),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 12),

                // ─── Metode Pengiriman ──────────────────────────────────
                _SectionHeader(
                  icon: Icons.local_shipping_outlined,
                  title: 'Metode Pengiriman'.tr,
                ),
                _ShippingTile(
                  title: 'Reguler'.tr,
                  subtitle: 'Estimasi 2–4 hari kerja'.tr,
                  price: 'Rp15.000',
                  selected: _shipping == 'Regular',
                  onTap: () => setState(() => _shipping = 'Regular'),
                ),
                _ShippingTile(
                  title: 'Hemat'.tr,
                  subtitle: 'Estimasi 4–7 hari kerja'.tr,
                  price: 'Rp10.000',
                  selected: _shipping == 'Hemat',
                  onTap: () => setState(() => _shipping = 'Hemat'),
                ),
                _ShippingTile(
                  title: 'Express'.tr,
                  subtitle: 'Estimasi 1–2 hari kerja (Prioritas)'.tr,
                  price: 'Rp25.000',
                  selected: _shipping == 'Express',
                  onTap: () => setState(() => _shipping = 'Express'),
                ),
                SizedBox(height: 14),

                // ─── Metode Pembayaran ──────────────────────────────────
                _SectionHeader(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Metode Pembayaran'.tr,
                ),
                _PaymentCard(
                  icon: Icons.qr_code_scanner_rounded,
                  title: 'QRIS Instant',
                  subtitle:
                      'Bayar instan bebas biaya admin dengan scan kode QRIS.',
                  badge: 'DIREKOMENDASIKAN',
                  tags: ['QRIS', 'GoPay', 'OVO', 'ShopeePay', 'BCA'],
                  selected: _payment == 'QRIS',
                  onTap: () => setState(() => _payment = 'QRIS'),
                ),
                _PaymentCard(
                  icon: Icons.account_balance_outlined,
                  title: 'Virtual Account',
                  subtitle:
                      'Verifikasi otomatis 24 jam tanpa perlu bukti transfer.',
                  tags: ['BCA', 'Mandiri', 'BRI', 'BNI 46'],
                  selected: _payment == 'VA',
                  onTap: () => setState(() => _payment = 'VA'),
                ),
                _PaymentCard(
                  icon: Icons.smartphone_rounded,
                  title: 'E-Wallet',
                  subtitle:
                      'Terhubung langsung ke akun dompet digital favorit kamu.',
                  tags: ['ShopeePay', 'GoPay', 'OVO', 'DANA'],
                  selected: _payment == 'E-Wallet',
                  onTap: () => setState(() => _payment = 'E-Wallet'),
                ),
                SizedBox(height: 14),

                // ─── Catatan untuk Penjual ──────────────────────────────
                _SectionHeader(
                  icon: Icons.notes_rounded,
                  title: 'Catatan untuk Penjual (Opsional)'.tr,
                  titleSize: 14,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _noteCtrl,
                    maxLines: 3,
                    minLines: 2,
                    onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.ink,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Contoh: Tolong bungkus dengan bubble wrap tebal dan kardus aman.',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.textMuted,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(height: 26),

                // ─── Ringkasan Pembayaran ───────────────────────────────
                Text(
                  'Ringkasan Pembayaran'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 12),
                _Card(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                  child: Column(
                    children: [
                      _RowLine(
                        'Subtotal Produk'.tr,
                        MockData.formatPrice(_subtotal),
                      ),
                      _RowLine(
                        '${'Biaya Pengiriman'.tr} (${_shippingLabel()})',
                        MockData.formatPrice(_shippingFee),
                      ),
                      _RowLine(
                        'Biaya Layanan'.tr,
                        MockData.formatPrice(_serviceFee),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.border,
                        ),
                      ),
                      _RowLine(
                        'Total Pembayaran'.tr,
                        MockData.formatPrice(_total),
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── Sticky footer ─────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total Tagihan'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            MockData.formatPrice(_total),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: 162,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: AppColors.darkButtonShadow,
                        ),
                        child: FilledButton(
                          onPressed: _items.isEmpty ? null : _pay,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: AppColors.stadiumButtonShape,
                          ),
                          child: Text(
                            'Bayar Sekarang'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}

// ─── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.trailing,
    this.titleSize = 16,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.ink),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: titleSize,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
          if (trailing != null) ...[Spacer(), trailing!],
        ],
      ),
    );
  }
}

// ─── Card (border abu-abu, putih) ─────────────────────────────────────────────
class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

// ─── Badge hitam (UTAMA / DIREKOMENDASIKAN) ───────────────────────────────────
class _Badge extends StatelessWidget {
  const _Badge(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF333333) : AppColors.black,
        borderRadius: BorderRadius.circular(4),
        border: isDark
            ? Border.all(color: Colors.white.withValues(alpha: 0.25))
            : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: AppColors.white,
        ),
      ),
    );
  }
}

// ─── Border putus-putus ───────────────────────────────────────────────────────
class _DashedBorder extends StatelessWidget {
  const _DashedBorder({
    required this.child,
    required this.radius,
    required this.color,
  });

  final Widget child;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedPainter(radius: radius, color: color),
      child: child,
    );
  }
}

class _DashedPainter extends CustomPainter {
  _DashedPainter({required this.radius, required this.color});

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );
    for (final PathMetric metric in path.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        canvas.drawPath(metric.extractPath(dist, dist + 4), paint);
        dist += 7; // 4 garis + 3 jarak
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedPainter old) =>
      old.color != color || old.radius != radius;
}

// ─── Qty stepper:  [ -  1  + ] ────────────────────────────────────────────────
class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  final int qty;
  final VoidCallback? onMinus;
  final VoidCallback onPlus;

  Widget _btn(IconData icon, VoidCallback? onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(6),
    child: SizedBox(
      width: 28,
      height: 30,
      child: Icon(
        icon,
        size: 14,
        color: onTap == null ? AppColors.textMuted : AppColors.ink,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, onMinus),
          SizedBox(
            width: 24,
            child: Text(
              '$qty',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
          _btn(Icons.add, onPlus),
        ],
      ),
    );
  }
}

// ─── Shipping tile ────────────────────────────────────────────────────────────
class _ShippingTile extends StatelessWidget {
  const _ShippingTile({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;
    final selectedBorderColor = isDark ? Colors.white : AppColors.black;
    final selectedRadioColor = isDark ? Colors.white : AppColors.black;
    final backgroundColor = selected
        ? (isDark ? const Color(0xFF282828) : AppColors.surface)
        : AppColors.surface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? selectedBorderColor : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: (selected && isDark)
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.08),
                      blurRadius: 8,
                      spreadRadius: 0.5,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 22,
                color: selected ? selectedRadioColor : AppColors.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Payment card ─────────────────────────────────────────────────────────────
class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> tags;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;
    final selectedBorderColor = isDark ? Colors.white : AppColors.black;
    final selectedRadioColor = isDark ? Colors.white : AppColors.black;
    final backgroundColor = selected
        ? (isDark ? const Color(0xFF282828) : AppColors.surface)
        : AppColors.surface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? selectedBorderColor : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: (selected && isDark)
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.08),
                      blurRadius: 8,
                      spreadRadius: 0.5,
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 22,
                    color: selected ? selectedRadioColor : AppColors.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Icon(icon, size: 18, color: AppColors.ink),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (badge != null) ...[
                    _Badge(badge!),
                    const SizedBox(width: 8),
                  ],
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 34, top: 6, right: 4),
                child: Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 34),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags.map((t) => _BrandChip(t)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Chip merek pembayaran (QRIS, GoPay, OVO, ...) ────────────────────────────
class _BrandChip extends StatelessWidget {
  const _BrandChip(this.tag);
  final String tag;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;

    Widget content;
    switch (tag) {
      case 'QRIS':
        content = SvgPicture.asset(
          AppAssets.paymentQris,
          height: 12,
          fit: BoxFit.contain,
        );
        break;
      case 'BCA':
        content = SvgPicture.asset(
          AppAssets.paymentBca,
          height: 12,
          fit: BoxFit.contain,
        );
        break;
      case 'BNI':
      case 'BNI 46':
        content = SvgPicture.asset(
          AppAssets.paymentBni,
          height: 12,
          fit: BoxFit.contain,
        );
        break;
      case 'BRI':
        content = SvgPicture.asset(
          AppAssets.paymentBri,
          height: 14,
          fit: BoxFit.contain,
        );
        break;
      case 'Mandiri':
        content = SvgPicture.asset(
          AppAssets.paymentMandiri,
          height: 12,
          fit: BoxFit.contain,
        );
        break;
      case 'GoPay':
        content = SvgPicture.asset(
          AppAssets.paymentGopay,
          height: 10,
          fit: BoxFit.contain,
        );
        break;
      case 'OVO':
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.paymentOvo,
              height: 12,
              width: 12,
            ),
            const SizedBox(width: 4),
            Text(
              'OVO',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF4C2A86),
              ),
            ),
          ],
        );
        break;
      case 'ShopeePay':
        content = SvgPicture.asset(
          AppAssets.paymentShopeepay,
          height: 13,
          fit: BoxFit.contain,
        );
        break;
      case 'DANA':
        content = SvgPicture.asset(
          AppAssets.paymentDana,
          height: 11,
          fit: BoxFit.contain,
        );
        break;
      default:
        content = Text(
          tag,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.ink,
          ),
        );
    }

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? const Color(0xFF383838) : const Color(0xFFE2E8F0),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          content,
        ],
      ),
    );
  }
}

// ─── Row line ─────────────────────────────────────────────────────────────────
class _RowLine extends StatelessWidget {
  const _RowLine(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.plusJakartaSans(
      fontSize: bold ? 15 : 13,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      color: bold ? AppColors.ink : AppColors.textSecondary,
    );
    final valueStyle = GoogleFonts.plusJakartaSans(
      fontSize: bold ? 20 : 13,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
      color: AppColors.ink,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}


// ─── Model alamat ─────────────────────────────────────────────────────────────
class _Address {
  _Address({
    required this.name,
    required this.phone,
    required this.address,
    this.label = 'Rumah',
    this.note = '',
    this.verifiedPin = true,
    this.isPrimary = false,
  });

  String name;
  String phone;
  String address;
  String label;
  String note;
  bool verifiedPin;
  bool isPrimary;
}

// ─── Form tambah / ubah alamat — gaya senada halaman Kelola Alamat ───────────
class _AddressForm extends StatefulWidget {
  const _AddressForm({this.existing});

  final _Address? existing;

  @override
  State<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<_AddressForm> {
  static const List<String> _labelOptions = [
    'Rumah',
    'Kantor',
    'Apartemen',
    'Studio',
    'Lainnya',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _note;
  late String _label;
  late bool _verifiedPin;
  late bool _isPrimary;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _phone = TextEditingController(text: widget.existing?.phone ?? '');
    _address = TextEditingController(text: widget.existing?.address ?? '');
    _note = TextEditingController(text: widget.existing?.note ?? '');
    _label = widget.existing?.label ?? 'Rumah';
    _verifiedPin = widget.existing?.verifiedPin ?? true;
    _isPrimary = widget.existing?.isPrimary ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      _Address(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        address: _address.text.trim(),
        label: _label,
        note: _note.text.trim(),
        verifiedPin: _verifiedPin,
        isPrimary: _isPrimary,
      ),
    );
  }

  InputDecoration _dec(String hint, IconData icon) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c, width: w),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        color: AppColors.textMuted,
      ),
      prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.ink, 1.2),
      errorBorder: border(AppColors.danger),
      focusedErrorBorder: border(AppColors.danger, 1.5),
      errorStyle: GoogleFonts.plusJakartaSans(fontSize: 11),
    );
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.textSecondary,
      ),
    ),
  );

  /// Kartu baris toggle — senada dengan halaman Kelola Alamat.
  Widget _toggleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.ink),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.black,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.border,
            trackOutlineColor: const WidgetStatePropertyAll<Color?>(
              Colors.transparent,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
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
              // Header: judul + tombol tutup
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit
                                ? 'Ubah Alamat Pengiriman'
                                : 'Tambah Alamat Baru',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Pastikan rincian alamat tepat untuk kurir keramik',
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
                      onPressed: () => Navigator.of(context).pop(),
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
                    // Label Alamat
                    _sectionLabel('LABEL ALAMAT'),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _labelOptions.map((opt) {
                        final isSelected = _label == opt;
                        final isDark =
                            Theme.of(context).brightness == Brightness.dark ||
                                AppColors.isDark;
                        return ChoiceChip(
                          label: Text(opt),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          selected: isSelected,
                          selectedColor:
                              isDark ? Colors.white : AppColors.black,
                          backgroundColor: AppColors.inputBg,
                          labelStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? (isDark ? AppColors.black : AppColors.white)
                                : AppColors.ink,
                          ),
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            color: isSelected
                                ? (isDark ? Colors.white : AppColors.black)
                                : AppColors.borderAlt,
                          ),
                          onSelected: (_) => setState(() => _label = opt),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),

                    // Nama Penerima
                    _sectionLabel('NAMA PENERIMA'),
                    TextFormField(
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.ink,
                      ),
                      decoration: _dec(
                        'Masukkan nama lengkap penerima',
                        Icons.person_outline_rounded,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Nama wajib diisi'
                          : null,
                    ),
                    SizedBox(height: 14),

                    // Nomor Telepon / WhatsApp
                    _sectionLabel('NOMOR TELEPON / WHATSAPP'),
                    TextFormField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.ink,
                      ),
                      decoration: _dec(
                        '+62 8xx-xxxx-xxxx',
                        Icons.phone_outlined,
                      ),
                      validator: (v) {
                        final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                        if (digits.isEmpty) return 'Nomor telepon wajib diisi';
                        if (digits.length < 9) {
                          return 'Nomor telepon tidak valid';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14),

                    // Alamat Lengkap
                    _sectionLabel('ALAMAT LENGKAP'),
                    TextFormField(
                      controller: _address,
                      minLines: 3,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.ink,
                      ),
                      decoration: _dec(
                        'Nama jalan, nomor rumah, RT/RW, kelurahan, '
                        'kecamatan, kota & kode pos',
                        Icons.location_on_outlined,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Alamat wajib diisi'
                          : null,
                    ),
                    SizedBox(height: 14),

                    // Catatan untuk Kurir
                    _sectionLabel('CATATAN UNTUK KURIR (OPSIONAL)'),
                    TextFormField(
                      controller: _note,
                      minLines: 2,
                      maxLines: 3,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.ink,
                      ),
                      decoration: _dec(
                        'cth: Pagar hitam depan studio keramik, titip satpam',
                        Icons.note_outlined,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Toggle: Titik Peta GPS
                    _toggleCard(
                      icon: Icons.pin_drop_outlined,
                      title: 'Verifikasi Titik Peta GPS',
                      subtitle: 'Mempermudah kurir melacak alamat akurat',
                      value: _verifiedPin,
                      onChanged: (v) => setState(() => _verifiedPin = v),
                    ),
                    SizedBox(height: 12),

                    // Toggle: Jadikan Alamat Utama
                    _toggleCard(
                      icon: Icons.star_outline_rounded,
                      title: 'Jadikan Alamat Utama',
                      subtitle: 'Alamat prioritas saat checkout belanjaan',
                      value: _isPrimary,
                      onChanged: (v) => setState(() => _isPrimary = v),
                    ),
                    SizedBox(height: 24),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: AppColors.darkButtonShadow,
                        ),
                        child: FilledButton(
                          onPressed: _save,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: AppColors.stadiumButtonShape,
                          ),
                          child: Text(
                            isEdit ? 'Simpan Perubahan' : 'Simpan Alamat Baru',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
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
      ),
    );
  }
}