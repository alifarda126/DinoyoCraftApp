import 'package:flutter_test/flutter_test.dart';

import 'package:dinoyocraftmobile/core/app_settings.dart';
import 'package:dinoyocraftmobile/core/app_text.dart';

void main() {
  setUp(() {
    AppSettings.instance.setLocale('id');
  });

  tearDown(() {
    AppSettings.instance.setLocale('id');
  });

  group('DinoyoCraft App Language Localization Tests', () {
    test('Default locale is strictly Indonesian ("id")', () {
      expect(AppSettings.instance.locale, 'id');
      expect(AppText.isEnglish, isFalse);
    });

    test('Indonesian strings remain unchanged in default locale', () {
      expect('Beranda'.tr, 'Beranda');
      expect('Produk'.tr, 'Produk');
      expect('Toko'.tr, 'Toko');
      expect('Workshop'.tr, 'Workshop');
      expect('Profil'.tr, 'Profil');
      expect('Pengaturan'.tr, 'Pengaturan');
      expect('Hapus Akun'.tr, 'Hapus Akun');
      expect('Kelola Alamat'.tr, 'Kelola Alamat');
      expect('Ketik pesan...'.tr, 'Ketik pesan...');
      expect('Ringkasan Belanja'.tr, 'Ringkasan Belanja');
    });

    test('Switching to English translates UI strings reactively', () async {
      AppSettings.instance.setLocale('en');

      expect(AppSettings.instance.locale, 'en');
      expect(AppText.isEnglish, isTrue);

      // Bottom nav / core
      expect('Beranda'.tr, 'Home');
      expect('Produk'.tr, 'Products');
      expect('Toko'.tr, 'Stores');
      expect('Workshop'.tr, 'Workshop');
      expect('Profil'.tr, 'Profile');

      // Settings & Profile
      expect('Pengaturan'.tr, 'Settings');
      expect('Keamanan Akun'.tr, 'Account Security');
      expect('Ubah Kata Sandi'.tr, 'Change Password');
      expect('Bahasa Aplikasi'.tr, 'App Language');
      expect('Tema Tampilan'.tr, 'Display Theme');
      expect('Hapus Akun'.tr, 'Delete Account');
      expect('Keluar dari Akun'.tr, 'Log Out');

      // Address & Checkout
      expect('Kelola Alamat'.tr, 'Manage Addresses');
      expect('Tambah Alamat Baru'.tr, 'Add New Address');
      expect('Ringkasan Belanja'.tr, 'Order Summary');
      expect('Metode Pengiriman'.tr, 'Shipping Method');
      expect('Bayar Sekarang'.tr, 'Pay Now');

      // Chat & Reviews
      expect('Ketik pesan...'.tr, 'Type a message...');
      expect('Lihat Profil Toko'.tr, 'View Store Profile');
      expect('Beri Ulasan Produk'.tr, 'Write Product Review');
      expect('Kirim Ulasan'.tr, 'Submit Review');

      // Auth
      expect('Masuk ke Akun'.tr, 'Sign In to Account');
      expect('Daftar Akun Baru'.tr, 'Register New Account');
      expect('Masuk dengan Google'.tr, 'Sign In with Google');
    });

    test('Switching back to Indonesian restores original Indonesian text', () async {
      AppSettings.instance.setLocale('en');
      expect('Beranda'.tr, 'Home');

      AppSettings.instance.setLocale('id');
      expect(AppSettings.instance.locale, 'id');
      expect(AppText.isEnglish, isFalse);
      expect('Beranda'.tr, 'Beranda');
      expect('Pengaturan'.tr, 'Pengaturan');
      expect('Masuk dengan Google'.tr, 'Masuk dengan Google');
    });
  });
}
