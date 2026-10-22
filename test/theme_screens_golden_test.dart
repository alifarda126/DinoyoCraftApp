// Test utilitas: merender setiap layar aktif dalam mode terang & gelap
// menjadi PNG (golden) untuk audit visual tema.
//
// Jalankan:  flutter test --update-goldens test/theme_screens_golden_test.dart
// Hasil:     test/goldens/light_<nama>.png dan dark_<nama>.png
import 'dart:io';

import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/core/theme/app_theme.dart';
import 'package:dinoyocraftmobile/features/auth/forgot_password_screen.dart';
import 'package:dinoyocraftmobile/features/auth/login_screen.dart';
import 'package:dinoyocraftmobile/features/auth/new_password_screen.dart';
import 'package:dinoyocraftmobile/features/auth/onboarding_screen.dart';
import 'package:dinoyocraftmobile/features/auth/otp_screen.dart';
import 'package:dinoyocraftmobile/features/auth/register_screen.dart';
import 'package:dinoyocraftmobile/features/cart/cart_screen.dart';
import 'package:dinoyocraftmobile/features/chat/chat_list_screen.dart';
import 'package:dinoyocraftmobile/features/chat/chat_room_screen.dart';
import 'package:dinoyocraftmobile/features/chatbot/chatbot_screen.dart';
import 'package:dinoyocraftmobile/features/checkout/checkout_screen.dart';
import 'package:dinoyocraftmobile/features/help/help_screen.dart';
import 'package:dinoyocraftmobile/features/home/home_screen.dart';
import 'package:dinoyocraftmobile/features/notification/notifications_screen.dart';
import 'package:dinoyocraftmobile/features/product/product_detail_screen.dart';
import 'package:dinoyocraftmobile/features/products/products_screen.dart';
import 'package:dinoyocraftmobile/features/profile/alamat_screen.dart';
import 'package:dinoyocraftmobile/features/profile/data_diri_screen.dart';
import 'package:dinoyocraftmobile/features/profile/delete_account_screen.dart';
import 'package:dinoyocraftmobile/features/profile/pengaturan_screen.dart';
import 'package:dinoyocraftmobile/features/profile/profile_screen.dart';
import 'package:dinoyocraftmobile/features/review/reviews_screen.dart';
import 'package:dinoyocraftmobile/features/review/write_review_screen.dart';
import 'package:dinoyocraftmobile/features/stores/store_detail_screen.dart';
import 'package:dinoyocraftmobile/features/stores/stores_screen.dart';
import 'package:dinoyocraftmobile/features/workshop/workshop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Case {
  const _Case(this.name, this.builder);
  final String name;
  final WidgetBuilder builder;
}

final _cases = <_Case>[
  _Case('onboarding', (_) => const OnboardingScreen()),
  _Case('login', (_) => LoginScreen()),
  _Case('register', (_) => RegisterScreen()),
  _Case('forgot_password', (_) => ForgotPasswordScreen()),
  _Case('new_password', (_) => NewPasswordScreen()),
  _Case('otp', (_) => OtpScreen(from: 'register')),
  _Case('home', (_) => HomeScreen()),
  _Case('products', (_) => ProductsScreen(initialCategory: 'Semua')),
  _Case('product_detail', (_) => ProductDetailScreen(productId: '1')),
  _Case('stores', (_) => StoresScreen()),
  _Case('store_detail', (_) => StoreDetailScreen(storeIndex: 0)),
  _Case('workshop', (_) => WorkshopScreen()),
  _Case('help', (_) => HelpScreen()),
  _Case('cart', (_) => CartScreen()),
  _Case('checkout', (_) => CheckoutScreen()),
  _Case('reviews', (_) => ReviewsScreen(storeName: 'Dinoyo Ceramic Studio')),
  _Case('write_review', (_) => WriteReviewScreen()),
  _Case('notifications', (_) => NotificationsScreen()),
  _Case('profile', (_) => ProfileScreen()),
  _Case('data_diri', (_) => DataDiriScreen()),
  _Case('alamat', (_) => AlamatScreen()),
  _Case('pengaturan', (_) => PengaturanScreen()),
  _Case('hapus_akun', (_) => DeleteAccountScreen()),
  _Case('chat_list', (_) => ChatListScreen()),
  _Case('chat_room', (_) => ChatRoomScreen(storeName: 'Dinoyo Ceramic Studio')),
  _Case('chatbot', (_) => ChatbotScreen()),
];

