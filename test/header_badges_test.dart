import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/core/widgets/dc_app_header.dart';
import 'package:dinoyocraftmobile/data/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DcAppHeader menampilkan badge angka pada Notifikasi, Keranjang, dan Chat', (tester) async {
    AppColors.isDark = false;
    MockData.unreadNotificationsCount = 3;
    MockData.unreadChatCount = 1;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DcAppHeader(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verifikasi badge angka ada untuk notif (3), cart (2), dan chat (1)
    expect(find.text('3'), findsOneWidget); // Notifikasi
    expect(find.text('${MockData.mockCart.length}'), findsOneWidget); // Keranjang (2)
    expect(find.text('1'), findsOneWidget); // Chat
  });

  testWidgets('DcAppHeader mendukung badge angka di mode gelap', (tester) async {
    AppColors.isDark = true;
    MockData.unreadNotificationsCount = 5;
    MockData.unreadChatCount = 4;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const Scaffold(
          body: DcAppHeader(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('5'), findsOneWidget);
    expect(find.text('${MockData.mockCart.length}'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);

    // Reset state
    AppColors.isDark = false;
    MockData.unreadNotificationsCount = 3;
    MockData.unreadChatCount = 1;
  });
}
