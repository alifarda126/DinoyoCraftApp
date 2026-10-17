import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/asset_constants.dart';

// ─── Cart Item Model (placeholder — ganti dengan entity domain layer) ─────────
class CartItem {
CartItem({
    required this.id,
    required this.productName,
    required this.studioName,
    required this.variant,
    required this.price,
    required this.imagePath,
    this.qty = 1,
    this.isSelected = true,
  });

  final String id;
  final String productName;
  final String studioName;
  final String variant;
  final int price;
  final String imagePath;
  int qty;
  bool isSelected;
}

// ─── Cart Page ────────────────────────────────────────────────────────────────
class CartPage extends StatefulWidget {
const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // TODO: Ambil dari cart repository / state management
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      productName: 'Vas Keramik Minimalis',
      studioName: 'Ruang Tanah Dinoyo',
      variant: 'Broken White Terracotta',
      price: 85000,
      imagePath: AppAssets.productVas,
    ),
    CartItem(
      id: '2',
      productName: 'Cangkir Handmade',
      studioName: 'Dinoyo Ceramic Studio',
      variant: 'Rustic Speckle Sand',
      price: 65000,
      imagePath: AppAssets.productCangkir,
    ),
  ];

  bool get _allSelected => _items.every((i) => i.isSelected);
  List<CartItem> get _selectedItems => _items.where((i) => i.isSelected).toList();

  int get _subtotal =>
      _selectedItems.fold(0, (sum, i) => sum + (i.price * i.qty));

  String _formatPrice(int price) {
    return 'Rp${price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      for (final item in _items) {
        item.isSelected = value ?? false;
      }
    });
  }

  void _deleteSelected() {
    setState(() => _items.removeWhere((i) => i.isSelected));
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Keranjang Belanja', style: AppTextStyles.appBarTitle),
            Text('${_items.length} Produk', style: AppTextStyles.caption),
          ],
        ),
      ),
      body: _items.isEmpty
          ? _EmptyCart()
          : Column(
              children: [
                // ── Select all bar ──────────────────────────────────────
                _SelectAllBar(
                  allSelected: _allSelected,
                  selectedCount: _selectedItems.length,
                  onToggleAll: _toggleSelectAll,
                  onDeleteSelected:
                      _selectedItems.isEmpty ? null : _deleteSelected,
                ),
                Divider(height: 1, color: AppColors.border),

                // ── Item list ───────────────────────────────────────────
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.bottomNavClearance,
                    ),
                    itemCount: _items.length,
                    separatorBuilder: (_, _) =>
                        Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return _CartItemTile(
                        item: item,
                        onToggle: (val) =>
                            setState(() => item.isSelected = val ?? false),
                        onQtyChanged: (qty) =>
                            setState(() => item.qty = qty),
                        onDelete: () =>
                            setState(() => _items.remove(item)),
                      );
                    },
                  ),
                ),
              ],
            ),

      // ── Bottom Checkout Bar ───────────────────────────────────────────
      bottomNavigationBar: _items.isEmpty
          ? null
          : _CheckoutBar(
              subtotal: _subtotal,
              selectedCount: _selectedItems.length,
              formattedTotal: _formatPrice(_subtotal),
              onCheckout: _selectedItems.isEmpty
                  ? null
                  : () {
                      // TODO: context.push('/checkout')
                    },
            ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────
class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: AppColors.textMuted,
          ),
          SizedBox(height: AppDimensions.paddingL),
          Text('Keranjang masih kosong', style: AppTextStyles.cardTitle),
          SizedBox(height: AppDimensions.gapS),
          Text(
            'Temukan produk keramik favoritmu dan tambahkan ke sini.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SelectAllBar extends StatelessWidget {
  const _SelectAllBar({
    required this.allSelected,
    required this.selectedCount,
    required this.onToggleAll,
    required this.onDeleteSelected,
  });

  final bool allSelected;
  final int selectedCount;
  final ValueChanged<bool?> onToggleAll;
  final VoidCallback? onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.pageHorizontal,
        vertical: AppDimensions.paddingS,
      ),
      child: Row(
        children: [
          Checkbox(
            value: allSelected,
            onChanged: onToggleAll,
            activeColor: AppColors.black,
          ),
          SizedBox(width: 4),
          Text('Pilih Semua', style: AppTextStyles.fieldLabel),
          SizedBox(width: 6),
          Text('($selectedCount barang)', style: AppTextStyles.caption),
          Spacer(),
          if (onDeleteSelected != null)
            TextButton(
              onPressed: onDeleteSelected,
              child: Text(
                'Hapus Terpilih',
                style: AppTextStyles.seeAll.copyWith(color: Colors.redAccent),
              ),
            ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.onToggle,
    required this.onQtyChanged,
    required this.onDelete,
  });

  final CartItem item;
  final ValueChanged<bool?> onToggle;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onDelete;

  String _formatPrice(int price) {
    return 'Rp${price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.pageHorizontal,
        vertical: AppDimensions.paddingL,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Checkbox(
            value: item.isSelected,
            onChanged: onToggle,
            activeColor: AppColors.black,
          ),

          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: Image.asset(
              item.imagePath,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => ColoredBox(
                color: AppColors.inputBg,
                child: SizedBox(width: 72, height: 72),
              ),
            ),
          ),
          SizedBox(width: AppDimensions.gapM),

          // Info + controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.studioName,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  item.productName,
                  style: AppTextStyles.subTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(item.variant, style: AppTextStyles.caption),
                SizedBox(height: AppDimensions.gapS),
                Row(
                  children: [
                    Text(
                      _formatPrice(item.price),
                      style: AppTextStyles.price,
                    ),
                    Spacer(),
                    _QtyControl(
                      qty: item.qty,
                      onDecrement: item.qty > 1
                          ? () => onQtyChanged(item.qty - 1)
                          : null,
                      onIncrement: () => onQtyChanged(item.qty + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  const _QtyControl({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int qty;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SmallBtn(
          icon: Icons.remove,
          onTap: onDecrement,
          enabled: onDecrement != null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(qty.toString(), style: AppTextStyles.subTitle),
        ),
        _SmallBtn(icon: Icons.add, onTap: onIncrement, enabled: true),
      ],
    );
  }
}

class _SmallBtn extends StatelessWidget {
  const _SmallBtn({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? AppColors.border : AppColors.inputBg,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppColors.ink : AppColors.textMuted,
        ),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.subtotal,
    required this.selectedCount,
    required this.formattedTotal,
    required this.onCheckout,
  });

  final int subtotal;
  final int selectedCount;
  final String formattedTotal;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontal,
        AppDimensions.paddingL,
        AppDimensions.pageHorizontal,
        AppDimensions.paddingL + bottomPad,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Pembayaran', style: AppTextStyles.caption),
                  Text(formattedTotal, style: AppTextStyles.price),
                  Text(
                    'Termasuk pajak & asuransi',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    disabledBackgroundColor: AppColors.textMuted,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                  ),
                  child: Text(
                    'Checkout ($selectedCount)',
                    style: AppTextStyles.buttonLabel,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.gapS),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 4),
              Text(
                'Garansi Aman Pecah Belah DinoyoCraft 100%',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
