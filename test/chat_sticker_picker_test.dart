import 'package:dinoyocraftmobile/core/app_settings.dart';
import 'package:dinoyocraftmobile/core/assets.dart';
import 'package:dinoyocraftmobile/core/widgets/sticker_picker_sheet.dart';
import 'package:dinoyocraftmobile/features/chat/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ikon emoji di input bar membuka bottom sheet stiker dan dapat mengirim stiker',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    AppSettings.instance.setThemeMode(AppThemeMode.light);

    await tester.pumpWidget(
      const MaterialApp(
        home: ChatRoomScreen(storeName: 'Dinoyo Ceramic Studio'),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Temukan ikon emote di input bar
    final emoteFinder = find.byWidgetPredicate(
      (w) => w is SvgPicture && w.bytesLoader is SvgAssetLoader &&
          (w.bytesLoader as SvgAssetLoader).assetName == AppAssets.iconEmoji,
    );
    expect(emoteFinder, findsOneWidget);

    // 2. Ketuk ikon emote untuk membuka panel stiker
    await tester.tap(emoteFinder);
    await tester.pumpAndSettle();

    // Pastikan StickerPickerSheet terbuka
    expect(find.byType(StickerPickerSheet), findsOneWidget);
    expect(find.text('Stiker Si Clay'), findsOneWidget);
    expect(find.text('Mascot Tembikar DinoyoCraft'), findsOneWidget);

    // Pastikan stiker-stiker muncul
    expect(find.text('Halo!'), findsOneWidget);
    expect(find.text('Mantap 👍'), findsOneWidget);
    expect(find.text('Packing Aman'), findsWidgets); // di bubble awal dan di sheet
    expect(find.text('Suka Banget ❤️'), findsOneWidget);
    expect(find.text('Workshop'), findsOneWidget);
    expect(find.text('Tanya Dulu'), findsOneWidget);
    expect(find.text('Ada Diskon?'), findsOneWidget);
    expect(find.text('Terima Kasih'), findsOneWidget);

    // 3. Ketuk stiker "Mantap 👍" untuk mengirim
    await tester.tap(find.text('Mantap 👍'));
    await tester.pumpAndSettle();

    // Sheet harus tertutup
    expect(find.byType(StickerPickerSheet), findsNothing);

    // Pesan stiker baru harus muncul di obrolan
    final sentStickerFinder = find.byWidgetPredicate(
      (w) => w is Image && w.image is AssetImage &&
          (w.image as AssetImage).assetName == AppAssets.stickerClayThumbsup,
    );
    expect(sentStickerFinder, findsOneWidget);
  });
}
