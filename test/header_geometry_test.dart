import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dinoyocraftmobile/core/widgets/dc_app_header.dart';

// Regresi: child header yang lebih pendek dari maxExtent delegate membuat
// SliverGeometry invalid (layoutExtent > paintExtent) → semua tab yang memakai
// SliverPinnedDcHeader jadi blank putih. Align di delegate memaksa child
// mengisi penuh extent. Test ini memastikan tidak kambuh.
void main() {
  Future<void> pumpHeader(WidgetTester tester, double statusBarPad) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(padding: EdgeInsets.only(top: statusBarPad)),
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                const SliverPinnedDcHeader(showActions: false),
                const SliverToBoxAdapter(child: SizedBox(height: 800)),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SliverPinnedDcHeader valid tanpa status bar', (tester) async {
    await pumpHeader(tester, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SliverPinnedDcHeader valid dengan status bar 40px', (
    tester,
  ) async {
    await pumpHeader(tester, 40);
    expect(tester.takeException(), isNull);
  });
}
