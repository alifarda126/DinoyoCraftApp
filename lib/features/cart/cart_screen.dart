import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';

/// Tampilkan keranjang sebagai bottom sheet — dipanggil dari ikon keranjang
/// di header, senada dengan modal Notifikasi.
Future<void> showCartModal(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x73000000),
    builder: (_) => const _CartSheet(),
  );
}

/// Dialog konfirmasi hapus produk; dipakai halaman keranjang & sheet keranjang.
Future<bool> _confirmRemoveCartItemDialog(
  BuildContext context,
  String productName,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Hapus Produk?',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
      ),
      content: Text(
        'Apakah kamu yakin ingin menghapus "$productName" dari keranjang?',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          height: 1.5,
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogCtx).pop(false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogCtx).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final List<CartItem> _items = MockData.mockCart;
  late final List<int> _quantities = _items.map((item) => item.qty).toList();

  /// qty == 1 dan tombol minus ditekan → konfirmasi hapus produk.
  Future<void> _confirmRemoveItem(int index) async {
    final productName = _items[index].product.name;
    final confirmed = await _confirmRemoveCartItemDialog(context, productName);
    if (!confirmed || !mounted) return;
    setState(() {
      _items.removeAt(index);
      _quantities.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"$productName" dihapus dari keranjang')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = List.generate(
      _items.length,
      (index) => _items[index].product.price * _quantities[index],
    ).fold<int>(0, (sum, price) => sum + price);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _CartHeader(onBack: () => context.pop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                children: [
                  Text(
                    'Produk yang Dibeli (${_items.length})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_items.isEmpty) ...[
                    const SizedBox(height: 72),
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.shopping_cart_outlined,
                            size: 48,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Keranjangmu masih kosong',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Yuk, jelajahi produk keramik dan tambahkan '
                            'ke keranjang.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    ...List.generate(
                      _items.length,
                      (index) => _CartItem(
                        item: _items[index],
                        quantity: _quantities[index],
                        onMinus: _quantities[index] > 1
                            ? () => setState(() => _quantities[index]--)
                            : () => _confirmRemoveItem(index),
                        onPlus: () => setState(() => _quantities[index]++),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_shipping_outlined, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Pengiriman dan metode pembayaran dipilih pada halaman checkout.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                height: 1.4,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .08),
                      blurRadius: 14,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subtotal',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            MockData.formatPrice(total),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: _items.isEmpty
                          ? null
                          : () => context.push('/checkout'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        minimumSize: const Size(0, 50),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        'Checkout',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.onBack});
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    child: Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
        ),
        Expanded(
          child: Text(
            'Keranjang Belanja',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    ),
  );
}

class _CartItem extends StatelessWidget {
  const _CartItem({
    required this.item,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });
  final CartItem item;
  final int quantity;
  final VoidCallback? onMinus;
  final VoidCallback onPlus;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(
              item.product.image,
              width: 76,
              height: 76,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.product.studio,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  MockData.formatPrice(item.product.price),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _Qty(icon: Icons.remove, onTap: onMinus),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Text(
                  '$quantity',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _Qty(icon: Icons.add, onTap: onPlus),
            ],
          ),
        ],
      ),
    ),
  );
}

class _Qty extends StatelessWidget {
  const _Qty({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(6),
    child: Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        border: Border.all(
          color: onTap == null ? AppColors.border : AppColors.ink,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        size: 15,
        color: onTap == null ? AppColors.textMuted : AppColors.ink,
      ),
    ),
  );
}

// ─── Sheet keranjang (modal dari ikon header) ────────────────────────────────
class _CartSheet extends StatefulWidget {
  const _CartSheet();

  @override
  State<_CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends State<_CartSheet> {
  static const Color _handleBarColor = Color(0xFFCFC4C5);

  late final List<CartItem> _items = MockData.mockCart;
  late final List<int> _quantities = _items.map((item) => item.qty).toList();

  int get _subtotal {
    var total = 0;
    for (var i = 0; i < _items.length; i++) {
      total += _items[i].product.price * _quantities[i];
    }
    return total;
  }

  Future<void> _confirmRemoveItem(int index) async {
    final productName = _items[index].product.name;
    final confirmed = await _confirmRemoveCartItemDialog(context, productName);
    if (!confirmed || !mounted) return;
    setState(() {
      _items.removeAt(index);
      _quantities.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"$productName" dihapus dari keranjang')),
    );
  }

  void _goCheckout() {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.push('/checkout');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenH = mediaQuery.size.height;
    final bottomPad = mediaQuery.padding.bottom;

    // Tinggi senada modal Notifikasi.
    final modalH = (screenH * 0.64).clamp(500.0, 620.0) + bottomPad;

    return Container(
      height: modalH,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 40,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 14, bottom: 16),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                color: _handleBarColor,
              ),
            ),
          ),
          // Header: judul + badge jumlah item + tombol tutup
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Keranjang Belanja',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9999),
                        color: AppColors.black,
                      ),
                      child: Text(
                        '${_items.length} Item',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF4F3F3),
                      border: Border.all(
                        color: const Color(0xFFE5E5E5),
                        width: 0.8,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Daftar item / empty state
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          size: 48,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Keranjangmu masih kosong',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Yuk, jelajahi produk keramik dan tambahkan '
                          'ke keranjang.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    children: [
                      ...List.generate(
                        _items.length,
                        (index) => _CartItem(
                          item: _items[index],
                          quantity: _quantities[index],
                          onMinus: _quantities[index] > 1
                              ? () => setState(() => _quantities[index]--)
                              : () => _confirmRemoveItem(index),
                          onPlus: () => setState(() => _quantities[index]++),
                        ),
                      ),
                    ],
                  ),
          ),
          // Footer subtotal + checkout (hanya saat ada item)
          if (_items.isNotEmpty)
            Container(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomPad),
              decoration: const BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 14,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subtotal',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          MockData.formatPrice(_subtotal),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: _goCheckout,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      minimumSize: const Size(0, 50),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'Checkout',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
