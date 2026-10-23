import 'package:dinoyocraftmobile/core/widgets/image_preview_dialog.dart';
import 'package:dinoyocraftmobile/features/product/product_detail_screen.dart';
import 'package:dinoyocraftmobile/features/profile/profile_screen.dart';
import 'package:dinoyocraftmobile/features/review/reviews_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ImagePreviewDialog menampilkan judul, tombol close, dan menutup saat tombol ditekan',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () {
                ImagePreviewDialog.show(
                  context,
                  title: 'Foto Profil',
                  subtitle: 'Customer • @customer',
                  isAvatar: true,
                );
              },
              child: const Text('Buka Preview'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buka Preview'));
    await tester.pumpAndSettle();

    // Dialog preview terbuka
    expect(find.text('Foto Profil'), findsOneWidget);
    expect(find.text('Customer • @customer'), findsOneWidget);
    expect(find.text('Ubah foto profil melalui menu Kelola Data Diri'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Tekan tombol close
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Dialog tertutup
    expect(find.text('Foto Profil'), findsNothing);
  });

  testWidgets('ProfileScreen membuka ImagePreviewDialog saat avatar ditekan',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Avatar pengguna berupa ikon person atau foto profil
    final avatarFinder = find.byKey(const Key('profile_avatar_tap'));
    await tester.ensureVisible(avatarFinder);
    await tester.tap(avatarFinder);
    await tester.pumpAndSettle();

    // Dialog preview terbuka
    expect(find.text('Foto Profil'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Tutup dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Foto Profil'), findsNothing);
  });

  testWidgets('ProductDetailScreen membuka ImagePreviewDialog saat gambar produk utama ditekan',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailScreen(productId: '1'),
      ),
    );
    await tester.pumpAndSettle();

    // Verifikasi gambar produk utama dan badge 'Perbesar'
    final imageTapFinder = find.byKey(const Key('product_image_preview_tap'));
    expect(imageTapFinder, findsOneWidget);
    expect(find.text('Perbesar'), findsOneWidget);

    // Ketuk gambar produk
    await tester.tap(imageTapFinder);
    await tester.pumpAndSettle();

    // Dialog preview terbuka dengan InteractiveViewer
    expect(find.byType(ImagePreviewDialog), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Tutup dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ImagePreviewDialog), findsNothing);
  });

  testWidgets('ProductDetailScreen membuka ImagePreviewDialog saat foto ulasan ditekan',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailScreen(productId: '1'),
      ),
    );
    await tester.pumpAndSettle();

    // Scroll sampai foto ulasan terlihat di dalam ListView
    final reviewPhotoFinder = find.byKey(const Key('review_card_photo_tap'));
    final scrollFinder = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      reviewPhotoFinder,
      300,
      scrollable: scrollFinder,
    );
    await tester.pumpAndSettle();
    expect(reviewPhotoFinder, findsOneWidget);

    // Ketuk foto ulasan
    await tester.tap(reviewPhotoFinder);
    await tester.pumpAndSettle();

    // Dialog preview foto ulasan terbuka
    expect(find.byType(ImagePreviewDialog), findsOneWidget);
    expect(find.text('Foto Ulasan'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Tutup dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ImagePreviewDialog), findsNothing);
  });

  testWidgets('ReviewsScreen membuka ImagePreviewDialog saat foto ulasan ditekan',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ReviewsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Temukan foto ulasan pertama di ReviewsScreen
    final firstPhotoFinder = find.byWidgetPredicate(
      (w) =>
          w is GestureDetector &&
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith('reviews_screen_photo_tap_'),
    );
    expect(firstPhotoFinder, findsWidgets);

    await tester.ensureVisible(firstPhotoFinder.first);
    await tester.pumpAndSettle();
    await tester.tap(firstPhotoFinder.first);
    await tester.pumpAndSettle();

    // Dialog preview foto ulasan terbuka
    expect(find.byType(ImagePreviewDialog), findsOneWidget);
    expect(find.text('Foto Ulasan'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    // Tutup dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ImagePreviewDialog), findsNothing);
  });

  testWidgets('ImagePreviewDialog menampilkan foto full width edge-to-edge dan InteractiveViewer tanpa batasan boundary',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () {
                ImagePreviewDialog.show(
                  context,
                  title: 'Foto Ulasan',
                  assetPath: 'assets/images/vas.png',
                );
              },
              child: const Text('Buka Preview'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buka Preview'));
    await tester.pumpAndSettle();

    // Verifikasi InteractiveViewer memiliki boundaryMargin infinity dan clipBehavior none
    final viewer = tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
    expect(viewer.boundaryMargin, equals(const EdgeInsets.all(double.infinity)));
    expect(viewer.clipBehavior, equals(Clip.none));
    expect(viewer.maxScale, equals(6.0));

    // Verifikasi foto dibungkus SizedBox dengan lebar penuh layar
    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
    expect(sizedBoxes.any((s) => s.width == screenWidth), isTrue);

    // Double-tap untuk zoom
    await tester.tap(find.byType(InteractiveViewer));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byType(InteractiveViewer));
    await tester.pumpAndSettle();

    // Tutup dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ImagePreviewDialog), findsNothing);
  });

  testWidgets('ProductDetailScreen carousel foto dapat digeser dan indikator 1/4 berubah menjadi 2/4',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailScreen(productId: '1'),
      ),
    );
    await tester.pumpAndSettle();

    // Verifikasi indikator awal 1 / 4
    expect(find.text('1 / 4'), findsOneWidget);

    // Geser (fling) foto ke kiri
    await tester.fling(find.byType(PageView), const Offset(-500, 0), 2000);
    await tester.pumpAndSettle();

    // Verifikasi indikator berubah menjadi 2 / 4
    expect(find.text('2 / 4'), findsOneWidget);

    // Geser lagi ke foto ke-3
    await tester.fling(find.byType(PageView), const Offset(-500, 0), 2000);
    await tester.pumpAndSettle();
    expect(find.text('3 / 4'), findsOneWidget);

    // Ketuk tombol Perbesar pada foto aktif
    await tester.tap(find.text('Perbesar'));
    await tester.pumpAndSettle();

    // Dialog preview terbuka menampilkan foto ke-3
    expect(find.byType(ImagePreviewDialog), findsOneWidget);
    expect(find.textContaining('Foto 3 dari 4'), findsOneWidget);

    // Tutup dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ImagePreviewDialog), findsNothing);
  });
}