void main() {
  // Hanya aktif saat dijalankan eksplisit untuk (re)generate PNG:
  //   flutter test --update-goldens test/theme_screens_golden_test.dart
  //   (dengan env GOLDEN=1)
  // Di run `flutter test` biasa test ini di-skip: font fallback antar-mesin
  // berbeda sehingga perbandingan golden pasti gagal.
  if (Platform.environment['GOLDEN'] != '1') {
    return;
  }

  // Test utilitas audit visual: overflow minor muncul karena font fallback
  // test lebih lebar dari PlusJakartaSans asli — jangan gagalkan test &
  // jangan gambar strip error ke PNG (mencemari audit warna).
  final defaultError = FlutterError.onError;
  FlutterError.onError = (details) {
    final text = details.toString();
    if (text.contains('overflowed')) return;
    defaultError?.call(details);
  };

  for (final isDark in [false, true]) {
    final mode = isDark ? 'dark' : 'light';
    for (final c in _cases) {
      testWidgets('$mode-${c.name}', (tester) async {
        // Viewport tinggi (390x1600 logis) = potret full-page: seluruh isi
        // layar panjang (checkout, pengaturan, alamat) masuk satu PNG.
        tester.view.physicalSize = const Size(1170, 4800);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.reset);

        AppColors.isDark = isDark;
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: isDark ? AppTheme.dark : AppTheme.light,
            // Scaffold pembungkus meniru MainShell: HomeScreen/WorkshopScreen
            // tak punya Scaffold sendiri dan mengandalkan latar induk.
            home: Scaffold(
              backgroundColor: AppColors.bg,
              body: Builder(key: const Key('screen'), builder: c.builder),
            ),
          ),
        );
        // Beberapa frame: animasi navigasi & post-frame callback selesai.
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 400));

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/$mode-${c.name}.png'),
        );
      });
    }

    // ── Dialog & sheet yang terbuka DARI DALAM menu ────────────────────────
    // Render layar → tap pemicu → golden hasilnya (modal tetap terbuka).
    final dialogCases = <(String, WidgetBuilder, String)>[
      ('dlg-variasi', (_) => ProductDetailScreen(productId: '1'), 'Keranjang'),
      ('dlg-checkout-alamat', (_) => CheckoutScreen(), 'Ubah Alamat'),
      ('dlg-alamat-form', (_) => AlamatScreen(), 'Tambah Alamat Baru'),
      ('dlg-pengaturan-perangkat', (_) => PengaturanScreen(),
          'Perangkat Terhubung'),
      ('dlg-pengaturan-bahasa', (_) => PengaturanScreen(), 'Bahasa Aplikasi'),
      ('dlg-pengaturan-tema', (_) => PengaturanScreen(), 'Tema Tampilan'),
      ('dlg-pengaturan-cache', (_) => PengaturanScreen(), 'Bersihkan Cache'),
    ];

    for (final isDark in [false, true]) {
      final mode = isDark ? 'dark' : 'light';
      for (final (name, builder, tapText) in dialogCases) {
        testWidgets('$mode-$name', (tester) async {
          tester.view.physicalSize = const Size(1170, 4800);
          tester.view.devicePixelRatio = 3.0;
          addTearDown(tester.view.reset);

          AppColors.isDark = isDark;
          await tester.pumpWidget(
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: isDark ? AppTheme.dark : AppTheme.light,
              home: Scaffold(
                backgroundColor: AppColors.bg,
                body: Builder(builder: builder),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 400));
          await tester.pump(const Duration(milliseconds: 400));

          // Gulirkan pemicu ke area terlihat (tile di layar panjang), lalu tap.
          final target = find.text(tapText).first;
          try {
            await tester.ensureVisible(target);
            await tester.pump(const Duration(milliseconds: 300));
          } catch (_) {
            // Pemicu di pinned bar (tanpa Scrollable) — sudah terlihat.
          }
          await tester.tap(target, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 400));
          await tester.pump(const Duration(milliseconds: 400));

          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/$mode-$name.png'),
          );
        });
      }
    }
  }
}
