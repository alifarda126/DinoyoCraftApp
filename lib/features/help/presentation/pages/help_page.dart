import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});
  final String question;
  final String answer;
}

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});
  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String _query = '';
  int? _expandedIndex;

  static const _faqs = [
    _FaqItem(question: 'Bagaimana cara memesan produk?', answer: 'Pilih produk yang diinginkan, klik tombol + atau "Beli Langsung", pilih variasi dan jumlah, lalu lanjut ke halaman checkout untuk mengisi data pengiriman dan pembayaran.'),
    _FaqItem(question: 'Bagaimana cara melakukan pembayaran?', answer: 'DinoyoCraft mendukung berbagai metode pembayaran: QRIS, GoPay, OVO, ShopeePay, dan transfer bank. Pilih metode yang Anda inginkan saat checkout.'),
    _FaqItem(question: 'Berapa lama proses pengiriman?', answer: 'Estimasi pengiriman tergantung metode yang dipilih: Reguler 2–4 hari kerja, Hemat 4–7 hari kerja, Express 1–2 hari kerja.'),
    _FaqItem(question: 'Apakah produk bisa diretur?', answer: 'Ya, produk dapat diretur dalam 7 hari setelah diterima jika terdapat kerusakan atau ketidaksesuaian produk. Hubungi tim bantuan kami untuk proses retur.'),
    _FaqItem(question: 'Bagaimana cara reservasi workshop?', answer: 'Kunjungi halaman Workshop dan klik "Hubungi Kami". Tim kami akan menginformasikan jadwal, harga, dan ketersediaan workshop keramik Dinoyo.'),
    _FaqItem(question: 'Bagaimana jika produk rusak saat pengiriman?', answer: 'Semua produk DinoyoCraft dijamin dengan Garansi Kemasan Aman. Jika produk rusak saat pengiriman, kami akan mengganti atau mengembalikan dana penuh.'),
  ];

  List<_FaqItem> get _filtered => _query.isEmpty ? _faqs : _faqs.where((f) => f.question.toLowerCase().contains(_query.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg, elevation: 0, scrolledUnderElevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ink), onPressed: () => Navigator.of(context).maybePop()),
        title: Text('Bantuan', style: AppTextStyles.appBarTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppDimensions.pageHorizontal, AppDimensions.paddingL, AppDimensions.pageHorizontal, AppDimensions.bottomNavClearance),
        children: [
          Text('Butuh Bantuan?', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.gapS),
          Text('Temukan jawaban untuk pertanyaan seputar DinoyoCraft.', style: AppTextStyles.bodySmall),
          const SizedBox(height: AppDimensions.paddingL),
          TextField(
            onChanged: (v) => setState(() { _query = v; _expandedIndex = null; }),
            decoration: InputDecoration(
              hintText: 'Cari pertanyaan...',
              hintStyle: AppTextStyles.fieldHint,
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
              filled: true, fillColor: AppColors.inputBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusL), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Row(children: [
            Text('Pertanyaan Umum', style: AppTextStyles.cardTitle),
            const SizedBox(width: AppDimensions.gapS),
            Text('${_filtered.length} Pertanyaan', style: AppTextStyles.caption),
          ]),
          const SizedBox(height: AppDimensions.paddingM),
          ..._filtered.asMap().entries.map((e) {
            final i = e.key;
            final faq = e.value;
            final isExpanded = _expandedIndex == i;
            return Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.paddingS),
              decoration: BoxDecoration(
                border: Border.all(color: isExpanded ? AppColors.ink : AppColors.border),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: InkWell(
                onTap: () => setState(() => _expandedIndex = isExpanded ? null : i),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(faq.question, style: AppTextStyles.subTitle)),
                      Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textMuted),
                    ]),
                    if (isExpanded) ...[
                      const SizedBox(height: AppDimensions.gapM),
                      Text(faq.answer, style: AppTextStyles.bodySmall),
                    ],
                  ]),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
