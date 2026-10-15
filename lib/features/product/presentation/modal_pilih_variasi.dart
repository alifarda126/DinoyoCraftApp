import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';

/// Tipe aksi yang memicu modal.
enum ModalVariasiMode { keranjang, beliLangsung }

/// Tampilkan modal pilih variasi & jumlah produk sebagai bottom sheet.
Future<void> showModalPilihVariasi(
  BuildContext context, {
  required Product product,
  required ModalVariasiMode mode,
}) {
  return showModalBottomSheet(
    context: context,
    // Root navigator agar modal tampil di atas bottom navbar (seperti
    // modal Notifikasi, Keranjang, dan Semua Pesanan).
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x73000000),
    builder: (_) => _ModalPilihVariasi(product: product, mode: mode),
  );
}

// ── Daftar warna/variasi mock ─────────────────────────────────────────────────
class _Variasi {
  const _Variasi({
    required this.label,
    required this.sublabel,
    required this.color,
  });

  final String label;
  final String sublabel;
  final Color color;
}

const List<_Variasi> _variasiList = [
  _Variasi(label: 'Sand White', sublabel: 'Glossy Finish', color: Color(0xFFF5F0E8)),
  _Variasi(label: 'Terracotta', sublabel: 'Matte Earthy', color: Color(0xFFC97A5B)),
  _Variasi(label: 'Raw Speckle', sublabel: 'Bintik Alami', color: Color(0xFFD9D5CD)),
  _Variasi(label: 'Charcoal Ash', sublabel: 'Tekstur Abu', color: Color(0xFF3F3F3F)),
];

const Color _borderColor = Color(0xFFE5E5E5);

// ─────────────────────────────────────────────────────────────────────────────

class _ModalPilihVariasi extends StatefulWidget {
  const _ModalPilihVariasi({required this.product, required this.mode});

  final Product product;
  final ModalVariasiMode mode;

  @override
  State<_ModalPilihVariasi> createState() => _ModalPilihVariasiState();
}

class _ModalPilihVariasiState extends State<_ModalPilihVariasi> {
  int _selectedVariasi = 0;
  int _jumlah = 1;

  /// Stok tersedia per varian — sejajar indeksnya dengan [_variasiList].
  static const List<int> _stokPerVariasi = [18, 7, 12, 4];

  int get _stokVariasi => _stokPerVariasi[_selectedVariasi];

  int get _subtotal => widget.product.price * _jumlah;

