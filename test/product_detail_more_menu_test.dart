import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/features/product/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Titik 3 pada ProductDetailScreen membuka menu Kembali ke Halaman Beranda & Butuh Bantuan', (tester) async {
    AppColors.isDark = false;
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailScreen(productId: 'prod-01'),
      ),
    );
    await tester.pumpAndSettle();

    // Verifikasi icon titik 3 ada di top bar
    final moreButton = find.byIcon(Icons.more_vert_rounded);
    expect(moreButton, findsOneWidget);

    // Tekan tombol titik 3
    await tester.tap(moreButton);
    await tester.pumpAndSettle();

    // Verifikasi opsi menu tampil sesuai foto
    expect(find.text('Kembali ke Halaman Beranda'), findsOneWidget);
    expect(find.text('Butuh Bantuan'), findsOneWidget);
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(find.byIcon(Icons.help_outline_rounded), findsOneWidget);
  });

  testWidgets('Titik 3 pada ProductDetailScreen mendukung mode gelap', (tester) async {
    AppColors.isDark = true;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const ProductDetailScreen(productId: 'prod-01'),
      ),
    );
    await tester.pumpAndSettle();

    final moreButton = find.byIcon(Icons.more_vert_rounded);
    expect(moreButton, findsOneWidget);

    await tester.tap(moreButton);
    await tester.pumpAndSettle();

    expect(find.text('Kembali ke Halaman Beranda'), findsOneWidget);
    expect(find.text('Butuh Bantuan'), findsOneWidget);

    AppColors.isDark = false;
  });
}
