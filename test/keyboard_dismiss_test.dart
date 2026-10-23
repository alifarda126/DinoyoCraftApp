import 'package:dinoyocraftmobile/core/widgets/keyboard_dismiss_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'KeyboardDismissWrapper menutup keyboard saat mengetuk area di luar textfield (bukan scroll)',
      (tester) async {
    final focusNode = FocusNode();

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => KeyboardDismissWrapper(
          child: child ?? const SizedBox.shrink(),
        ),
        home: Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 100),
              // Area di atas textfield / keyboard
              const Text('Area Di Atas Keyboard'),
              const SizedBox(height: 100),
              TextField(
                focusNode: focusNode,
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );

    // Fokuskan textfield
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    // Ketuk area di atas keyboard / di luar textfield
    await tester.tap(find.text('Area Di Atas Keyboard'));
    await tester.pump();

    // Verifikasi fokus lepas (keyboard tertutup)
    expect(focusNode.hasFocus, isFalse);
  });

  testWidgets(
      'KeyboardDismissWrapper TIDAK menutup keyboard saat melakukan scroll / drag (bisa scroll sambil keyboard terbuka)',
      (tester) async {
    final focusNode = FocusNode();

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => KeyboardDismissWrapper(
          child: child ?? const SizedBox.shrink(),
        ),
        home: Scaffold(
          body: ListView(
            children: [
              TextField(
                focusNode: focusNode,
              ),
              for (int i = 0; i < 30; i++) ListTile(title: Text('Item $i')),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    // Lakukan drag/scroll pada listview
    await tester.drag(find.text('Item 5'), const Offset(0, -100));
    await tester.pump();

    // Verifikasi fokus TETAP aktif (keyboard tidak tertutup saat scroll/drag)
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets(
      'KeyboardDismissWrapper berpindah antar textfield tanpa menutup keyboard',
      (tester) async {
    final focusNode1 = FocusNode();
    final focusNode2 = FocusNode();

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => KeyboardDismissWrapper(
          child: child ?? const SizedBox.shrink(),
        ),
        home: Scaffold(
          body: Column(
            children: [
              TextField(focusNode: focusNode1),
              const SizedBox(height: 50),
              TextField(focusNode: focusNode2),
            ],
          ),
        ),
      ),
    );

    // Fokuskan textfield 1
    await tester.tap(find.byType(TextField).first);
    await tester.pump();
    expect(focusNode1.hasFocus, isTrue);
    expect(focusNode2.hasFocus, isFalse);

    // Pindah fokus langsung ke textfield 2
    await tester.tap(find.byType(TextField).last);
    await tester.pump();

    // Textfield 2 fokus tanpa unfocus total (keyboard tetap terbuka)
    expect(focusNode1.hasFocus, isFalse);
    expect(focusNode2.hasFocus, isTrue);
  });
}
