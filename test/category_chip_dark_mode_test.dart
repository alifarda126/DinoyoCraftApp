import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/core/widgets/category_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryChip Dark Mode Styling', () {
    testWidgets('Selected chip di mode gelap memiliki stroke dan shadow putih tipis', (tester) async {
      AppColors.isDark = true;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: CategoryChip(
              label: 'Semua',
              selected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      final decoration = animatedContainer.decoration as BoxDecoration;

      // Cek border stroke putih tipis
      expect(decoration.border, isNotNull);
      final border = decoration.border as Border;
      expect(border.top.color.toARGB32(), equals(Colors.white.withValues(alpha: 0.35).toARGB32()));
      expect(border.top.width, equals(1.0));

      // Cek shadow putih tipis
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, equals(1));
      expect(decoration.boxShadow!.first.color.toARGB32(), equals(Colors.white.withValues(alpha: 0.12).toARGB32()));
      expect(decoration.boxShadow!.first.blurRadius, equals(8));
    });

    testWidgets('Unselected chip di mode gelap tidak memiliki stroke putih atau shadow', (tester) async {
      AppColors.isDark = true;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: CategoryChip(
              label: 'Vas',
              selected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      final decoration = animatedContainer.decoration as BoxDecoration;

      // Border transparan agar tidak terjadi layout shift
      expect(decoration.border, isNotNull);
      final border = decoration.border as Border;
      expect(border.top.color, equals(Colors.transparent));

      // Tidak ada shadow
      expect(decoration.boxShadow, isNull);
    });

    testWidgets('Selected chip di mode terang tidak memiliki stroke putih', (tester) async {
      AppColors.isDark = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: CategoryChip(
              label: 'Semua',
              selected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      final decoration = animatedContainer.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.color, equals(Colors.transparent));
      expect(decoration.boxShadow, isNull);
    });
  });
}
