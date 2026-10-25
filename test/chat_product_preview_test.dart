import 'package:dinoyocraftmobile/core/app_settings.dart';
import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/features/chat/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    AppColors.isDark = false;
    AppSettings.instance.setThemeMode(AppThemeMode.light);
  });

  testWidgets('ChatRoomScreen tanpa productId tidak menampilkan preview di bawah',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: ChatRoomScreen(storeName: 'Dinoyo Ceramic Studio'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ditanyakan'), findsNothing);
    expect(find.byTooltip('Hapus Preview'), findsNothing);
  });

  testWidgets(
      'ChatRoomScreen dengan productId menampilkan preview di atas input bar dan bisa ditutup dengan X',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: ChatRoomScreen(
          storeName: 'Dinoyo Ceramic Studio',
          productId: '1',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Preview terlihat di bawah (di atas input bar) dengan detail produk
    expect(find.text('Ditanyakan'), findsOneWidget);
    expect(find.text('Vas Minimalis'), findsOneWidget);
    expect(find.text('Rp85.000'), findsOneWidget);
    expect(find.byTooltip('Hapus Preview'), findsOneWidget);

    // Pengguna bisa langsung mengetik pertanyaan
    final inputFinder = find.byType(TextField);
    expect(inputFinder, findsOneWidget);
    await tester.enterText(inputFinder, 'Halo min, vas ini ready stock?');
    await tester.pump();
    expect(find.text('Halo min, vas ini ready stock?'), findsOneWidget);

    // Tekan tombol dismiss 'X' (Hapus Preview)
    await tester.tap(find.byTooltip('Hapus Preview'));
    await tester.pumpAndSettle();

    // Preview berhasil dihapus
    expect(find.text('Ditanyakan'), findsNothing);
    expect(find.byTooltip('Hapus Preview'), findsNothing);
    expect(find.text('Lihat Produk'), findsNothing);
    // Teks yang sudah diketik tetap ada
    expect(find.text('Halo min, vas ini ready stock?'), findsOneWidget);
  });

  testWidgets(
      'ChatRoomScreen dengan productId mengirim kartu produk dan teks via tombol kirim chat utama',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: ChatRoomScreen(
          storeName: 'Dinoyo Ceramic Studio',
          productId: '1',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ditanyakan'), findsOneWidget);
    expect(find.text('Lihat Produk'), findsNothing);

    // Ketik pertanyaan sekalian
    final inputFinder = find.byType(TextField);
    await tester.enterText(inputFinder, 'Apakah vas ini ada warna putih glossy?');
    await tester.pump();

    // Tekan tombol kirim chat di bar bawah
    final sendButtonFinder = find.byKey(const ValueKey('chat_send_button'));
    expect(sendButtonFinder, findsOneWidget);
    await tester.tap(sendButtonFinder);
    await tester.pumpAndSettle();

    // Preview di bawah hilang
    expect(find.text('Ditanyakan'), findsNothing);
    // Kartu produk terkirim ke chat bubble
    expect(find.text('Lihat Produk'), findsOneWidget);
    // Teks pertanyaan juga terkirim ke chat bubble
    expect(find.text('Apakah vas ini ada warna putih glossy?'), findsOneWidget);
  });

  testWidgets(
      'ChatRoomScreen dengan productId bisa langsung dikirim via tombol kirim chat tanpa ketik teks',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: ChatRoomScreen(
          storeName: 'Dinoyo Ceramic Studio',
          productId: '1',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ditanyakan'), findsOneWidget);
    expect(find.text('Lihat Produk'), findsNothing);

    // Tekan tombol kirim chat di bar bawah tanpa ketik teks
    final sendButtonFinder = find.byKey(const ValueKey('chat_send_button'));
    await tester.tap(sendButtonFinder);
    await tester.pumpAndSettle();

    // Preview di bawah hilang dan produk terkirim ke bubble chat
    expect(find.text('Ditanyakan'), findsNothing);
    expect(find.text('Lihat Produk'), findsOneWidget);
  });

  testWidgets(
      'kartu produk yang dikirim memiliki tombol keranjang di sebelah kiri Lihat Produk dan warna tombol hitam',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: ChatRoomScreen(
          storeName: 'Dinoyo Ceramic Studio',
          productId: '1',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Kirim produk
    final sendButtonFinder = find.byKey(const ValueKey('chat_send_button'));
    await tester.tap(sendButtonFinder);
    await tester.pumpAndSettle();

    // Pastikan tombol keranjang ada di sebelah kiri tombol Lihat Produk
    final cartButtonFinder =
        find.byKey(const ValueKey('chat_product_cart_button'));
    expect(cartButtonFinder, findsOneWidget);

    // Pastikan tombol Lihat Produk berlatar AppColors.black (bukan oranye)
    final lihatProdukFinder =
        find.widgetWithText(ElevatedButton, 'Lihat Produk');
    expect(lihatProdukFinder, findsOneWidget);
    final ElevatedButton btnWidget =
        tester.widget<ElevatedButton>(lihatProdukFinder);
    expect(btnWidget.style?.backgroundColor?.resolve({}), AppColors.black);

    // Tekan tombol keranjang -> modal variasi terbuka
    await tester.tap(cartButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Tambah ke Keranjang'), findsOneWidget);
  });
}
