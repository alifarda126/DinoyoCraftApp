import 'package:flutter/material.dart';

import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage({super.key, this.orderId = '#DNC-001', this.productName = 'Vas Keramik Minimalis', this.variant = 'Sand White Glossy 1x', this.imagePath = AppAssets.productVas, this.studioName = 'Dinoyo Ceramic Studio'});
  final String orderId, productName, variant, imagePath, studioName;
  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int _rating = 0;
  final _commentCtrl = TextEditingController();

  static const _ratingLabels = ['', 'Mengecewakan', 'Kurang Memuaskan', 'Cukup Baik', 'Memuaskan', 'Sangat Memuaskan'];

  @override
  void dispose() { _commentCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg, elevation: 0, scrolledUnderElevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ink), onPressed: () => Navigator.of(context).maybePop()),
        title: Text('Beri Ulasan Produk', style: AppTextStyles.appBarTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppDimensions.pageHorizontal, AppDimensions.paddingL, AppDimensions.pageHorizontal, AppDimensions.bottomNavClearance),
        children: [
          // Order info
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(AppDimensions.radiusL)),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                child: Image.asset(widget.imagePath, width: 56, height: 56, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => ColoredBox(color: AppColors.border, child: const SizedBox(width: 56, height: 56))),
              ),
              const SizedBox(width: AppDimensions.gapM),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(widget.orderId, style: AppTextStyles.fieldLabel),
                  const SizedBox(width: 6),
                  Text('• Diterima 12 Feb 2025', style: AppTextStyles.caption),
                ]),
                Text(widget.productName, style: AppTextStyles.subTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('Varian: ${widget.variant}', style: AppTextStyles.caption),
                Text(widget.studioName, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
              ])),
            ]),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),

          // Star rating
          Text('Bagaimana kualitas keramik ini?', style: AppTextStyles.cardTitle),
          const SizedBox(height: AppDimensions.gapS),
          Text('Sentuh bintang untuk memberikan penilaian keseluruhan', style: AppTextStyles.bodySmall),
          const SizedBox(height: AppDimensions.paddingL),
          Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) => GestureDetector(
              onTap: () => setState(() => _rating = i + 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(i < _rating ? Icons.star_rounded : Icons.star_border_rounded, size: 40, color: i < _rating ? Colors.amber : AppColors.border),
              ),
            ))),
          ),
          if (_rating > 0) ...[
            const SizedBox(height: AppDimensions.gapM),
            Center(child: Text('${_ratingLabels[_rating]} $_rating/5 ★', style: AppTextStyles.subTitle)),
          ],
          const SizedBox(height: AppDimensions.paddingXXL),

          // Comment
          Text('Tulis Ulasanmu', style: AppTextStyles.cardTitle),
          const SizedBox(height: AppDimensions.gapM),
          TextFormField(
            controller: _commentCtrl,
            maxLines: 5,
            style: AppTextStyles.fieldText,
            decoration: InputDecoration(
              hintText: 'Ceritakan pengalamanmu dengan produk ini...',
              hintStyle: AppTextStyles.fieldHint,
              filled: true, fillColor: AppColors.inputBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusL), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusL), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusL), borderSide: const BorderSide(color: AppColors.ink, width: 1.2)),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),

          // Submit
          SizedBox(
            width: double.infinity, height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: _rating == 0 ? null : () {
                // TODO: submit review ke repository
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.black, disabledBackgroundColor: AppColors.textMuted, foregroundColor: AppColors.white, elevation: 0, shape: const StadiumBorder()),
              child: Text('Kirim Ulasan', style: AppTextStyles.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