  @override
  Widget build(BuildContext context) {
    // Harga coret dibulatkan ke atas kelipatan 5.000 (Rp65.000 -> Rp90.000)
    final originalPrice = ((widget.product.price * 1.35) / 5000).ceil() * 5000;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Color(0x40000000), blurRadius: 40, offset: Offset(0, -12)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFD4D4D4),
              borderRadius: BorderRadius.circular(9999),
            ),
          ),

          // ── Header: info produk + tombol X (X di pojok kanan atas) ──
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: _ProductInfoRow(
                  product: widget.product,
                  originalPrice: originalPrice,
                  stok: _stokVariasi,
                ),
              ),
              Positioned(
                top: 6,
                right: 14,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: Color(0xFF404040)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, thickness: 1, color: _borderColor),
          const SizedBox(height: 16),

          // ── Pilihan warna/glaze ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PILIHAN WARNA / GLAZE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF262626),
                      ),
                    ),
                    Text(
                      '${_variasiList[_selectedVariasi].label} ${_variasiList[_selectedVariasi].sublabel}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFF737373),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildVariasiRow(0, 1),
                const SizedBox(height: 10),
                _buildVariasiRow(2, 3),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Divider inset (mengikuti padding konten)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 1, color: _borderColor),
          ),
          const SizedBox(height: 14),

          // ── Jumlah produk ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'JUMLAH PRODUK',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF262626),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Stok tersisa $_stokVariasi buah untuk varian ini',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF737373),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _JumlahCounter(
                  value: _jumlah,
                  min: 1,
                  max: _stokVariasi,
                  onChanged: (v) => setState(() => _jumlah = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: _borderColor),

          // ── Bottom action bar ──
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 12, 20, 14 + bottomPad),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal Estimasi:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF737373),
                      ),
                    ),
                    Text(
                      MockData.formatPrice(_subtotal),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Tombol aksi
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: widget.mode == ModalVariasiMode.keranjang
                      ? OutlinedButton.icon(
                          onPressed: _onKeranjang,
                          icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                          label: Text(
                            'Tambah ke Keranjang',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            shape: const StadiumBorder(),
                            side: const BorderSide(color: AppColors.ink, width: 2),
                          ),
                        )
                      : FilledButton(
                          onPressed: _onBeliLangsung,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            'Beli Langsung',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
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

  /// Satu baris berisi dua kartu variasi.
  Widget _buildVariasiRow(int left, int right) {
    Widget item(int i) => Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              _selectedVariasi = i;
              // Jumlah mengikuti stok varian yang baru dipilih.
              _jumlah = _jumlah.clamp(1, _stokPerVariasi[i]);
            }),
            child: _VariasiCard(
              variasi: _variasiList[i],
              isSelected: _selectedVariasi == i,
            ),
          ),
        );

    return Row(
      children: [
        item(left),
        const SizedBox(width: 10),
        item(right),
      ],
    );
  }

  void _onKeranjang() {
    // Simpan ke keranjang sesi agar badge header & halaman keranjang ikut.
    MockData.addToCart(widget.product, _jumlah);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product.name} — ${_variasiList[_selectedVariasi].label} '
          '(x$_jumlah) ditambahkan ke keranjang!',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onBeliLangsung() {
    Navigator.pop(context);
    context.push('/checkout');
  }
}

// ── Widget: Info produk ───────────────────────────────────────────────────────

class _ProductInfoRow extends StatelessWidget {
  const _ProductInfoRow({
    required this.product,
    required this.originalPrice,
    required this.stok,
  });

  final Product product;
  final int originalPrice;
  final int stok;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gambar dalam kotak berborder tipis
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.asset(
              product.image,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Teks (disisakan ruang di kanan agar tidak menabrak tombol X)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.studio,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF737373),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      MockData.formatPrice(product.price),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      MockData.formatPrice(originalPrice),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFFA3A3A3),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      'Stok Pengrajin: ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF737373),
                      ),
                    ),
                    Text(
                      '$stok buah',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Widget: Kartu variasi ─────────────────────────────────────────────────────

class _VariasiCard extends StatelessWidget {
  const _VariasiCard({required this.variasi, required this.isSelected});

  final _Variasi variasi;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    // Swatch terang (mis. Sand White) butuh ikon hitam
    final swatchIsDark = variasi.color.computeLuminance() < 0.4;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.ink : _borderColor,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: variasi.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4D4D4)),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 13,
                  color: swatchIsDark ? Colors.white : Colors.black,
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  variasi.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  variasi.sublabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: const Color(0xFF737373),
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

// ── Widget: Counter jumlah ────────────────────────────────────────────────────

class _JumlahCounter extends StatelessWidget {
  const _JumlahCounter({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    // Counter dibungkus kotak berborder tipis: [ − ] 1 [ + ]
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(
            icon: Icons.remove,
            filled: false,
            enabled: value > min,
            onTap: () => onChanged(value - 1),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          _StepBtn(
            icon: Icons.add,
            filled: true,
            enabled: value < max,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({
    required this.icon,
    required this.filled,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;

  /// true = tombol hitam solid (+), false = tombol putih berborder (−)
  final bool filled;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final Border? border;

    if (filled) {
      bg = enabled ? AppColors.black : const Color(0xFFE5E5E5);
      fg = enabled ? Colors.white : const Color(0xFFAAAAAA);
      border = null;
    } else {
      bg = Colors.white;
      fg = enabled ? AppColors.ink : const Color(0xFF525252);
      border = Border.all(color: _borderColor);
    }

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          border: border,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: fg),
      ),
    );
  }
}