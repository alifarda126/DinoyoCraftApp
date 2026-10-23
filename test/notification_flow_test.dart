import 'package:dinoyocraftmobile/core/router/app_router.dart';
import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/core/widgets/dc_bottom_nav.dart';
import 'package:dinoyocraftmobile/data/mock_data.dart';
import 'package:dinoyocraftmobile/features/notification/notifications_screen.dart';
import 'package:dinoyocraftmobile/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    MockData.resetNotifications();
    AppColors.isDark = false;
  });

  group('Notifications Flow & Styling Tests', () {
    testWidgets('Modal Notifikasi menampilkan "2 Baru" dan dot hanya pada 2 kartu teratas', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NotificationsModalSheet(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Badge menampilkan 2 Baru, bukan 3 Baru
      expect(find.text('2 Baru'), findsOneWidget);
      expect(find.text('3 Baru'), findsNothing);

      // Kartu 1 (Voucher) dan Kartu 2 (Workshop) belum dibaca
      expect(MockData.readNotificationIds.contains('1'), isFalse);
      expect(MockData.readNotificationIds.contains('2'), isFalse);

      // Kartu 3, 4, 5 sudah dibaca
      expect(MockData.readNotificationIds.contains('3'), isTrue);
      expect(MockData.readNotificationIds.contains('4'), isTrue);
      expect(MockData.readNotificationIds.contains('5'), isTrue);
    });

    testWidgets('Mengetuk kartu notifikasi 1 & 2 mengubah status menjadi terbaca (dot hilang & badge berkurang)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NotificationsModalSheet(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2 Baru'), findsOneWidget);

      // Ketuk kartu 1 (Voucher Diskon Keramik 15%)
      await tester.tap(find.text('Voucher Diskon Keramik 15%'));
      await tester.pumpAndSettle();

      // Status kartu 1 berubah menjadi terbaca, badge berkurang jadi 1 Baru
      expect(MockData.readNotificationIds.contains('1'), isTrue);
      expect(find.text('1 Baru'), findsOneWidget);
      expect(MockData.unreadNotificationsCount, equals(1));

      // Ketuk kartu 2 (Jadwal Workshop Pembuatan Keramik)
      await tester.tap(find.text('Jadwal Workshop Pembuatan Keramik'));
      await tester.pumpAndSettle();

      // Status kartu 2 berubah menjadi terbaca, badge hilang karena 0 unread
      expect(MockData.readNotificationIds.contains('2'), isTrue);
      expect(find.text('1 Baru'), findsNothing);
      expect(find.text('2 Baru'), findsNothing);
      expect(MockData.unreadNotificationsCount, equals(0));
    });

    testWidgets('Mengetuk notifikasi pembayaran mengarahkan ke Profil dan navbar berpindah ke Profil', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const app.DinoyoCraftApp());
      await tester.pumpAndSettle();

      // Pastikan awalnya berada di halaman beranda (navbar index 0)
      appRouter.go('/home');
      await tester.pumpAndSettle();

      var bottomNav = tester.widget<DcBottomNav>(find.byType(DcBottomNav));
      expect(bottomNav.currentIndex, equals(0)); // Beranda

      // Buka modal notifikasi dari konteks beranda
      final BuildContext homeContext = tester.element(find.byType(DcBottomNav));
      showNotificationsModal(homeContext);
      await tester.pumpAndSettle();

      // Cari dan scroll ke kartu "Pembayaran Dikonfirmasi"
      final scrollableFinder = find.byType(SingleChildScrollView).last;
      await tester.drag(scrollableFinder, const Offset(0, -300));
      await tester.pumpAndSettle();

      final paymentFinder = find.text('Pembayaran Dikonfirmasi');
      expect(paymentFinder, findsOneWidget);

      await tester.tap(paymentFinder);
      await tester.pumpAndSettle();

      // Verifikasi navbar berpindah ke tab Profil (index 4)
      bottomNav = tester.widget<DcBottomNav>(find.byType(DcBottomNav));
      expect(bottomNav.currentIndex, equals(4)); // Profil
    });
  });
}
