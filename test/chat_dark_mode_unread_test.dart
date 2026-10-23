import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/data/mock_data.dart';
import 'package:dinoyocraftmobile/features/chat/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    MockData.resetChats();
    AppColors.isDark = false;
  });

  tearDown(() {
    MockData.resetChats();
    AppColors.isDark = false;
  });

  testWidgets('Chat baru (Karya Tanah) di mode gelap memiliki garis lebih terang dan menjadi sama setelah dibaca', (tester) async {
    AppColors.isDark = true;
    MockData.resetChats();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const ChatListScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Pastikan badge 1 muncul untuk Karya Tanah
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Karya Tanah'), findsOneWidget);

    // Cari container card untuk Karya Tanah dan chat lainnya
    final containers = tester.widgetList<Container>(
      find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final box = widget.decoration as BoxDecoration;
          return box.border != null && box.borderRadius == BorderRadius.circular(16);
        }
        return false;
      }),
    ).toList();

    expect(containers.length, equals(4));

    // Card kedua adalah Karya Tanah (unread)
    final karyaTanahBox = containers[1].decoration as BoxDecoration;
    final otherBox = containers[0].decoration as BoxDecoration;

    final karyaTanahBorder = karyaTanahBox.border as Border;
    final otherBorder = otherBox.border as Border;

    // Verifikasi card unread di dark mode memiliki border putih cerah (> otherBorder)
    expect(karyaTanahBorder.top.color, equals(Colors.white.withValues(alpha: 0.75)));
    expect(otherBorder.top.color, equals(AppColors.borderAlt));
    expect(karyaTanahBox.boxShadow, isNotNull);

    // Buka / tandai chat Karya Tanah sudah dibaca
    MockData.markChatAsRead('Karya Tanah');
    await tester.pumpAndSettle();

    // Badge 1 sekarang hilang karena sudah dibaca
    expect(find.text('1'), findsNothing);

    // Dapatkan kembali container setelah re-render
    final updatedContainers = tester.widgetList<Container>(
      find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final box = widget.decoration as BoxDecoration;
          return box.border != null && box.borderRadius == BorderRadius.circular(16);
        }
        return false;
      }),
    ).toList();

    final updatedKaryaTanahBox = updatedContainers[1].decoration as BoxDecoration;
    final updatedKaryaTanahBorder = updatedKaryaTanahBox.border as Border;

    // Warnanya sekarang sudah sama dengan yang lain (borderAlt)
    expect(updatedKaryaTanahBorder.top.color, equals(AppColors.borderAlt));
    expect(updatedKaryaTanahBox.boxShadow, isNull);
    expect(MockData.unreadChatCount, equals(0));
  });
}
