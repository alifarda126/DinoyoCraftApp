import 'package:dinoyocraftmobile/core/app_settings.dart';
import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/features/chat/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('bubble chat user dan toko sama warnanya di mode light dan dark',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    // 1. Uji Mode Light
    AppColors.isDark = false;
    AppSettings.instance.setThemeMode(AppThemeMode.light);

    await tester.pumpWidget(
      const MaterialApp(
        home: ChatRoomScreen(storeName: 'Dinoyo Ceramic Studio'),
      ),
    );
    await tester.pumpAndSettle();

    // Pesan toko pertama
    final storeTextFinder = find.textContaining('Halo Kak Customer!');
    expect(storeTextFinder, findsOneWidget);
    final Text storeTextWidgetLight = tester.widget<Text>(storeTextFinder);
    expect(storeTextWidgetLight.style?.color, AppColors.ink);

    // Pesan user pertama
    final userTextFinder = find.textContaining('Halo min, untuk Vas Keramik Minimalis');
    expect(userTextFinder, findsOneWidget);
    final Text userTextWidgetLight = tester.widget<Text>(userTextFinder);
    expect(userTextWidgetLight.style?.color, AppColors.ink);

    // Cek decoration container bubble user & toko di mode light
    final userContainerFinder = find.ancestor(
      of: userTextFinder,
      matching: find.byType(Container),
    ).first;
    final Container userContainerLight = tester.widget<Container>(userContainerFinder);
    final userDecoLight = userContainerLight.decoration as BoxDecoration;
    expect(userDecoLight.color, AppColors.surface);
    expect(userDecoLight.border, Border.all(color: AppColors.borderAlt));

    final storeContainerFinder = find.ancestor(
      of: storeTextFinder,
      matching: find.byType(Container),
    ).first;
    final Container storeContainerLight = tester.widget<Container>(storeContainerFinder);
    final storeDecoLight = storeContainerLight.decoration as BoxDecoration;
    expect(storeDecoLight.color, AppColors.surface);
    expect(storeDecoLight.border, Border.all(color: AppColors.borderAlt));

    // 2. Uji Mode Dark
    AppColors.isDark = true;
    AppSettings.instance.setThemeMode(AppThemeMode.dark);

    await tester.pumpWidget(
      const MaterialApp(
        home: ChatRoomScreen(storeName: 'Dinoyo Ceramic Studio'),
      ),
    );
    await tester.pumpAndSettle();

    final Text storeTextWidgetDark = tester.widget<Text>(storeTextFinder);
    expect(storeTextWidgetDark.style?.color, AppColors.ink);

    final Text userTextWidgetDark = tester.widget<Text>(userTextFinder);
    expect(userTextWidgetDark.style?.color, AppColors.ink);

    final Container userContainerDark = tester.widget<Container>(userContainerFinder);
    final userDecoDark = userContainerDark.decoration as BoxDecoration;
    expect(userDecoDark.color, AppColors.surface);
    expect(userDecoDark.border, Border.all(color: AppColors.borderAlt));

    final Container storeContainerDark = tester.widget<Container>(storeContainerFinder);
    final storeDecoDark = storeContainerDark.decoration as BoxDecoration;
    expect(storeDecoDark.color, AppColors.surface);
    expect(storeDecoDark.border, Border.all(color: AppColors.borderAlt));

    // Reset ke mode light
    AppColors.isDark = false;
    AppSettings.instance.setThemeMode(AppThemeMode.light);
  });
}
